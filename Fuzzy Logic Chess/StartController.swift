//
//  ViewController.swift
//  Start
//
//  Created by Brian Iruka on 9/20/18.
//  Copyright © 2018 Brian Iruka. All rights reserved.
//

import UIKit

// GLOBAL difficulty variable
var DIFFICULTY = 0 // GLOBAL difficulty variable
var GAME_TYPE = 0 // GLOBAL game type variable (0 - AI, 1 - two Player)


class StartController: UIViewController {

	@IBOutlet weak var playAIButton: UIButton!
	@IBOutlet weak var playFriendButton: UIButton!
	@IBOutlet weak var howToPlayButton: UIButton!
	@IBOutlet weak var difficultySegmentControl: UISegmentedControl!
	
	
	// OLD Colors
//	let green = UIColor.init(displayP3Red: 50.0/255.0, green: 88.0/255.0, blue: 46.0/255.0, alpha: 1.0)
//	let blue = UIColor.init(displayP3Red: 23.0/255.0, green: 42.0/255.0, blue: 83.0/255.0, alpha: 1.0)
//	let red = UIColor.init(displayP3Red: 83.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1.0)
	
	// NEW Colors
	let green = UIColor.init(displayP3Red: 76.0/255.0, green: 128.0/255.0, blue: 90.0/255.0, alpha: 1.0)
	let blue = UIColor.init(displayP3Red: 58.0/255.0, green: 121.0/255.0, blue: 177.0/255.0, alpha: 1.0)
	let red = UIColor.init(displayP3Red: 172.0/255.0, green: 86.0/255.0, blue: 84.0/255.0, alpha: 1.0)
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		playAIButton.layer.cornerRadius = 5
		playFriendButton.layer.cornerRadius = 5
		howToPlayButton.layer.cornerRadius = 5
		
		(difficultySegmentControl.subviews[0] as UIView).tintColor = green
		
		(difficultySegmentControl.subviews[1] as UIView).tintColor = blue
		
		(difficultySegmentControl.subviews[2] as UIView).tintColor = red
		
		DIFFICULTY = 0
    }


	@IBAction func difficultyChanged(_ sender: UISegmentedControl) {
		DIFFICULTY = sender.selectedSegmentIndex
		
		switch(DIFFICULTY) {
		case 0: playAIButton.backgroundColor = green
		case 1: playAIButton.backgroundColor = blue
		case 2: playAIButton.backgroundColor = red
		default: playAIButton.backgroundColor = green
		}
	}
	
	
	@IBAction func aiSelected(_ sender: UIButton) {
		GAME_TYPE = 0
		print("Game Type: AI \(GAME_TYPE)")
	}
	
	
	@IBAction func twoPlayerSelected(_ sender: UIButton) {
		GAME_TYPE = 1
		print("Game Type: MULTI \(GAME_TYPE)")
	}
}

