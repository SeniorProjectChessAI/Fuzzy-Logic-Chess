//
//  Graveyard.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 10/16/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import Foundation
import UIKit



class Graveyard : UICollectionView {
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		
		super.init(frame: frame, collectionViewLayout: layout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	func resetGraveyard() {
		for i in 0...20 { //21 cells total (16 + 5 spaces...)
			let cell = self.cellForItem(at: IndexPath(row: i, section: 0)) as! GraveyardCell
			cell.removePiece()
		}
	}
	
	
	func addPiece(piece: Piece) {
		let index = getCorrectCellIndex(type: piece.type)
		let cell = self.cellForItem(at: IndexPath(row: index, section: 0)) as! GraveyardCell
		cell.setPiece(piece: piece)
	}
	
	
	// returns correct index for the new piece
	func getCorrectCellIndex(type: PieceType) -> Int {
		let index = getNextAvailableIndex(type: type)
		moveImagesPastIndex(index: index)
		return index
	}
	
	
	// finds and returns the next available cell index for the new piece
	func getNextAvailableIndex(type: PieceType) -> Int {
		var index = 0
		var tempIndex = 0
		var groupHasStarted = false
	
		for i in 0...20 { //21 cells total (16 + 5 spaces...)
			let cell = self.cellForItem(at: IndexPath(row: i, section: 0)) as! GraveyardCell
			
			//print("Cell at \(i) has Piece: \(cell.hasPiece()) with Type: \(cell.piece?.type ?? type)")
		
			if(!cell.hasPiece()) {
				if(i == 0) {
					return index
				}
		
				if(i != 1 && tempIndex == (i - 1)) { // if current cell is the second empty cell in a row
					index = i
					return index
				}
				
				if(groupHasStarted) {	// if group of same piece type has started AND the current cell is empty...
					index = i
					return index
				}
				tempIndex = i
			}
			else if(cell.piece?.type == type) {
					groupHasStarted = true
			}
		}
		
		return index
	}

	
	// moves images to the right and leave the passed-in index empty
	func moveImagesPastIndex(index: Int) {
		for i in (index...20).reversed() {
			if(i != 20) {
				let cell = self.cellForItem(at: IndexPath(row: i, section: 0)) as! GraveyardCell
				let nextCell = self.cellForItem(at: IndexPath(row: (i + 1), section: 0)) as! GraveyardCell
		
				nextCell.removePiece()
				nextCell.setPiece(piece: cell.piece)
			
				cell.removePiece()
			}
		}
	}
}


class GraveyardCell : UICollectionViewCell {
	
	@IBOutlet weak var blackImage: UIImageView!
	@IBOutlet weak var whiteImage: UIImageView!
	var piece : Piece?
	

	func displayImage() {
		if(hasPiece()) {
			switch(self.piece!.team) {
				case .Black:
					self.whiteImage.image = UIImage(named: self.piece!.imageName)
				case .White:
					self.blackImage.image = UIImage(named: self.piece!.imageName)
			}
		}
	}
	

	func setPiece(piece: Piece?) {
		self.piece = piece
		
		// checks if piece is in tile and then attempts to set piece image
		if(hasPiece()) {
			displayImage()	// should not abort
		} else {
			removePiece()
		}
	}
	
	
	func hasPiece() -> Bool {
		if(piece == nil) {
			return false
		} else {
			return true
		}
	}
	
	
	func removePiece() {
		self.piece = nil
		if(self.blackImage != nil) {	// need to check if nil because not optional value
			self.blackImage.image = nil
		}
		if(self.whiteImage != nil) {	// need to check if nil because not optional value
			self.whiteImage.image = nil
		}
	}
}
