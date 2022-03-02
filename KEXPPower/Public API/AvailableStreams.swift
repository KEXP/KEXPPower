//
//  AvailableStreams.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 2/27/22.
//  Copyright © 2022 KEXP. All rights reserved.
//

import Foundation

class AvailableStreams {
    let livePlayback: [URL]

    init(with listenerId: UUID) {
        livePlayback = [
            URL(string: "https://kexp-mp3-32.streamguys1.com/kexp32.mp3?listenerId\(listenerId.uuidString)")!,
            URL(string: "https://kexp-aacPlus-64.streamguys1.com/kexp64.aac?listenerId\(listenerId.uuidString)")!,
            URL(string: "https://kexp-mp3-128.streamguys1.com/kexp128.mp3?listenerId\(listenerId.uuidString)")!
        ]
    }
}
