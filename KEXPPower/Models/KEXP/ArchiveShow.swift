//
//  ArchiveShow.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 9/28/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

public struct ArchiveShow {
    public let show: ShowV2
    public var showEndTime: Date? 
    
    public init(show: ShowV2) {
        self.show = show
    }
}
