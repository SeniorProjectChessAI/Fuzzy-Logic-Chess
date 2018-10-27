//
//  MenuViewController.swift
//  Fuzzy Logic Chess
//
//  Created by Pouya Ranjbar on 9/21/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var menu_tableView: UITableView!
	
    //This array of names will apear on the menu
	let title_arr = ["   How to Play ","   New Game"]
	var myIndex = 0
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		menu_tableView.delegate = self
		menu_tableView.dataSource = self
		
		setColors()
		
		// observes notification of difficultyMenuMessage from ViewController
		NotificationCenter.default.addObserver(self, selector: #selector(onRecieveDifficulty(_:)), name: Notification.Name(rawValue: "difficultyMenuTableMessage"), object: nil)
	}
	
	func setColors() {
		switch(DIFFICULTY) {
		case 0: setEasyColor()
		case 1: setMediumColor()
		case 2: setHardColor()
		default: setEasyColor()
		}
	}
	
	
	// Used when difficulty changed after viewDidLoad() function
	@objc func onRecieveDifficulty(_ notification:Notification) {
		print("RECEIVED TABLE DIFFICULTY")
		
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
		menu_tableView.backgroundColor = green
	}
	
	func setMediumColor() {
		let blue = UIColor.init(displayP3Red: 23.0/255.0, green: 42.0/255.0, blue: 83.0/255.0, alpha: 1.0)
		menu_tableView.backgroundColor = blue
	}
	
	func setHardColor() {
		let red = UIColor.init(displayP3Red: 83.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1.0)
		menu_tableView.backgroundColor = red
	}
	
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return title_arr.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell") as!MenuTableViewCell
	
		cell.label_title.text = title_arr[indexPath.row]
		
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		myIndex = indexPath.row
		
		performSegue(withIdentifier: "segue", sender:indexPath.endIndex)
	}
	
	
	func changeView(){
		let storyboard = UIStoryboard(name: "Start", bundle: nil)
		//let nc = storyboard.instantiateViewController(withIdentifier: "fff")
		let vc = storyboard.instantiateViewController(withIdentifier: "StartController")
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.window?.rootViewController = vc
	}

}
