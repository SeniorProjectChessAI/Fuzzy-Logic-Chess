//
//  MenuViewController.swift
//  Fuzzy Logic Chess
//
//  Created by Pouya Ranjbar on 9/21/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

	//This array of names will apear on the menu
	let title_arr = ["Home","Welcome to the Fuzzy Chess","How to Play the Game","Difficulty","New Game"]
	
	
    @IBOutlet weak var menu_tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		menu_tableView.delegate = self
		menu_tableView.dataSource = self
		
	}
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	return title_arr.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell") as!MenuTableViewCell
	
	cell.label_title.text = title_arr[indexPath.row]
	return cell
}

}
