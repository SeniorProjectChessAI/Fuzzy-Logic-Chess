//
//  PopupViewController.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 10/13/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var playAIButton: UIButton!
    @IBOutlet weak var winMessage: UILabel!
	@IBOutlet weak var difficultyControl: UISegmentedControl!
	@IBOutlet weak var playFriendButton: UIButton!

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
		
		// observes notification of winMessage from ViewController
		NotificationCenter.default.addObserver(self, selector: #selector(onRecieveWinMessage(_:)), name: Notification.Name(rawValue: "winMessage"), object: nil)
		
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        popupView.layer.cornerRadius = 10
		playAIButton.layer.cornerRadius = 5
		playFriendButton.layer.cornerRadius = 5
		
		(difficultyControl.subviews[0] as UIView).tintColor = green
		(difficultyControl.subviews[1] as UIView).tintColor = blue
		(difficultyControl.subviews[2] as UIView).tintColor = red
		
		difficultyControl.selectedSegmentIndex = DIFFICULTY
		setPlayAIButtonColors(difficulty: DIFFICULTY)
		
		//print ("game type \(GAME_TYPE)")
		
		if(GAME_TYPE == 0) {
			if let attributedTitle = playAIButton.attributedTitle(for: .normal) {
				let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
				mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: "Rematch")
				playAIButton.setAttributedTitle(mutableAttributedTitle, for: .normal)
			}
		} else {
			if let attributedTitle = playFriendButton.attributedTitle(for: .normal) {
				let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
				mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: "Rematch")
				playFriendButton.setAttributedTitle(mutableAttributedTitle, for: .normal)
			}
		}
    }
	
	
	// On newGame button press: send difficulty level to ViewController
	@IBAction func playAIButtonPress(_ sender: UIButton) {
		GAME_TYPE = 0
		DIFFICULTY = difficultyControl.selectedSegmentIndex
	
		NotificationCenter.default.post(name: Notification.Name(rawValue: "startNewGame"), object: nil, userInfo: [0:0])
		self.view.removeFromSuperview()
	}
	
	
	// set GAME_TYPE to 1 and send startNewGame notification
    @IBAction func playFriendButtonPress(_ sender: UIButton) {
		GAME_TYPE = 1
		
		NotificationCenter.default.post(name: Notification.Name(rawValue: "startNewGame"), object: nil, userInfo: [0:0])
	    self.view.removeFromSuperview()
	}
	
	
	@IBAction func difficultyChanged(_ sender: UISegmentedControl) {
		setPlayAIButtonColors(difficulty: sender.selectedSegmentIndex)
	}
	
	// sets winMessage label text on notification
	@objc func onRecieveWinMessage(_ notification:Notification) {
		
		if let data = notification.userInfo as? [String:String] {
			for (_, message) in data {
				winMessage.text = message
			}
		}
	}
	
	func setPlayAIButtonColors(difficulty: Int) {
		switch(difficulty) {
		case 0: playAIButton.backgroundColor = green
		case 1: playAIButton.backgroundColor = blue
		case 2: playAIButton.backgroundColor = red
		default: playAIButton.backgroundColor = green
		}
	}
}
