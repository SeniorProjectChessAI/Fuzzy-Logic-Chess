//
//  Tile.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/2/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class Tile: UICollectionViewCell {
	
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var legalMoveView: UIImageView!
	@IBOutlet weak var attackMoveView: UIImageView!
	var location: Int = 0 //default location set to 0
	var piece: Piece?
	
	
	func setPiece(piece: Piece?) {
		self.piece = piece
		self.piece?.changeLocation(location: self.location) // change piece location
		
		// checks if piece is in tile and then attempts to set piece image
		if(hasPiece()) {
			foregroundImageView.image = UIImage(named: (self.piece?.imageName)!)	// should not abort
		} else {
			foregroundImageView.image = nil
		}
	}
	
	func removePiece() {
		self.piece = nil
		self.foregroundImageView.image = nil
	}
	
	func hasPiece() -> Bool {
		if(piece == nil) {
			return false
		} else {
			return true
		}
	}
	
	func setLegalMoveView() {
		self.legalMoveView.image = UIImage(named: "circleSelector65.png")
		showLegalMoveView(show: false)
	}
	
	func setAttackView() {
		self.attackMoveView.image = UIImage(named: "circleSelector65.png")
		showAttackMoveView(show: false)
	}
	
	func showLegalMoveView(show: Bool) {
		if(show) {
			legalMoveView.alpha = 1
		} else {
			legalMoveView.alpha = 0
		}
	}
	
	func showAttackMoveView(show: Bool) {
		if(show) {
			attackMoveView.alpha = 1
		} else {
			attackMoveView.alpha = 0
		}
	}
	
	
	func isEmpty() -> Bool {
		if (foregroundImageView.image == nil) {
			return true
		}
		else { return false }
	}
	
	
	
}
