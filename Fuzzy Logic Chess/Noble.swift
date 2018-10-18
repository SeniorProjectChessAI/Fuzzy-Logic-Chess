//
//  Pawn.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/7/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

class Noble: Piece {
	
	override
	init(type: PieceType, team: Team, imageName: String, location: Int, firstAction: FirstAction) {
		super.init(type:type, team: team, imageName: imageName, location: location, firstAction: FirstAction.None)
		
	}
	override
	func getUnfilteredMoves(board: Board) -> [Int] {
		var unfilteredMoves = [Int]();
		unfilteredMoves = super.getUnfilteredMoves(board:board);		//gets default moves from superclass

		var currentTile = location
		

		// Horizontal moves - until edge of board
		// LEFT SIDE
		if(location % 8 != 0) {
			for _ in 0...3 {
				currentTile -= 1
				unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				let cellAfterNext = board.getPieceAtLocation(location: currentTile - 1); //next next tile, possibly nil

				if(currentTile % 8 == 0 || (nextCell != nil) || (cellAfterNext != nil)){
					break;
				}
			}
			currentTile = location	//reset
		}
		
		// RIGHT SIDE
		if(location % 8 != 7) {
			for _ in 0...3 {
				currentTile += 1
				unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				let cellAfterNext = board.getPieceAtLocation(location: currentTile + 1); //next next tile, possibly nil
				if(currentTile % 8 == 7 || (nextCell != nil) || (cellAfterNext != nil)){
					break;
				}
			}
			currentTile = location	//reset
		}
		// VERTICAL moves - until edge of board
		// TOP
		if(location >= 8) {
			for _ in 0...3 {
				currentTile -= 8
				unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				let cellAfterNext = board.getPieceAtLocation(location: currentTile - 8); //next next tile, possibly nil
				if(currentTile <= 8 || (nextCell != nil) || (cellAfterNext != nil)){
					break;
				}
			}

			currentTile = location	//reset
		}

		// BOTTOM
		if(location <= 55) {
			for _ in 0...3 {
				currentTile += 8
				unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				let cellAfterNext = board.getPieceAtLocation(location: currentTile + 8); //next next tile, possibly nil
				if(currentTile >= 55 || (nextCell != nil) || (cellAfterNext != nil)){
					break;
				}
			}

			currentTile = location	//reset
		}
		
		// DIAGONAL moves - until edge of board
		// TOP-LEFT
		if(location >= 8 && location % 8 != 0) {
			for _ in 0...3 {
				currentTile -= 9
				unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				let cellAfterNext = board.getPieceAtLocation(location: currentTile - 9); //next next tile, possibly nil
				if (currentTile <= 8 || currentTile % 8 == 0 || (nextCell != nil) || (cellAfterNext != nil)){
					break;
				}
			}  
			
			currentTile = location	//reset
		}
		
		// TOP-RIGHT
		if(location >= 8 && location % 8 != 7) {
			for _ in 0...3 {
				currentTile -= 7
				unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				let cellAfterNext = board.getPieceAtLocation(location: currentTile - 7); //next next tile, possibly nil
				if (currentTile <= 8 || currentTile % 8 == 7 || (nextCell != nil) || (cellAfterNext != nil)){
					break;
				}
			}
			
			currentTile = location	//reset
		}
		
		// BOTTOM-LEFT
		if(location <= 55 && location % 8 != 0) {
			for _ in 0...3 {
				currentTile += 7
				unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				let cellAfterNext = board.getPieceAtLocation(location: currentTile + 7); //next next tile, possibly nil
				if (currentTile >= 55 || currentTile % 8 == 0 || (nextCell != nil) || (cellAfterNext != nil)){
					break;
				}
			}
			
			currentTile = location	//reset
		}
		// BOTTOM-RIGHT
		if(location <= 55 && location % 8 != 7) {//if piece is not in last row and/or last column
			for _ in 0...3 {
				currentTile += 9
				unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				let cellAfterNext = board.getPieceAtLocation(location: currentTile + 9); //next next tile, possibly nil
				if (currentTile >= 55 || currentTile % 8 == 7 || (nextCell != nil) || (cellAfterNext != nil)){
					break;
				}
			}
			
			currentTile = location	//reset
		}



		return unfilteredMoves;
	}

	
	override
	func getCanMove() -> Bool {
		if (firstMove == FirstAction.Attacked){
			return false
		}
		return true
	}
	
	override
	func getMinRollNeeded(pieceToAttack:PieceType)-> Int {
		if (self.type == PieceType.Queen){
			if (pieceToAttack == PieceType.King || pieceToAttack == PieceType.Queen){
				return 4
			} else if (pieceToAttack == PieceType.Bishop || pieceToAttack == PieceType.Rook){
				return 3
			} else if (pieceToAttack == PieceType.Knight){
				return 2
			} else {
				return 1
			}
		} else {//if attack piece is rook or bishop
			if (pieceToAttack == PieceType.King || pieceToAttack == PieceType.Queen){
				return 5
			} else if (pieceToAttack == PieceType.Bishop || pieceToAttack == PieceType.Rook){
				return 4
			} else if (pieceToAttack == PieceType.Knight){
				return 3
			} else {
				return 2
			}
		}

	}
}
