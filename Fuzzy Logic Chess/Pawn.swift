//
//  Pawn.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/6/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

class Pawn: Piece {
	var hasMoved: Bool = false;	// Pawn only!! -- can move 2 spots if first move..
	
	override
	init(type: PieceType, team: Team, imageName: String, location: Int) {
		super.init(type:type, team: team, imageName: imageName, location: location)
		
	}
	override
	func getLegalMoves(board:Board) -> [Int] {
		var legalMoves = [Int]();
		legalMoves = super.getLegalMoves(board: board);		//gets default moves from superclass
		let moveVal = (self.team == Team.Black) ? 16 : -16
		print(moveVal)
		let isPieceFoundRow1 = board.getPieceAtLocation(location: location + (moveVal/2)); //checks if piece found in the cell in front of pawn
		let isPieceFoundRow2 = board.getPieceAtLocation(location: location + (moveVal)); //checks if piece found in the cell in front of pawn

		// PAWN only - first move
		if(!hasMoved && (isPieceFoundRow1 == nil) && (isPieceFoundRow2 == nil)) {
			legalMoves.append(location + moveVal)

		}
		for i in legalMoves {
			print("legal move: \(i)")
		}
		return legalMoves;
	}
	
	override
	func setHasMoved() {
		print("Pawn Moved")
		hasMoved = true;
	}
	

}
