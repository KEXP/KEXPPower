//
//  ArchiveManager.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 9/25/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

/// Class that manages the retrieving of archive shows
public class ArchiveManager {
    public typealias ArchiveCompletion = (_ archiveShows: [ArchiveShow]?) -> Void
    public typealias ArchivePlayBackCompletion = (_ showURLS: [URL], _ offset: Double) -> Void
    public typealias ArchiveShowTimesCompletion = (_ archiveShowTimes: [ArchiveShowStart]) -> (Void)
    public typealias ArchiveShowCompletion = (
        _ archiveShowsByDate: [DateShows],
        _ archiveShowsByShowName: [ShowNameShows],
        _ archiveShowsByHostName: [HostNameShows],
        _ archiveShowsGenre: [GenreShows]
    ) -> Void
    
    /// All currently available archive shows
    public var allArchiveShows = [ArchiveShow]()

    private let networkManager = NetworkManager()
    private var archiveShowMp3s = [URL]()

    public init() {}
    
    private let requestDate: String = {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: .day, value: -13, to: date)!
        let requestDate = DateFormatter.showRequestFormatter.string(from: date)
        
        return requestDate
    } ()

    
    /// Retrieves currently available archive shows from `KEXP`
    /// - Parameter completion: Returns the all archived shows sorted by Date/Show Name/Host Name/Genre
    public func retrieveArchiveShows(completion: @escaping ArchiveShowCompletion) {
        networkManager.getShow(startTimeAfter: requestDate, limit: 200) { [weak self] result in
            guard
                case let .success(showResult) = result,
                let strongSelf = self,
                let shows = showResult?.shows
            else {
                completion([], [], [], [])
                return
            }
            
            let archiveShows = shows.map { ArchiveShow(show: $0) }
            strongSelf.allArchiveShows = strongSelf.updateShowEndTimes(archiveShows: archiveShows)
            
            let showsByDate = strongSelf.getShowsByDate()
            let showsByShowName = strongSelf.getShowsByShowName()
            let showsByHostName = strongSelf.getShowsByHostName()
            let showsByGenre = strongSelf.getShowsByGenre()

            completion(showsByDate, showsByShowName, showsByHostName, showsByGenre)
        }
    }

    /// Generates the available starting times for a particular archived show.
    /// - Parameter completion: Returns an archive show's showtimes for display
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
    
    
    /// Retrieves the URLs needed to play an archive show
    /// - Parameters:
    ///   - archiveShow: The show to retrieve playback mp3s for
    ///   - playbackStartDate: The show playback start date
    ///   - completion: Playback mp3s and offset
    public func getStreamURLs(for archiveShow: ArchiveShow, playbackStartDate: Date? = nil, completion: @escaping ArchivePlayBackCompletion) {
        guard let showEndTime = archiveShow.showEndTime else { return }

        gatherShowMp3s(archiveShow: archiveShow, playbackStartDate: playbackStartDate, calcEndTime: showEndTime, completion: completion)
        archiveShowMp3s.removeAll()
    }
    
    private func gatherShowMp3s(archiveShow: ArchiveShow, playbackStartDate: Date? = nil, calcEndTime: Date, completion: @escaping ArchivePlayBackCompletion) {
        let calculatedEndTimeRequest = calcEndTime.addingTimeInterval(-30)
        let requestEndTime = DateFormatter.archiveEndShowFormatter.string(from: calculatedEndTimeRequest)
        
        
        networkManager.getArchiveStreamURL(bitrate: KEXPPower.selectedArchiveBitRate.rawValue, timestamp: requestEndTime, completion: { [weak self] result in
            guard
                case let .success(archiveStreamResult) = result,
                let startingPoint = playbackStartDate ?? archiveShow.show.startTime,
                let strongSelf = self,
                let offset = archiveStreamResult?.offset,
                var streamURL = archiveStreamResult?.streamURL
            else {
                completion([], 0)
                return
            }
            
            let calculatedStart = calcEndTime.addingTimeInterval(-offset)

            // Append ListenerId to archive stream URL before passing off to completion block
            streamURL = ListenerId.sharedInstance.append(toURL: streamURL)

            if calculatedStart <= startingPoint.addingTimeInterval(30) {
                let elapsed = startingPoint.timeIntervalSince(calculatedStart)
                strongSelf.archiveShowMp3s.insert(streamURL, at: 0)

                completion(strongSelf.archiveShowMp3s, elapsed)
            } else {
                strongSelf.archiveShowMp3s.insert(streamURL, at: 0)
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
    
    private func getShowsByDate() -> [DateShows] {
        var showsByDate = [DateShows]()
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
                showsByDate.append(DateShows(date: showDate, shows: showsOnDate))
            }
        }
        
        return showsByDate.reversed()
    }
    
    private func getShowsByShowName() -> [ShowNameShows] {
        var showsByName = [ShowNameShows]()
        
        let allShowNames = allArchiveShows
            .unique { $0.show.programName }
            .map { $0.show.programName }
            .compactMap { $0 }
        
        allShowNames.forEach { showName in
            let shows = allArchiveShows.filter { $0.show.programName == showName }
        
            showsByName.append(ShowNameShows.init(showName: showName, shows: shows))
        }
        
        showsByName = showsByName.sorted { $0.showName < $1.showName }

        return showsByName
    }
    
    private func getShowsByHostName() -> [HostNameShows] {
        var hostNameShows = [HostNameShows]()
        
        let allHostNames = allArchiveShows
            .unique { $0.show.hostNames?.first }
            .map { $0.show.hostNames?.first  }
            .compactMap { $0 }
        
        allHostNames.forEach { hostName in
            let shows = allArchiveShows.filter { $0.show.hostNames?.first == hostName }
        
            hostNameShows.append(HostNameShows(hostName: hostName, shows: shows))
        }
        
        hostNameShows = hostNameShows.sorted { $0.hostName < $1.hostName }

        return hostNameShows
    }
    
    private func getShowsByGenre() -> [GenreShows] {
        var genreShows = [GenreShows]()
        
        let allGenres = allArchiveShows
            .unique { $0.show.programTags }
            .map { $0.show.programTags }
            .compactMap { $0 }
        
        allGenres.forEach { genre in
            let shows = allArchiveShows.filter { $0.show.programTags == genre }
        
            genreShows.append(GenreShows(genre: genre, shows: shows))
        }
        
        genreShows = genreShows.sorted { $0.genre < $1.genre }

        return genreShows
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

extension Array {
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
