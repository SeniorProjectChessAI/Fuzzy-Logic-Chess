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
	var previouslySelectedTileIndex: Int?
	var previouslySelectedTileTeam: Team?
	var legalMoves: [Int] = []
	
	
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
		
		rollDie() // Rolls die for presentation purposes..
    }

    
    // Number of views in the collectionView
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 64
	}

    // Populate UICollectionView with Tile objects
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tile = collectionView.dequeueReusableCell(withReuseIdentifier: "tile", for: indexPath) as! Tile
		
		tile.location = indexPath.row
		tile.piece = board.getPieceAtLocation(location: indexPath.row)
		tile.setPiece(piece: board.getPieceAtLocation(location: indexPath.row))
		tile.setLegalMoveView()
		setTileColorVariables(index: indexPath.row)
		

		
		if indexPath.row % 2 == 0 {
			tile.backgroundColor = evenColor
		} else {
			tile.backgroundColor = oddColor
		}
		
		
		return tile
    }
	
	
	// Sets tile color variables according to Tile index
	func setTileColorVariables(index: Int) {
		
		// checks if start of new row and turns on staggered colors
		if(index % 8 == 0) {
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
	}
	
	
	// Called when Tile is clicked
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Tile clicked: \(indexPath.row)")
		
		let tile = board.cellForItem(at: indexPath) as! Tile
		
		if(!tileIsSelected && tile.hasPiece()) {//clicked piece while no cells are highlighted
			legalMoves = tile.piece?.getLegalMoves(board:board) ?? []
			previouslySelectedTileTeam = tile.piece?.team
			legalMoves = showLegalMoves();
			
			previouslySelectedTileColor = tile.backgroundColor
			tile.backgroundColor = UIColor.cyan
			tileIsSelected = true;
			previouslySelectedTileIndex = indexPath.row
		}
		else if(tileIsSelected) {//clicked a piece while some tile is selected
			
			let previousTile = board.cellForItem(at: IndexPath(row: previouslySelectedTileIndex!, section: 0)) as! Tile
			let tile = board.cellForItem(at: indexPath) as! Tile

			if(legalMoves.contains(indexPath.row) ?? false) {
				// set previously selected piece to newly selected tile
				tile.setPiece(piece: previousTile.piece)
				previousTile.piece?.setHasMoved();

				// remove previously selected tile's image and restore original tile color
				previousTile.removePiece()
				previousTile.backgroundColor = previouslySelectedTileColor
				
				// hide legalMoves indicators
				hideLegalMoves()
				
				// reset variables
				tileIsSelected = false
				previouslySelectedTileTeam = nil
				legalMoves.removeAll()
				

				print("piece moved to tile \(indexPath.row) ")
			} else if (tile.piece?.team == previouslySelectedTileTeam){
				print("Switch pieces to move")
				// remove previously selected tile's image and restore original tile color
				previousTile.backgroundColor = previouslySelectedTileColor
				
				// hide legalMoves indicators
				hideLegalMoves()
				
				// reset variables
				tileIsSelected = false
				previouslySelectedTileTeam = nil
				legalMoves.removeAll()
				
				legalMoves = tile.piece?.getLegalMoves(board:board) ?? []
				previouslySelectedTileTeam = tile.piece?.team
				legalMoves = showLegalMoves();
				
				previouslySelectedTileColor = tile.backgroundColor
				tile.backgroundColor = UIColor.cyan
				tileIsSelected = true;
				previouslySelectedTileIndex = indexPath.row
			}
		}
	}
	
	
	func showLegalMoves() -> [Int] {
			for i in legalMoves {
				let availableTile = board.cellForItem(at: IndexPath(row: i, section: 0)) as! Tile
				
				if(availableTile.hasPiece()) {
					if(availableTile.piece?.team != previouslySelectedTileTeam) {
						availableTile.showLegalMoveView(show: true)
					} else {
						let removeInt: Int  = (legalMoves.firstIndex(of: i)!);

						//print(removeInt)
						//print("\(legalMoves[removeInt]) removed")
						legalMoves.remove(at: removeInt)
						//print(legalMoves);

						
					}
				}
				else {
					availableTile.showLegalMoveView(show: true)
				}
			}
		return legalMoves;
	}
	
	
	func hideLegalMoves() {
		for i in legalMoves {
			let availableTile = board.cellForItem(at: IndexPath(row: i, section: 0)) as! Tile
			
			availableTile.showLegalMoveView(show: false)
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
