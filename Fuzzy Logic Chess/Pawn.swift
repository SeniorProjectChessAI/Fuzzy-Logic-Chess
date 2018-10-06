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
	func getLegalMoves() -> [Int] {
		var legalMoves = [Int]();
		legalMoves = super.getLegalMoves();		//gets default moves from superclass

		
		// PAWN only - first move
		if(!hasMoved) {
			if(self.team == Team.Black) {
				legalMoves.append(location + 16)
			}
			else {
				legalMoves.append(location - 16)
			}
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
