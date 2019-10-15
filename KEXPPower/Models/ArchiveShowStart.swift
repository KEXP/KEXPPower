//
//  ArchiveShowStart.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 10/14/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

public struct ArchiveShowStart {
    public let startTimeDisplay: String
    public let startTimeValue: String
    public let startTimeEpochValue: Int
    
    public init(startTimeDisplay: String, startTimeValue: String, startTimeEpochValue: Int) {
        self.startTimeDisplay = startTimeDisplay
        self.startTimeValue = startTimeValue
        self.startTimeEpochValue = startTimeEpochValue
    }
}

