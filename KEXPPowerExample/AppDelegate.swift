//
//  AppDelegate.swift
//  KEXPPowerExample
//
//  Created by Dustin Bergman on 6/30/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import KEXPPower

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KEXPPower.sharedInstance.setup(
            kexpBaseURL: "https://api.kexp.org",
            availableStreams: retrieveAvailableStreams(),
            selectedArchiveBitRate: .oneTwentyEight,
            defaultStreamIndex: 0,
            backupStreamIndex: 1
        )

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func retrieveAvailableStreams() -> [AvailableStream] {
        let thirtyTwoBitURL = URL(string: "https://kexp-mp3-32.streamguys1.com/kexp32.mp3")!
        let sixtyFourBitURL = URL(string: "https://kexp-aacPlus-64.streamguys1.com/kexp64.aac")!
        let oneTwentyEightBitURL = URL(string: "https://kexp-mp3-128.streamguys1.com/kexp128.mp3")!
        
        let thirtyTwoBit = AvailableStream(streamName: "32 Kbps", streamURL: thirtyTwoBitURL)
        let sixtyFourBit = AvailableStream(streamName: "64 Kbps", streamURL: sixtyFourBitURL)
        let oneTwentyEightBit = AvailableStream(streamName: "128 Kbps", streamURL: oneTwentyEightBitURL)
        
        let availableStream = [thirtyTwoBit, sixtyFourBit, oneTwentyEightBit]
        
        return availableStream
    }
}

