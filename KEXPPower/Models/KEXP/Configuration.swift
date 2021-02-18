//
//  Configuration.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/15/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

public struct Configuration: Decodable {
    public var kexpStreamUrl = KEXPPower.streamURL
    public var kexpNowPlayingLogo: URL
    public var updated: Int? = 0
}
