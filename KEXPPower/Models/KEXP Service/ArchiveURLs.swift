//
//  ArchiveURLs.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/1/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation

public struct ArchiveURLs: Decodable {
    let archive32BitURL: URL?
    let archive64BitURL: URL?
    let archive128BitURL: URL?
    let archive256BitURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case archive32BitURL = "32"
        case archive64BitURL = "64"
        case archive128BitURL = "128"
        case archive256BitURL = "256"
    }
}
