//
//  ViewController.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/1/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {
	//show the menu 
	
	
    
    
    @IBOutlet weak var board: Board!
    @IBOutlet weak var die_imageView: UIImageView!
	
	//var board: Board!
	
	let light = UIColor.init(displayP3Red: 142.0/255.0, green: 109.0/255.0, blue: 67/255.0, alpha: 1.0)
	let dark = UIColor.init(displayP3Red: 54.0/255.0, green: 38.0/255.0, blue: 19.0/255.0, alpha: 1.0)
	var evenColor = UIColor.init()
	var oddColor = UIColor.init()
	var evenCode = "" // used for custom tile images
	var oddCode = "" // used for custom tile images
	
	var staggerOn = true
	var staggerOff = false;
	
	var menu_vc : MenuViewController!
	
	// variables for selected/clicked cells
	var tileIsSelected: Bool = false
	var previouslySelectedTileColor: UIColor?
	var previouslySelectedTile: Int?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
		
		
		
		// divides collectionView into 8 columns and sets spacing
		let itemSize = (UIScreen.main.bounds.width - 10) / 8
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: itemSize, height: itemSize)
		
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		
		board.collectionViewLayout = layout

	
		board.setup()
		
//		board.reloadData()
//		board.performBatchUpdates(nil, completion: {
//			(result) in
//			self.setNewBoard()
//		})
		
		rollDie() // Rolls die for presentation purposes..
    }
	
//	func setNewBoard() {
//		// set default black pieces
//		for piece in board.blackPieces {
//			print("black index: \(piece.location)")
//			let tile = board.cellForItem(at: IndexPath(row: piece.location, section: 0)) as! Tile
//			tile.foregroundImageView.image = UIImage(named: piece.imageName)
//		}
//
//		// set default white pieces
//		for piece in board.whitePieces {
//			print("white index: \(piece.location)")
//			let tile = board.cellForItem(at: IndexPath(row: piece.location, section: 0)) as! Tile
//			tile.foregroundImageView.image = UIImage(named: piece.imageName)
//		}
//	}

    
    // Number of views in the collectionView
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 64
	}

    // Populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tile = collectionView.dequeueReusableCell(withReuseIdentifier: "tile", for: indexPath) as! Tile
		
		tile.location = indexPath.row
		
		tile.piece = board.getPieceAtLocation(location: indexPath.row)
		
		tile.setPiece(piece: board.getPieceAtLocation(location: indexPath.row))
		
		
		
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
		} else {
			tile.backgroundColor = oddColor
		}
		
		return tile
    }
	
	
	// Called when tile is clicked
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Tile clicked: \(indexPath.row)")
		
		let tile = board.cellForItem(at: indexPath) as! Tile
		
		if(!tileIsSelected && tile.hasPiece()) {
			previouslySelectedTileColor = tile.backgroundColor
			tile.backgroundColor = UIColor.cyan
			tileIsSelected = true;
			previouslySelectedTile = indexPath.row
		}
		else if(tileIsSelected && !tile.hasPiece()) {
			
			let previousTile = board.cellForItem(at: IndexPath(row: previouslySelectedTile!, section: 0)) as! Tile
			
			// set previously selected piece to newly selected tile
			tile.setPiece(piece: previousTile.piece)
				
			// remove previously selected tile's image and restore original tile color
			previousTile.removePiece()
			previousTile.backgroundColor = previouslySelectedTileColor
			
			tileIsSelected = false
			
			print("piece moved to tile \(indexPath.row) ")
		}
	}

	
	//menu button
	@IBAction func menu_action(_ sender: UIBarButtonItem) {
		
		if AppDelegate.menu_bool {
			//show the menu
			show_menu()
		}
		else{
			//close the menu
			close_menu()
			
		}
	}
	
	//function to show and open up the menu
		func show_menu(){
			
			UIView.animate(withDuration: 0.3) { ()->Void in
				
				self.menu_vc.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
				self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
				self.addChild(self.menu_vc)
				self.view.addSubview(self.menu_vc.view)
				AppDelegate.menu_bool = false
			
		}
		
	}
	
	//fucntion to close the menu
		func close_menu(){
			
			
			UIView.animate(withDuration: 0.3, animations: {()->Void in
				self.menu_vc.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)        }) { (finished) in
					self.menu_vc.view.removeFromSuperview()        }
			
			AppDelegate.menu_bool = true
			
		}
	
	// Called during die roll to display result
	func displayDie(num: Int) {
		
		switch num {
		case 1:
			die_imageView.image = die_1
		case 2:
			die_imageView.image = die_2
		case 3:
			die_imageView.image = die_3
		case 4:
			die_imageView.image = die_4
		case 5:
			die_imageView.image = die_5
		case 6:
			die_imageView.image = die_6
		default:
			print("ERROR: Invalid die roll")
		}
	}
	
	// rolls the 6 sided die
	func rollDie(){
		last_rolled = d6.nextInt()
		displayDie(num: last_rolled)
	}
	
	

}
