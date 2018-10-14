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
	var firstMove: FirstAction
	var hasMoved: Bool = false;
	var unfilteredMoves = [Int]()
	var castleLegalMoveVal = -1
	var rookCastlingLocation = -1

	init(type: PieceType, team: Team, imageName: String, location: Int, firstAction: FirstAction) {
		self.type = type
		self.team = team
		self.imageName = imageName
		self.location = location
		self.firstMove = firstAction
		
	}
	
	// changes location of piece
	func changeLocation(location: Int) {
		self.location = location
		
	}
	
	// returns list of legal moves
	func getUnfilteredMoves(board: Board) -> [Int] {
		unfilteredMoves = [Int]()
		
		// SURROUNDING THE PIECE...
		// Top, Right, Bottom, Left, Diagonals
		if(location >= 8) {		// TOP
			unfilteredMoves.append(location - 8)
			
			if(location % 8 != 7) {	// TOP-RIGHT
				unfilteredMoves.append(location - 7)
			}
		
			if(location % 8 != 0) {	// TOP-LEFT
				unfilteredMoves.append(location - 9)
			}
		}
		if(location <= 55) {	// BOTTOM
			unfilteredMoves.append(location + 8)
			
			if(location % 8 != 7) {	// BOTTOM-RIGHT
				unfilteredMoves.append(location + 9)
			}
			
			if(location % 8 != 0) {	// BOTTOM-LEFT
				unfilteredMoves.append(location + 7)
			}
		}
		if(location % 8 != 0) {	// LEFT
			unfilteredMoves.append(location - 1)
		}
		if(location % 8 != 7) {	// RIGHT
			unfilteredMoves.append(location + 1)
		}
		
		if (self.type == PieceType.King){
			print("Checking for castle opportunity")
			isCastleAvailable(board: board)
		}
		//loop through legal moves
		//build two arrays of indexes of cells that contain legal moves to cells with opponents pieces, and cells without
		//if firstaction is none, do nothing
		//pass in turncounter, if 1 or 3 and turncounter is attacked or moved, remove corresponding legal moves


//			if (board.getPieceAtLocation(location: moveIndex)?.team != self.team){
//			print("opponent piece in cell \(moveIndex)")
//			} else {
//				print("no opponent piece in cell \(moveIndex)")
//
//			}
		
		
		// FOR REFERENCE...
		if(location % 8 == 0) {}	// left side of board
		if(location % 8 == 7) {} // right side of board
		

		
		return unfilteredMoves
	}
	func onMove() {//action after piece moved once
		hasMoved = true;
	}

	func getCanMove() -> Bool {
		if (firstMove != FirstAction.None){
			return false
		}
		return true
}
	
	func getCanAttack() -> Bool {
		if (firstMove == FirstAction.Attacked){
			return false
		}
		return true
	}
	func isCastleAvailable(board:Board) -> Bool {
		print("King has moved before: \(hasMoved)")
		
		var currentTile = location

		if(location % 8 != 0) {
			for _ in 0...3 {
				currentTile -= 1
				//unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				
				if(nextCell?.type == PieceType.Rook && nextCell?.team == self.team && !(nextCell?.hasMoved)!){
					print("Castling move available to the left")
					unfilteredMoves.append(location-2)
					castleLegalMoveVal = location - 2
					rookCastlingLocation = currentTile
					return true;
					//add castle legal move
				} else if (nextCell?.type != nil){
					print("Piece in the way of castling")
					break;
				}
			}
			currentTile = location	//reset
		}
		return false
	}
	
	func getCastleLegalMoveVal() -> Int {
		return castleLegalMoveVal
	}
	
	func resetCastleLegalMoveVal() {
		castleLegalMoveVal = -1
	}
	func getCastlingRookLocation() -> Int{
		return rookCastlingLocation
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

enum Team: String {
	case Black = "Black"
	case White = "White"
}

enum FirstAction {
	case Attacked
	case Moved
	case None
}

