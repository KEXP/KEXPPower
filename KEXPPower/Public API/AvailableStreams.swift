//
//  AvailableStreams.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 2/27/22.
//  Copyright © 2022 KEXP. All rights reserved.
//

import Foundation

class AvailableStreams {
    let livePlayback: [KEXPPower.StreamingBitRate: URL]

    init(with listenerId: UUID) {
        var livePlaybackDict = [KEXPPower.StreamingBitRate: URL]()
        
        livePlaybackDict[KEXPPower.StreamingBitRate.sixtyFour] = URL(string: "https://kexp.streamguys1.com/kexp64.aac?listenerId=\(listenerId.uuidString)")!
        livePlaybackDict[KEXPPower.StreamingBitRate.oneSixty] = URL(string: "https://kexp.streamguys1.com/kexp160.aac?listenerId=\(listenerId.uuidString)")!
        
        livePlayback = livePlaybackDict
    }
}
