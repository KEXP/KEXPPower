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
    public typealias ArchiveShowCompletion = (
        _ archiveShowsByDate: [[Date: [ArchiveShow]]],
        _ archiveShowsByShowName: [[String: [ArchiveShow]]],
        _ archiveShowsByHostName: [[String: [ArchiveShow]]],
        _ archiveShowsGenre: [[String: [ArchiveShow]]]
    ) -> Void
    typealias ArchieveShowTimestamps = (beforeDates: [String], afterDates: [String])
    
    let networkManager = NetworkManager()
    
    public static var archiveShowDates: [Date] = {
        var archiveShowDates = [Date]()
        
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        archiveShowDates.append(date)
        
        for _ in 1...14 {
            date = cal.date(byAdding: .day, value: -1, to: date)!
            archiveShowDates.append(date)
        }
        
        return Array(archiveShowDates.reversed())
    } ()
    
    public init() {}
    
    private func showTimestamps() -> ArchieveShowTimestamps {
        var datesForArchieve = [String]()
        var beforeAirDates = [String]()
        var afterAirDates = [String]()
        
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        datesForArchieve.append(DateFormatter.showRequestFormatter.string(from: date))
        
        for _ in 1...14 {
            date = cal.date(byAdding: .day, value: -1, to: date)!
            datesForArchieve.append(DateFormatter.showRequestFormatter.string(from: date))
        }
        
        beforeAirDates = Array(datesForArchieve.prefix(14))
        afterAirDates = Array(datesForArchieve.dropFirst())
        
        return ArchieveShowTimestamps(beforeDates: beforeAirDates, afterDates: afterAirDates)
    }

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
