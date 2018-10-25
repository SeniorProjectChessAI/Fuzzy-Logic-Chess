//
//  ViewController.swift
//  Start
//
//  Created by Brian Iruka on 9/20/18.
//  Copyright © 2018 Brian Iruka. All rights reserved.
//

import UIKit

// GLOBAL difficulty variable
var DIFFICULTY = 0

class StartController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


	
	@IBAction func difficultyChanged(_ sender: UISegmentedControl) {
		DIFFICULTY = sender.selectedSegmentIndex
	}
}

