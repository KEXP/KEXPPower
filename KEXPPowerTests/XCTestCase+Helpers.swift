//
//  XCTestCase+Helpers.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 6/30/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import XCTest

extension XCTestCase {
    func retrieveJSONData(for name: String) -> Data? {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
            XCTFail("Invalid filename/path: \(name).json not found in module")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            return data
        } catch {
            XCTFail("Error loading JSON file: \(error.localizedDescription)")
            return nil
        }
    }

    func parseResult<T : Decodable>(parseType: T.Type, data: Data) -> T? {
        do {
            let decodedJSON = try JSONDecoder().decode(parseType.self, from: data)
            
            return decodedJSON

        } catch let error {
            XCTFail(error.localizedDescription)
        }
        
        XCTFail("Failed to parse /(parseType)")
        
        return nil
    }
}
