//
//  PlayFormatters.swift
//  KEXPPower
//
//  Created by Jeff Sorrentino on 3/9/23.
//  Copyright © 2023 KEXP. All rights reserved.
//

extension Play {
    
    /// Returns the release year followed by first album label (if any)
    /// Example: "2022 - Matador"
    /// If releaseDate is nil, returns nil
    var formattedReleaseYear: String? {
        guard
            let releaseDateString = releaseDate,
            let releaseDate = DateFormatter.releaseFormatter.date(from: releaseDateString)
        else { return nil }
        
        let releaseYear = "\(DateFormatter.yearFormatter.string(from: releaseDate))"
        
        if let label = labels?.first {
            return releaseYear + " - \(label)"
        } else {
            return releaseYear
        }
    }
}
