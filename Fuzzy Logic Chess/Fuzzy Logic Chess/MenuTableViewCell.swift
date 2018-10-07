//
//  MenuTableViewCell.swift
//  Fuzzy Logic Chess
//
//  Created by Pouya Ranjbar on 9/21/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

	@IBOutlet weak var label_title: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		
		let start_storyboard = UIStoryboard(name: "Start", bundle: nil)
		let vc = start_storyboard.instantiateViewController(withIdentifier: "StartController")
		let htpv = start_storyboard.instantiateViewController(withIdentifier: "HowToPlayView")
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		let selected_text = self.label_title.text
        // Configure the view for the selected state
		if (selected){
			switch selected_text {
			case "Home":
				appDelegate.window?.rootViewController = vc
			case "How to Play ":
				appDelegate.window?.rootViewController = htpv
			case "Change Difficulty":
				print("Change Difficulty")
			case "Restart":
				appDelegate.window?.rootViewController = vc
			default:
				print(selected_text)
			}
		}

	}

}
