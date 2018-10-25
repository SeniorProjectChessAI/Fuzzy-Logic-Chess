//
//  Knight.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/7/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

class Knight: Piece {
	override
	init(type: PieceType, team: Team, imageName: String, location: Int, firstAction: FirstAction, pieceValue: Int) {
		super.init(type:type, team: team, imageName: imageName, location: location, firstAction: FirstAction.None, pieceValue: pieceValue)
		
	}
	override
	func getUnfilteredMoves(board:Board) -> [Int] {
		var unfilteredMoves = [Int]();
		unfilteredMoves = super.getUnfilteredMoves(board: board);		//gets default moves from superclass
		if(location >= 8 && location % 8 > 1 && !opponentAtCell(index: location - 10, board: board)) {		// TOP LEFT
			unfilteredMoves.append(location - 10)
		}
		if(location >= 16 && location % 8 > 0 && !opponentAtCell(index: location - 17, board: board)) {		// TOP LEFT
			unfilteredMoves.append(location - 17)
		}
		if(location >= 8 && location % 8 <= 5 && !opponentAtCell(index: location - 6, board: board)) {		// TOP RIGHT
			unfilteredMoves.append(location - 6)
		}
		if(location >= 16 && location % 8 <= 6 && !opponentAtCell(index: location - 15, board: board)) {		// TOP RIGHT
			unfilteredMoves.append(location - 15)
		}
		if(location <= 55 && location % 8 > 1 && !opponentAtCell(index: location + 6, board: board)) {		// BOTTOM LEFT
			unfilteredMoves.append(location + 6)
		}
		if(location <= 47 && location % 8 > 0 && !opponentAtCell(index: location + 15, board: board)) {		// BOTTOM LEFT
			unfilteredMoves.append(location + 15)
		}
		if(location <= 55 && location % 8 <= 5 && !opponentAtCell(index: location + 10, board: board)) {		// BOTTOM RIGHT
			unfilteredMoves.append(location + 10)
		}
		if(location <= 47 && location % 8 <= 6 && !opponentAtCell(index: location + 17, board: board)) {		// BOTTOM RIGHT
			unfilteredMoves.append(location + 17)
		}

		return unfilteredMoves;
	}
	
	override
	 func getCanAttack() -> Bool {
		return true
	}
	override
	func getCanMove() -> Bool {
	return true
	}
	
	func opponentAtCell(index:Int,board:Board)-> Bool {//returns true if opponent piece in given square
		let pieceFound = board.getPieceAtLocation(location: index);
		if (pieceFound != nil && pieceFound?.team != self.team ){
			return true;
		};
		return false;
	}
	
	override
	func getMinRollNeeded(pieceToAttack:PieceType)-> Int {
		if (pieceToAttack == PieceType.King || pieceToAttack == PieceType.Queen){
			return 6
		} else if (pieceToAttack == PieceType.Bishop || pieceToAttack == PieceType.Rook){
			return 5
		} else if (pieceToAttack == PieceType.Knight){
			return 4
		} else {
			return 3
		}
	}
}
