//
//  Knight.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/7/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

class Knight: Piece {
	
	override
	init(type: PieceType, team: Team, imageName: String, location: Int) {
		super.init(type:type, team: team, imageName: imageName, location: location)
		
	}
	override
	func getLegalMoves(board:Board) -> [Int] {
		var legalMoves = [Int]();
		legalMoves = super.getLegalMoves(board: board);		//gets default moves from superclass
//		let pieceFound = board.getPieceAtLocation(location: location + (moveVal/2));
		if(location >= 8 && location % 8 > 1) {		// TOP LEFT
			legalMoves.append(location - 10)
		}
		if(location >= 16 && location % 8 > 0) {		// TOP LEFT
			legalMoves.append(location - 17)
		}
		if(location >= 8 && location % 8 <= 5) {		// TOP RIGHT
			legalMoves.append(location - 6)
		}
		if(location >= 16 && location % 8 <= 6) {		// TOP RIGHT
			legalMoves.append(location - 15)
		}
		if(location <= 55 && location % 8 > 1) {		// BOTTOM LEFT
			legalMoves.append(location + 6)
		}
		if(location <= 47 && location % 8 > 0) {		// BOTTOM LEFT
			legalMoves.append(location + 15)
		}
		if(location <= 55 && location % 8 <= 5) {		// BOTTOM RIGHT
			legalMoves.append(location + 10)
		}
		if(location <= 47 && location % 8 <= 6) {		// BOTTOM RIGHT
			legalMoves.append(location + 17)
		}

		return legalMoves;
	}

	override
	func setHasMoved() {
	}
	
	
}
