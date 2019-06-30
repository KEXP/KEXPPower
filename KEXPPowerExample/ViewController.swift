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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        networkManager.getPlay { _, _ in
            print("response")
        }
    }
}

