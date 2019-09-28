//
//  DateFormatter+StandardFormatters.swift
//  KEXPPower
//
//  Created by Dustin Bergman on 7/1/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import UIKit

extension DateFormatter {
    public static let airDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter
    }()
    
    public static let requestFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:'00Z'"

        return formatter
    }()
    
    public static let playlistDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma MM/dd/YYYY UTC"
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = .current
        
        return formatter
    }()
    
    public static let showRequestFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'07:00:00'Z'"
        
        return formatter
    }()
    

}
