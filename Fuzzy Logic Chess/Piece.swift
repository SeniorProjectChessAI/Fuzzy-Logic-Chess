//
//  Piece.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/20/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

class Piece {
	
	var type: PieceType
	var imageName: String
	var location: Int
//	let legalMove: Int = 39
	
	init(type: PieceType, imageName: String, location: Int) {
		self.type = type
		self.imageName = imageName
		self.location = location
	}
	
	// changes location of piece
	func changeLocation(location: Int) {
		self.location = location
	}
}


enum PieceType {
	case King
	case Queen
	case Bishop
	case Knight
	case Rook
	case Pawn
}
