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
    
    public init() {}
    
    /// All currently available archive shows
    public var allArchiveShows = [ArchiveShow]()

    private let networkManager = NetworkManager()
    
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
    /// - Parameter
    ///  - showDetails: Archive show to gather starting times for
    ///  - completion: Returns an archive show's showtimes for display
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
            let archiveShowStart = ArchiveShowStart(startTimeDisplay: DateFormatter.archiveShowStartTimeFormatter.string(from: archiveShowStartTime),
                                                    startTimeDate: archiveShowStartTime)
            archiveShowStartTimes.append(archiveShowStart)

            archiveShowStartTime = Calendar.current.date(byAdding: .minute, value: 5, to: archiveShowStartTime) ?? Date()
        }
        
        completion(archiveShowStartTimes)
    }
    
    
    /// Retrieves the URLs needed to play an archive show
    /// - Parameters:
    ///   - playbackTimeStamp: The show playback start timestamp
    ///   - completion: Playback mp3s and offset
    public func getStreamURLs(for playbackTimeStamp: Date, completion: @escaping ArchivePlayBackCompletion) {
        networkManager.getArchiveStreamURL(
            timestamp: DateFormatter.archiveEndShowFormatter.string(from: playbackTimeStamp)) { [weak self] result in
                guard
                    let strongSelf = self,
                    case let .success(archiveStreamResult) = result,
                    let offset = archiveStreamResult?.offset,
                    var streamURL = archiveStreamResult?.streamURL
                else {
                    completion([], 0)
                    return
                }
                
                var showPlaybackFiles = [URL]()
                streamURL = strongSelf.appendListenerId(toURL: streamURL)
                showPlaybackFiles.append(streamURL)
            
                if var nextStreamURL = archiveStreamResult?.nextStreamURL {
                    nextStreamURL = strongSelf.appendListenerId(toURL: nextStreamURL)
                    showPlaybackFiles.append(nextStreamURL)
                }
                
                completion(showPlaybackFiles, offset)
            }
    }
    
    private func appendListenerId(toURL url: URL) -> URL {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "listenerId", value: KEXPPower.sharedInstance.listenerId.uuidString)
        ]
        if let urlWithListenerId = urlComponents?.url {
            return urlWithListenerId
        }
        return url
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
