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
    public var epochShowEndTime: Int?
    
    public init(show: Show) {
        self.show = show
    }
}
