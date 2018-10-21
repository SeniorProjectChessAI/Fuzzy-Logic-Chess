//
//  Pawn.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/6/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

class Pawn: Piece {
	var pawnMoved: Bool = false;	// Pawn only!! -- can move 2 spots if first move..
	
	override
	init(type: PieceType, team: Team, imageName: String, location: Int,firstAction:FirstAction) {
		super.init(type:type, team: team, imageName: imageName, location: location, firstAction: FirstAction.None)
		
	}
	override
	func getUnfilteredMoves(board:Board) -> [Int] {
		var unfilteredMoves = [Int]();
		unfilteredMoves = super.getUnfilteredMoves(board: board);		//gets default moves from superclass
		let moveVal = (self.team == Team.Black) ? 16 : -16
		print(moveVal)
		let isPieceFoundRow1 = board.getPieceAtLocation(location: location + (moveVal/2)); //checks if piece found in the cell in front of pawn
		let isPieceFoundRow2 = board.getPieceAtLocation(location: location + (moveVal)); //checks if piece found in the cell in front of pawn

		// PAWN only - first move
		if(!pawnMoved && (isPieceFoundRow1 == nil) && (isPieceFoundRow2 == nil)) {
			unfilteredMoves.append(location + moveVal)

		}
		for i in unfilteredMoves {
			//print("legal move: \(i)")
		}
		return unfilteredMoves;
	}
	
	override
	func onMove() {
		pawnMoved = true;
	}
	
	override
	func getMinRollNeeded(pieceToAttack:PieceType)-> Int {
		if (pieceToAttack != PieceType.Knight && pieceToAttack != PieceType.Pawn){
			return 6
		} else if (pieceToAttack == PieceType.Knight){
			return 5
		} else {
			return 4
		}
	}
	
}
