//
//  Piece.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/20/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

class Piece {
	
	var type: PieceType
	var team: Team
	var imageName: String
	var location: Int

	init(type: PieceType, team: Team, imageName: String, location: Int) {
		self.type = type
		self.team = team
		self.imageName = imageName
		self.location = location
		
	}
	
	// changes location of piece
	func changeLocation(location: Int) {
		self.location = location
		
	}
	
	// returns list of legal moves
	func getLegalMoves(board: Board) -> [Int] {
		var legalMoves = [Int]()
		
		// SURROUNDING THE PIECE...
		// Top, Right, Bottom, Left, Diagonals
		if(location >= 8) {		// TOP
			legalMoves.append(location - 8)
			
			if(location % 8 != 7) {	// TOP-RIGHT
				legalMoves.append(location - 7)
			}
		
			if(location % 8 != 0) {	// TOP-LEFT
				legalMoves.append(location - 9)
			}
		}
		if(location <= 55) {	// BOTTOM
			legalMoves.append(location + 8)
			
			if(location % 8 != 7) {	// BOTTOM-RIGHT
				legalMoves.append(location + 9)
			}
			
			if(location % 8 != 0) {	// BOTTOM-LEFT
				legalMoves.append(location + 7)
			}
		}
		if(location % 8 != 0) {	// LEFT
			legalMoves.append(location - 1)
		}
		if(location % 8 != 7) {	// RIGHT
			legalMoves.append(location + 1)
		}
		
		
		// FOR REFERENCE...
		if(location % 8 == 0) {}	// left side of board
		if(location % 8 == 7) {} // right side of board
		

		
		return legalMoves
	}
	func setHasMoved() {//action after piece moved once
		//overrided by pawn class
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

enum Team {
	case Black
	case White
}
