//
//  ArchiveManagerTests.swift
//  KEXPPowerTests
//
//  Created by Dustin Bergman on 9/25/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import XCTest
@testable import KEXPPower


class ArchiveManagerTests: XCTestCase {
    
    typealias ArchieveShowDates = (beforeDates: [String], afterDates: [String])
    
    let nm = NetworkManager()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
//        let dispatchGroup = DispatchGroup()
//        ArchiveManager.buildURLS()
//
//        let expectation = self.expectation(description: "Scaling")
//
//        let archieveShowDates = retrieveRequestsTimeStamps()
//        let beforeDates = archieveShowDates.beforeDates
//        let afterDates = archieveShowDates.afterDates
//
//        var showlist = [Show]()
//
//
//        for (index, _) in archieveShowDates.afterDates.enumerated() {
//            dispatchGroup.enter()
//            nm.getShow(airDateBefore: beforeDates[index], airDateAfter: afterDates[index]) { result, showResults in
//                guard let shows = showResults?.showlist else { dispatchGroup.leave(); return }
//
//                showlist += shows
//
//                dispatchGroup.leave()
//            }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            print(showlist)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 10, handler: nil)
        
        let am = ArchiveManager()
        
        am.retrieveArchieveShows()
        
        sleep(5)
        
 
    }
    
    func retrieveRequestsTimeStamps() -> ArchieveShowDates {
        var datesForArchieve = [String]()
        
        var beforeAirDates = [String]()
        var afterAirDates = [String]()
        
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        datesForArchieve.append(DateFormatter.showRequestFormatter.string(from: date))

        for _ in 1...14 {
            date = cal.date(byAdding: .day, value: -1, to: date)!

            datesForArchieve.append(DateFormatter.showRequestFormatter.string(from: date))
        }
   
        beforeAirDates = Array(datesForArchieve.prefix(14))
        afterAirDates = Array(datesForArchieve.dropFirst())
        
        return ArchieveShowDates(beforeDates: beforeAirDates, afterDates: afterAirDates)
    }


}
