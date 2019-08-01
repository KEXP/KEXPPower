//
//  ConfigurationParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 7/15/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class ConfigurationParseTests: XCTestCase {
    var configuration: Configuration?
    
    override func setUp() {
        super.setUp()
        
        let streamOne = AvailableStream(streamName: "streamOne", streamURL: URL(string: "http://StreamOneURL.com")!)
        let streamTwo = AvailableStream(streamName: "streamOne", streamURL: URL(string: "http://StreamTwoURL.com")!)
        
        KEXPPower.setup(
            legacyBaseURL: "legacyBaseURL",
            configurationURL: URL(string: "http://www.kexp.org/config.json")!,
            availableStreams: [streamOne, streamTwo],
            defaultStreamIndex: 0,
            backupStreamIndex: 1)
        
        guard
            let configurationData = retrieveJSONData(for: "ConfigurationSample"),
            let configuration = parseResult(parseType: Configuration.self, data: configurationData)
            else {
                XCTFail("Failed"); return
        }
        
        self.configuration = configuration
    }

    func testConfigurationParsing() {
        XCTAssertNotNil(configuration)
        
        let kexpStreamURL = "https://live-aacplus-64.streamguys1.com/kexp64.aac"
        let kexpBackupStreamURL = "https://kexp-mp3-128.streamguys1.com/kexp128.mp3"
        let kexpNowPlayingLogo = "http://www.kexp.org/content/applications/AppleTV/img/kexp-logo-white.jpg"
        
        XCTAssertTrue(configuration?.kexpStreamUrl.absoluteString == kexpStreamURL)
        XCTAssertTrue(configuration?.kexpBackupStreamUrl.absoluteString == kexpBackupStreamURL)
        XCTAssertTrue(configuration?.kexpNowPlayingLogo.absoluteString == kexpNowPlayingLogo)
        XCTAssertTrue(configuration?.updated == 1453041394)
    }
}
