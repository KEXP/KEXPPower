//
//  ArchiveStreamParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 10/9/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class ArchiveStreamParseTests: XCTestCase {
    var archiveStream: ArchiveStreamResult?
    
    override func setUp() {
        super.setUp()
        
        guard
            let archiveStreamResultData = retrieveJSONData(for: "ArchiveStreamSample"),
            let stream = parseResult(parseType: ArchiveStreamResult.self, data: archiveStreamResultData)
            else {
                XCTFail("Failed"); return
        }
        
        archiveStream = stream
    }
    
    func testArchiveStreamParsing() {
        XCTAssertNotNil(archiveStream)
        
        let streamURLString = "https://kexp-archive.com/someOther.mp3"
å
        XCTAssertEqual(archiveStream?.streamURL?.absoluteString, streamURLString)
        XCTAssertEqual(archiveStream?.offset, 666)
    }
}
