//
//  ViewController.swift
//  KEXPPowerExample
//
//  Created by Dustin Bergman on 6/30/19.
//  Copyright © 2019 KEXP. All rights reserved.
//

import KEXPPower
import UIKit

class ViewController: UIViewController {
    let networkManager = NetworkManager()
    let archiveManager = ArchiveManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        networkManager.getPlay { result in
            print("playResult: \(result)")
        }

        networkManager.getShow { result in
            print("showResult: \(result)")
        }

        networkManager.getShowDetails(with: "47008") { result in
            print("showDetailsResult: \(result)")
        }
   
        let now = Int(Date().timeIntervalSince1970)
        let oneWeekAgo = now - 604800

        networkManager.getShowStart(with: "\(oneWeekAgo)") { result in
            print("showStartResult: \(result)")
        }
        
        archiveManager.retrieveArchieveShows { dateShows, hostShows, shows, genreShows in
            print("retrieveArchieveShows: \(dateShows)")
        }
    }
}

