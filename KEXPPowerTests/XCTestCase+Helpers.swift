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
        guard
            let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "json")
        else {
            XCTFail("Invalid filename/path.")
            
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            
            return data

        } catch let error {
            XCTFail(error.localizedDescription)
        }
        
        XCTFail("Failed to find data)")
        
        return nil
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
