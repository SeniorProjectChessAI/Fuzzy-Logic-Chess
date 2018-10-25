//
//  CustomNavController.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 10/25/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

		// observes notification of difficultyMenuMessage from ViewController
		NotificationCenter.default.addObserver(self, selector: #selector(onRecieveDifficulty(_:)), name: Notification.Name(rawValue: "difficultyMenuMessage"), object: nil)
		
		self.navigationBar.barStyle = UIBarStyle.black
    }
	
	@objc func onRecieveDifficulty(_ notification:Notification) {
		
		print("RECEIVED DIFFICULTY")
		
		if let data = notification.userInfo as? [Int:Int] {
			for (_, difficulty) in data {
				switch(difficulty) {
				case 0: setEasyColor()
				case 1: setMediumColor()
				case 2: setHardColor()
				default: setEasyColor()
				}
			}
		}
	}
	
	func setEasyColor() {
		let green = UIColor.init(displayP3Red: 50.0/255.0, green: 77.0/255.0, blue: 46.0/255.0, alpha: 1.0)
		self.navigationBar.barTintColor = green
	}
	
	func setMediumColor() {
		let blue = UIColor.init(displayP3Red: 23.0/255.0, green: 42.0/255.0, blue: 83.0/255.0, alpha: 1.0)
		self.navigationBar.barTintColor = blue
	}
	
	func setHardColor() {
		let red = UIColor.init(displayP3Red: 83.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1.0)
		self.navigationBar.barTintColor = red
	}
}
