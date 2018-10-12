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
		if(location >= 8 && location % 8 > 1 && !opponentAtCell(index: location - 10, board: board)) {		// TOP LEFT
			legalMoves.append(location - 10)
		}
		if(location >= 16 && location % 8 > 0 && !opponentAtCell(index: location - 17, board: board)) {		// TOP LEFT
			legalMoves.append(location - 17)
		}
		if(location >= 8 && location % 8 <= 5 && !opponentAtCell(index: location - 6, board: board)) {		// TOP RIGHT
			legalMoves.append(location - 6)
		}
		if(location >= 16 && location % 8 <= 6 && !opponentAtCell(index: location - 15, board: board)) {		// TOP RIGHT
			legalMoves.append(location - 15)
		}
		if(location <= 55 && location % 8 > 1 && !opponentAtCell(index: location + 6, board: board)) {		// BOTTOM LEFT
			legalMoves.append(location + 6)
		}
		if(location <= 47 && location % 8 > 0 && !opponentAtCell(index: location + 15, board: board)) {		// BOTTOM LEFT
			legalMoves.append(location + 15)
		}
		if(location <= 55 && location % 8 <= 5 && !opponentAtCell(index: location + 10, board: board)) {		// BOTTOM RIGHT
			legalMoves.append(location + 10)
		}
		if(location <= 47 && location % 8 <= 6 && !opponentAtCell(index: location + 17, board: board)) {		// BOTTOM RIGHT
			legalMoves.append(location + 17)
		}

		return legalMoves;
	}

	override
	func setHasMoved()  {
	}
	
	func opponentAtCell(index:Int,board:Board)-> Bool {//returns true if opponent piece in given square
		let pieceFound = board.getPieceAtLocation(location: index);
		if (pieceFound != nil && pieceFound?.team != self.team ){
			return true;
		};
		return false;
	}
}
