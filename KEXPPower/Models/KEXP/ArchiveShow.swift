//
//  ArchiveShow.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 9/28/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

public struct ArchiveShow {
    public let show: Show
    public var showEndTime: Date? 
    
    public init(show: Show) {
        self.show = show
    }

    public var showImageURL: URL? {
        show.showImageURL
    }

    public var programImageURL: URL? {
        show.programImageURL
    }
}
