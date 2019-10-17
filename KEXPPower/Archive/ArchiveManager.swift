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
    typealias ArchieveShowTimestamps = (beforeDates: [String], afterDates: [String])
    
    let networkManager = NetworkManager()
    
    private var archieveShowMp3s = [URL]()

    public init() {}

    public func retrieveArchieveShows(completion: @escaping ArchiveShowCompletion) {
        let dispatchGroup = DispatchGroup()
        let archieveShowDates = showTimestamps()
        let beforeDates = archieveShowDates.beforeDates
        let afterDates = archieveShowDates.afterDates
        
        var allShows = [ArchiveShow]()
        
        for (index, _) in archieveShowDates.afterDates.enumerated() {
            dispatchGroup.enter()
            networkManager.getShow(airDateBefore: beforeDates[index], airDateAfter: afterDates[index]) { result, showResults in
                guard let shows = showResults?.showlist else { dispatchGroup.leave(); return }
                
                allShows += shows.map { ArchiveShow(show: $0) }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            allShows = allShows.sorted {
                return $0.show.airDate > $1.show.airDate
            }

            allShows = self.updateShowEndTimes(archiveShows: allShows)
            
            let showsByDate = self.getShowsByDate(allArchiveShows: allShows)
            let showsByShowName = self.getShowsByShowName(allArchiveShows: allShows)
            let showsByHostName = self.getShowsByHostName(allArchiveShows: allShows)
            let showsByGenre = self.getShowsByGenre(allArchiveShows: allShows)

            completion(showsByDate, showsByShowName, showsByHostName, showsByGenre)
        }
    }

    public func archiveStreamStartTimes(with showDetails: ArchiveShow, completion: ArchiveShowTimesCompletion) {
        guard
            let startAirDate = showDetails.show.epochAirDate,
            let showEndTime = showDetails.showEndTime,
            var archiveShowStartTime = Date(timeIntervalSince1970: Double(startAirDate/1000)).nearestHour()
        else {
            return
        }

        var archiveShowStartTimes = [ArchiveShowStart]()

        while archiveShowStartTime < showEndTime {
            let archiveShowStart = ArchiveShowStart(startTimeDisplay: DateFormatter.displayFormatter.string(from: archiveShowStartTime),
                                                    startTimeDate: archiveShowStartTime,
                                                    startTimeEpochValue: Int(archiveShowStartTime.timeIntervalSince1970 * 1000))
            archiveShowStartTimes.append(archiveShowStart)

            archiveShowStartTime = Calendar.current.date(byAdding: .minute, value: 5, to: archiveShowStartTime) ?? Date()
        }
        
        completion(archiveShowStartTimes)
    }
    
    private func calculateEndEpochDate(epochDate: Int64) -> String {
        let eDate = (Double(epochDate) / 1000) - 30
        var time = String()
        let date = Date(timeIntervalSince1970: TimeInterval(eDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        time = dateFormatter.string(from: date)

        return time
    }
    
    public func getStreamURLs(for archiveShow: ArchiveShow, playbackStartDate: Date? = nil, completion: @escaping ArchivePlayBackCompletion) {
        guard let showEndTime = archiveShow.showEndTime else { return }
        
        let calculatedEndTime = showEndTime.addingTimeInterval(-30)

        gatherShowMp3s(archiveShow: archiveShow, playbackStartDate: playbackStartDate, calcEndTime: calculatedEndTime, completion: completion)
        
        archieveShowMp3s.removeAll()
    }
    
    private func gatherShowMp3s(archiveShow: ArchiveShow, playbackStartDate: Date? = nil, calcEndTime: Date, completion: @escaping ArchivePlayBackCompletion) {
        let calucatedEnd = calcEndTime.timeIntervalSince1970 * 1000.0
        let calucatedEndTimeRequest = calculateEndEpochDate(epochDate: Int64(calucatedEnd))
        
        let startingPoint = playbackStartDate ?? archiveShow.show.airDate
        
        networkManager.getArchiveStreamURL(
            bitrate: KEXPPower.sharedInstance.selectedArchiveBitRate.rawValue,
            timestamp: calucatedEndTimeRequest,
            completion: { [weak self] result, archiveStreamResult in
                guard
                    let offset = archiveStreamResult?.offset,
                    let streamURL = archiveStreamResult?.streamURL,
                    case .success = result
                else {
                    return
                }
                
                let calculatedStart = calcEndTime.addingTimeInterval(-offset)
                
                if calculatedStart <= startingPoint.addingTimeInterval(30) {
                    
                    let elapsed = startingPoint.timeIntervalSince(calculatedStart)
                    
                    self?.archieveShowMp3s.insert(streamURL, at: 0)
                    completion(self?.archieveShowMp3s ?? [], elapsed)
                } else {
                    self?.archieveShowMp3s.insert(streamURL, at: 0)
                    
                    let calculatedEndTime = calculatedStart.addingTimeInterval(-30)
                    
                    self?.gatherShowMp3s(archiveShow: archiveShow, playbackStartDate: startingPoint, calcEndTime: calculatedEndTime, completion: completion)
                }
        })
    }

    private func showTimestamps() -> ArchieveShowTimestamps {
        var datesForArchieve = [String]()
        var beforeAirDates = [String]()
        var afterAirDates = [String]()
        
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: .day, value: 1, to: date)!
        datesForArchieve.append(DateFormatter.showRequestFormatter.string(from: date))
        
        for _ in 1...14 {
            date = cal.date(byAdding: .day, value: -1, to: date)!
            datesForArchieve.append(DateFormatter.showRequestFormatter.string(from: date))
        }
        
        beforeAirDates = Array(datesForArchieve.prefix(14))
        afterAirDates = Array(datesForArchieve.dropFirst())
        
        return ArchieveShowTimestamps(beforeDates: beforeAirDates, afterDates: afterAirDates)
    }
    
    private func updateShowEndTimes(archiveShows: [ArchiveShow]) -> [ArchiveShow] {
        var updatedShows = [ArchiveShow]()
        var endTime: Date?
        var endTimeEpoch: Int?

        for (index, archiveShow) in archiveShows.enumerated() {
            let startTime = archiveShow.show.airDate
            var showWithEndTime = archiveShow

            showWithEndTime.showEndTime = endTime
            showWithEndTime.epochShowEndTime = endTimeEpoch

            endTime = startTime
            endTimeEpoch = archiveShow.show.epochAirDate

            if index > 0 && !updatedShows.isEmpty  {
                let lastShowAdded = updatedShows.last

                if isDuplicateEntry(lastShowAdded, show: showWithEndTime) {
                    showWithEndTime.showEndTime = lastShowAdded?.showEndTime
                    showWithEndTime.epochShowEndTime = lastShowAdded?.epochShowEndTime
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

        return lastShow.show.program?.name == show.show.program?.name &&
               lastShow.show.hosts?.first?.name == show.show.hosts?.first?.name
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
                return Calendar.current.isDate(showDate, inSameDayAs: $0.show.airDate)
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
            guard let showName = archiveShow.show.program?.name else { continue }
            
            if showsByName.keys.contains(showName) {
                showsByName[showName]?.append(archiveShow)
            } else {
                showsByName.updateValue([archiveShow], forKey: showName)
            }
        }
        
        var showsByNameSorted = [String: [ArchiveShow]]()

        for (key, value) in showsByName {
            let sortedShows = value.sorted { return $0.show.airDate < $1.show.airDate }

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
            guard let hostName = archiveShow.show.hosts?.first?.name else { continue }
            
            if showsByHostName.keys.contains(hostName) {
                showsByHostName[hostName]?.append(archiveShow)
            } else {
                showsByHostName.updateValue([archiveShow], forKey: hostName)
            }
        }
        
        var showsByHostNameSorted = [String: [ArchiveShow]]()
        
        for (key, value) in showsByHostName {
            let sortedShows = value.sorted { return $0.show.airDate < $1.show.airDate }
            
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
            guard let genre = archiveShow.show.program?.tags else { continue }
            
            if showsByGenre.keys.contains(genre) {
                showsByGenre[genre]?.append(archiveShow)
            } else {
                showsByGenre.updateValue([archiveShow], forKey: genre)
            }
        }
        
        var showsByHostGenreSorted = [String: [ArchiveShow]]()
        
        for (key, value) in showsByGenre {
            let sortedShows = value.sorted { return $0.show.airDate < $1.show.airDate }
            
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

extension Date {
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
}
