//
//  ShowResultParseTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 3/3/20.
//  Copyright © 2020 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower

class ShowResultParseTests: XCTestCase {
    var firstShow: Show?
    
    override func setUp() {
        super.setUp()
        
        guard
            let showResultData = retrieveJSONData(for: "ShowSample"),
            let showResult = parseResult(parseType: ShowResult.self, data: showResultData)
            else {
                XCTFail("Failed"); return
        }
        
        firstShow = showResult.shows?.first
    }
    
    func testShowParsing() {
        XCTAssertNotNil(firstShow)

        XCTAssertTrue(firstShow?.id == 46732)
        XCTAssertTrue(firstShow?.uri == "https://api.kexp.org/v2/shows/46732/")
        XCTAssertTrue(firstShow?.program == 20)
        XCTAssertTrue(firstShow?.programURI == "https://api.kexp.org/v2/programs/20/")
        XCTAssertTrue(firstShow?.hosts?.first == 44)
        XCTAssertTrue(firstShow?.programName == "Wo' Pop")
        XCTAssertTrue(firstShow?.programTags == "Electronic,World")
        XCTAssertTrue(firstShow?.hostNames?.first == "Gabriel Teodros")
        XCTAssertTrue(firstShow?.tagline == "666")
        XCTAssertTrue(firstShow?.imageURI == "https://www.kexp.org/filer/canonical/1529968564/10621/")
        XCTAssertEqual(
            firstShow?.showImageURL,
            URL(string: "https://www.kexp.org/filer/canonical/1529968564/10621/")
        )
        XCTAssertTrue(firstShow?.programImageURI == "https://www.kexp.org/media/filer_public/a6/1d/a61d8d3e-6bab-49df-a2d4-5a55c97fd5f4/variety-800x800.jpg")
        XCTAssertEqual(
            firstShow?.programImageURL,
            URL(string: "https://www.kexp.org/media/filer_public/a6/1d/a61d8d3e-6bab-49df-a2d4-5a55c97fd5f4/variety-800x800.jpg")
        )
        XCTAssertEqual(
            firstShow.flatMap { ArchiveShow(show: $0).showImageURL },
            URL(string: "https://www.kexp.org/filer/canonical/1529968564/10621/")
        )
        XCTAssertEqual(
            firstShow.flatMap { ArchiveShow(show: $0).programImageURL },
            URL(string: "https://www.kexp.org/media/filer_public/a6/1d/a61d8d3e-6bab-49df-a2d4-5a55c97fd5f4/variety-800x800.jpg")
        )
        XCTAssertNotNil(firstShow?.startTime)
    }
}
