//
//  ArchiveManager.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 9/25/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

public class ArchiveManager {
    public typealias ArchiveCompletion = (_ archiveShows: [ArchiveShow]?) -> Void
    public typealias ArchivePlayBackCompletion = (_ showURLS: [URL], _ offset: Double) -> Void
    public typealias ArchiveShowTimesCompletion = (_ archiveShowTimes: [ArchiveShowStart]) -> (Void)
    public typealias ArchiveShowCompletion = (
        _ archiveShowsByDate: [[Date: [ArchiveShow]]],
        _ archiveShowsByShowName: [[String: [ArchiveShow]]],
        _ archiveShowsByHostName: [[String: [ArchiveShow]]],
        _ archiveShowsGenre: [[String: [ArchiveShow]]]
    ) -> Void

    private let networkManager = NetworkManager()
    private var archieveShowMp3s = [URL]()

    public init() {}
    
    private let requestDate: String = {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: .day, value: -13, to: date)!
        let requestDate = DateFormatter.showRequestFormatter.string(from: date)
        
        return requestDate
    } ()

    public func retrieveArchieveShows(completion: @escaping ArchiveShowCompletion) {
        networkManager.getShow(startTimeAfter: requestDate, limit: 200) { [weak self] result in
            guard
                case let .success(showResult) = result,
                let strongSelf = self,
                let shows = showResult?.shows
            else {
                completion([[:]], [[:]], [[:]], [[:]])
                return
            }
            
            var archiveShows = shows.map { ArchiveShow(show: $0) }
            
            archiveShows = strongSelf.updateShowEndTimes(archiveShows: archiveShows)
            
            let showsByDate = strongSelf.getShowsByDate(allArchiveShows: archiveShows)
            let showsByShowName = strongSelf.getShowsByShowName(allArchiveShows: archiveShows)
            let showsByHostName = strongSelf.getShowsByHostName(allArchiveShows: archiveShows)
            let showsByGenre = strongSelf.getShowsByGenre(allArchiveShows: archiveShows)

            completion(showsByDate, showsByShowName, showsByHostName, showsByGenre)
        }
    }

    public func archiveStreamStartTimes(with showDetails: ArchiveShow, completion: ArchiveShowTimesCompletion) {
        guard
            let startAirDate = showDetails.show.startTime,
            let showEndTime = showDetails.showEndTime,
            var archiveShowStartTime = startAirDate.nearestHour()
        else {
            completion([])
            return
        }

        var archiveShowStartTimes = [ArchiveShowStart]()

        while archiveShowStartTime < showEndTime {
            let archiveShowStart = ArchiveShowStart(startTimeDisplay: DateFormatter.displayFormatter.string(from: archiveShowStartTime),
                                                    startTimeDate: archiveShowStartTime)
            archiveShowStartTimes.append(archiveShowStart)

            archiveShowStartTime = Calendar.current.date(byAdding: .minute, value: 5, to: archiveShowStartTime) ?? Date()
        }
        
        completion(archiveShowStartTimes)
    }
    
    public func getStreamURLs(for archiveShow: ArchiveShow, playbackStartDate: Date? = nil, completion: @escaping ArchivePlayBackCompletion) {
        guard let showEndTime = archiveShow.showEndTime else { return }

        gatherShowMp3s(archiveShow: archiveShow, playbackStartDate: playbackStartDate, calcEndTime: showEndTime, completion: completion)
        archieveShowMp3s.removeAll()
    }
    
    private func gatherShowMp3s(archiveShow: ArchiveShow, playbackStartDate: Date? = nil, calcEndTime: Date, completion: @escaping ArchivePlayBackCompletion) {
        let calucatedEndTimeRequest = calcEndTime.addingTimeInterval(-30)
        let requestEndTme = DateFormatter.archiveEndShowFormatter.string(from: calucatedEndTimeRequest)
        let startingPoint = playbackStartDate ?? archiveShow.show.startTime
        
        networkManager.getArchiveStreamURL(bitrate: KEXPPower.sharedInstance.selectedArchiveBitRate.rawValue, timestamp: requestEndTme, completion: { [weak self] result in
            guard
                case let .success(archiveStreamResult) = result,
                let strongSelf = self,
                let offset = archiveStreamResult?.offset,
                let streamURL = archiveStreamResult?.streamURL
            else {
                completion([], 0)
                return
            }
            
            let calculatedStart = calcEndTime.addingTimeInterval(-offset)

            if calculatedStart <= startingPoint!.addingTimeInterval(30) {
                let elapsed = startingPoint?.timeIntervalSince(calculatedStart) ?? 0
                strongSelf.archieveShowMp3s.insert(streamURL, at: 0)

                completion(strongSelf.archieveShowMp3s, elapsed)
            } else {
                strongSelf.archieveShowMp3s.insert(streamURL, at: 0)
                let calculatedEndTime = calculatedStart.addingTimeInterval(-30)
                
                strongSelf.gatherShowMp3s(
                    archiveShow: archiveShow,
                    playbackStartDate: startingPoint,
                    calcEndTime: calculatedEndTime,
                    completion: completion
                )
            }
        })
    }
    
    private func updateShowEndTimes(archiveShows: [ArchiveShow]) -> [ArchiveShow] {
        var updatedShows = [ArchiveShow]()
        var endTime: Date?

        for (index, archiveShow) in archiveShows.enumerated() {
            let startTime = archiveShow.show.startTime
            var showWithEndTime = archiveShow

            showWithEndTime.showEndTime = endTime
            endTime = startTime

            if index > 0 && !updatedShows.isEmpty  {
                let lastShowAdded = updatedShows.last

                if isDuplicateEntry(lastShowAdded, show: showWithEndTime) {
                    showWithEndTime.showEndTime = lastShowAdded?.showEndTime
                    updatedShows.remove(at: updatedShows.count - 1)
                }
            }

            if showWithEndTime.showEndTime != nil {
                updatedShows.append(showWithEndTime)
            }
        }

        return updatedShows.reversed()
    }
    
    private func isDuplicateEntry(_ lastShow: ArchiveShow?, show: ArchiveShow?) -> Bool {
        guard
            let show = show,
            let lastShow = lastShow
        else {
            return false
        }

        return lastShow.show.programName == show.show.programName &&
            lastShow.show.hostNames?.first == show.show.hostNames?.first
    }
    
    private func getShowsByDate(allArchiveShows: [ArchiveShow]) -> [[Date: [ArchiveShow]]] {
        var archiveCalendar = [[Date: [ArchiveShow]]]()
        var twoWeekDates = [Date]()
        var date = Calendar.current.startOfDay(for: Date())
        date = Calendar.current.date(byAdding: .day, value: -13, to: date)!

        for _ in 0...13 {
            twoWeekDates.append(date)
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }

        twoWeekDates.forEach{ showDate in
            let showsOnDate = allArchiveShows.filter {
                guard let startTime = $0.show.startTime else { return false }
                
                return Calendar.current.isDate(showDate, inSameDayAs: startTime)
            }
            
            if !showsOnDate.isEmpty {
                var dateWithShows = [Date: [ArchiveShow]]()
                dateWithShows[showDate] = showsOnDate
                archiveCalendar.append(dateWithShows)
            }
        }
        
        return archiveCalendar
    }
    
    private func getShowsByShowName(allArchiveShows: [ArchiveShow]) -> [[String: [ArchiveShow]]] {
        var archiveShowsByName = [[String: [ArchiveShow]]]()
        var showsByName = [String: [ArchiveShow]]()
        
        for archiveShow in allArchiveShows {
            guard let showName = archiveShow.show.programName else { continue }
            
            if showsByName.keys.contains(showName) {
                showsByName[showName]?.append(archiveShow)
            } else {
                showsByName.updateValue([archiveShow], forKey: showName)
            }
        }
        
        var showsByNameSorted = [String: [ArchiveShow]]()

        for (key, value) in showsByName {
            let sortedShows = value.sorted {
                guard
                    let startTime0 = $0.show.startTime,
                    let startTime1 = $1.show.startTime
                else {
                    return false
                }
                
                return startTime0 < startTime1
            }

            showsByNameSorted[key] = sortedShows
        }
        
        archiveShowsByName = showsByNameSorted.map {
            return ["\($0.key)": $0.value]
        }
        
        archiveShowsByName = archiveShowsByName.sorted {
            guard
                let name0 = $0.keys.first,
                let name1 = $1.keys.first
            else {
                return false
            }
            
            return name0 < name1
        }

        return archiveShowsByName
    }
    
    private func getShowsByHostName(allArchiveShows: [ArchiveShow]) -> [[String: [ArchiveShow]]] {
        var archiveShowsByHostName = [[String: [ArchiveShow]]]()
        var showsByHostName = [String: [ArchiveShow]]()
        
        for archiveShow in allArchiveShows {
            guard let hostName = archiveShow.show.hostNames?.first else { continue }
            
            if showsByHostName.keys.contains(hostName) {
                showsByHostName[hostName]?.append(archiveShow)
            } else {
                showsByHostName.updateValue([archiveShow], forKey: hostName)
            }
        }
        
        var showsByHostNameSorted = [String: [ArchiveShow]]()
        
        for (key, value) in showsByHostName {
            let sortedShows = value.sorted {
                guard
                      let startTime0 = $0.show.startTime,
                      let startTime1 = $1.show.startTime
                  else {
                      return false
                  }
                
                return startTime0 < startTime1
            }
            
            showsByHostNameSorted[key] = sortedShows
        }
        
        archiveShowsByHostName = showsByHostNameSorted.map {
            return ["\($0.key)": $0.value]
        }
        
        archiveShowsByHostName = archiveShowsByHostName.sorted {
            guard
                let name0 = $0.keys.first,
                let name1 = $1.keys.first
                else {
                    return false
            }
            
            return name0 < name1
        }
        
        return archiveShowsByHostName
    }
    
    private func getShowsByGenre(allArchiveShows: [ArchiveShow]) -> [[String: [ArchiveShow]]] {
        var archiveShowsByGenre = [[String: [ArchiveShow]]]()
        var showsByGenre = [String: [ArchiveShow]]()
        
        for archiveShow in allArchiveShows {
            guard let genre = archiveShow.show.programTags else { continue }
            
            if showsByGenre.keys.contains(genre) {
                showsByGenre[genre]?.append(archiveShow)
            } else {
                showsByGenre.updateValue([archiveShow], forKey: genre)
            }
        }
        
        var showsByHostGenreSorted = [String: [ArchiveShow]]()
        
        for (key, value) in showsByGenre {
            let sortedShows = value.sorted {
                guard
                    let startTime0 = $0.show.startTime,
                    let startTime1 = $1.show.startTime
                else {
                    return false
                }
            
                return startTime0 < startTime1
            }
            
            showsByHostGenreSorted[key] = sortedShows
        }
        
        archiveShowsByGenre = showsByHostGenreSorted.map {
            return ["\($0.key)": $0.value]
        }
        
        archiveShowsByGenre = archiveShowsByGenre.sorted {
            guard
                let name0 = $0.keys.first,
                let name1 = $1.keys.first
                else {
                    return false
            }
            
            return name0 < name1
        }
        
        return archiveShowsByGenre
    }
}

// Move this to better place.
extension Date {
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
}
