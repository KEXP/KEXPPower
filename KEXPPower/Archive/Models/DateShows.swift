//
//  DateShows.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 4/25/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import Foundation

public struct DateShows {
    public let date: Date
    public let shows: [ArchiveShow]
    
    public init(date: Date, shows: [ArchiveShow]) {
        self.date = date
        self.shows = shows
    }
}
