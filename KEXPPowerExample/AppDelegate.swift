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
        
        // Test values in place.
        let streamOne = AvailableStream(streamName: "streamOne", streamURL: URL(string: "http://StreamOneURL.com")!)
        let streamTwo = AvailableStream(streamName: "streamOne", streamURL: URL(string: "http://StreamTwoURL.com")!)
        
        KEXPPower.setup(
            legacyBaseURL: "http://baseKEXPURLString.org",
            availableStreams: [streamOne, streamTwo],
            defaultStreamIndex: 0,
            backupStreamIndex: 1)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

