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
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var winMessage: UILabel!
	@IBOutlet weak var difficultyControl: UISegmentedControl!
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// observes notification of winMessage from ViewController
		NotificationCenter.default.addObserver(self, selector: #selector(onRecieveWinMessage(_:)), name: Notification.Name(rawValue: "winMessage"), object: nil)
		
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        popupView.layer.cornerRadius = 10
        newGameButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }
	
	
    @IBAction func closePopup(_ sender: Any) {
        self.view.removeFromSuperview()
    }
	
	
	// On newGame button press: send difficulty level to ViewController
    @IBAction func newGame(_ sender: Any) {
		
		let sendData = ["difficulty" : difficultyControl.selectedSegmentIndex]
		
		NotificationCenter.default.post(name: Notification.Name(rawValue: "startNewGame"), object: nil, userInfo: sendData)
		
		self.view.removeFromSuperview()
    }
	
	
	// sets winMessage label text on notification
	@objc func onRecieveWinMessage(_ notification:Notification) {
		
		if let data = notification.userInfo as? [String:String] {
			for (_, message) in data {
				winMessage.text = message
			}
		}
	}
}
