//
//  ViewController.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/1/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	@IBOutlet weak var myCollectionView: UICollectionView!
	let light = UIColor.init(displayP3Red: 142.0/255.0, green: 109.0/255.0, blue: 67/255.0, alpha: 1.0)
	let dark = UIColor.init(displayP3Red: 54.0/255.0, green: 38.0/255.0, blue: 19.0/255.0, alpha: 1.0)
	var evenColor = UIColor.init()
	var oddColor = UIColor.init()
	var evenCode = "" // used for custom tile images
	var oddCode = "" // used for custom tile images
	
	var staggerOn = true
	var staggerOff = false;
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// divides collectionView into 8 columns and sets spacing
		let itemSize = UIScreen.main.bounds.width / 8
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: itemSize, height: itemSize)
		
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		
		myCollectionView.collectionViewLayout = layout
    }

    
    // Number of views in the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64 // 8 x 8 board
    }

    // Populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tile = collectionView.dequeueReusableCell(withReuseIdentifier: "tile", for: indexPath) as! Tile
        //tile.myImageView.image = UIImage(named: "images/d1.png")
		
		
		tile.myLabel.text = String("")//indexPath.row)
		
		// checks if start of new row and turns on staggered colors
		if(indexPath.row % 8 == 0) {
			if(staggerOn) {
				staggerOn = false
				staggerOff = true
				
				evenColor = dark
				oddColor = light
				
				//evenCode = "d" // used for custom tile images
				//oddCode = "l" // used for custom tile images
			} else {
				staggerOn = true
				staggerOff = false
				
				evenColor = light
				oddColor = dark
				
				//evenCode = "l" // used for custom tile images
				//oddCode = "d" // used for custom tile images
			}
		}

		
		if indexPath.row % 2 == 0 {
			tile.backgroundColor = evenColor
			
			//tile.myImageView.image = UIImage(named: ("images/cells/\(evenCode)\(arc4random_uniform(8) + 1).png"))
			
		} else {
			tile.backgroundColor = oddColor
			
			//tile.myImageView.image = UIImage(named: ("images/cells/\(oddCode)\(arc4random_uniform(8) + 1).png"))
		}
		
		
        return tile
    }
	
	// Called when tile is clicked
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Tile clicked: \(indexPath.row)")
	}
}
