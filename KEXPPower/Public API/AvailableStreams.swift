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
        
        livePlaybackDict[KEXPPower.StreamingBitRate.thirtyTwo] = URL(string: "https://kexp-mp3-32.streamguys1.com/kexp32.mp3?listenerId=\(listenerId.uuidString)")!
        livePlaybackDict[KEXPPower.StreamingBitRate.sixtyFour] = URL(string: "https://kexp-aacPlus-64.streamguys1.com/kexp64.aac?listenerId=\(listenerId.uuidString)")!
        livePlaybackDict[KEXPPower.StreamingBitRate.oneTwentyEight] = URL(string: "https://kexp-mp3-128.streamguys1.com/kexp128.mp3?listenerId=\(listenerId.uuidString)")!
        
        livePlayback = livePlaybackDict
    }
}
