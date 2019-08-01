//
//  Reachability.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/8/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import Foundation
import SystemConfiguration

class Reachability {
    private let domain: String
    
    required init(domain: String = "https://www.kexp.org") {
        self.domain = domain
    }
    
    func isReachable() -> Bool {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, domain) else {
            /// if it fails let's assume reachable
            return true
        }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}
