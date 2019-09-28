//
//  ArchiveManager.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 9/25/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

public class ArchiveManager {
    typealias ArchieveShowTimestamps = (beforeDates: [String], afterDates: [String])
    
    let networkManager = NetworkManager()
    
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

    public func retrieveArchieveShows() {
        let dispatchGroup = DispatchGroup()
        let archieveShowDates = showTimestamps()
        let beforeDates = archieveShowDates.beforeDates
        let afterDates = archieveShowDates.afterDates
        
        var allShows = [Show]()
        
        for (index, _) in archieveShowDates.afterDates.enumerated() {
            dispatchGroup.enter()
            networkManager.getShow(airDateBefore: beforeDates[index], airDateAfter: afterDates[index]) { result, showResults in
                guard let shows = showResults?.showlist else { dispatchGroup.leave(); return }
                
                allShows += shows
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print(allShows)
            
            allShows = allShows.sorted {
                return $0.airDate < $1.airDate
            }
            
            print(allShows)
        }
    }
}
