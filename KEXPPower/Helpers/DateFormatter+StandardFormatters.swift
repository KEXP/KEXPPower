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
    
    public static let archiveEndShowFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    // DELETEME
    func formatEpochDate(epochDate: Int64) -> String {
        let eDate = (Double(epochDate) / 1000) - 30
        var time = String()
        let date = Date(timeIntervalSince1970: TimeInterval(eDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        time = dateFormatter.string(from: date)
        
        return time
    }
    
    public static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    public static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    public static let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    public static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    public static let archiveShowDayDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    public static let archiveShowNowPlayingFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMdeeee")
        return formatter
    }()
    
    public static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()
}
