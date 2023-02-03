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
            selectedBitRate: KEXPPower.StreamingBitRate.sixtyFour
        )

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

