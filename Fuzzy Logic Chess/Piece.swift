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
	var legalCastlingMovesArray = [Int]()
	var lRookCastlingLocation = -1
	var rRookCastlingLocation = -1
	var rookMoveAddVal = 0
	var pieceValue: Int

	

	init(type: PieceType, team: Team, imageName: String, location: Int, firstAction: FirstAction, pieceValue: Int) {
		self.type = type
		self.team = team
		self.imageName = imageName
		self.location = location
		self.firstMove = firstAction
		self.pieceValue = pieceValue
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
		var kingCanCastleLeft = false
		var kingCanCastleRight = false
		if(location % 8 != 0) {
			for _ in 0...3 {
				currentTile -= 1
				//unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				
				if(nextCell?.type == PieceType.Rook && nextCell?.team == self.team && !(nextCell?.hasMoved)! && !hasMoved){
					print("Castling move available to the left")
					var lCastleLegalMoveVal = location - 2
					unfilteredMoves.append(lCastleLegalMoveVal)
					legalCastlingMovesArray.append(lCastleLegalMoveVal)
					lRookCastlingLocation = currentTile //left rooks location
					//add castle legal move
					kingCanCastleLeft = true
					break;
				} else if (nextCell?.type != nil){
					print("Piece in the way of castling")
					kingCanCastleLeft = false
					break;
				}
			}
			currentTile = location	//reset
		}
		
		if(location % 8 != 0) {
			for _ in 0...3 {
				currentTile += 1
				//unfilteredMoves.append(currentTile)
				let nextCell = board.getPieceAtLocation(location: currentTile); //current tile, possibly nil
				
				if(nextCell?.type == PieceType.Rook && nextCell?.team == self.team && !(nextCell?.hasMoved)! && !hasMoved){
					print("Castling move available to the right")
					var rCastleLegalMoveVal = location + 2
					unfilteredMoves.append(rCastleLegalMoveVal)
					legalCastlingMovesArray.append(rCastleLegalMoveVal)
					rRookCastlingLocation = currentTile
					kingCanCastleRight = true
					break;
					//add castle legal move
				} else if (nextCell?.type != nil){
					print("Piece in the way of castling")
					kingCanCastleRight = false
					break;
				}
			}
			currentTile = location	//reset
		}
		return (kingCanCastleRight || kingCanCastleLeft)
	}
	
	
	func resetCastleLegalMoveVal() {
		legalCastlingMovesArray = [Int]()

	}
	func getCastlingRookLocation(clickedIndex:Int) -> Int{
		if (clickedIndex == 58 || clickedIndex == 2){
			rookMoveAddVal = 1
			return lRookCastlingLocation
		}
		rookMoveAddVal = -1
		return rRookCastlingLocation
	}
	func getMinRollNeeded(pieceToAttack:PieceType)-> Int { //only applies to king, all other pieces overriden
			if (pieceToAttack == PieceType.King || pieceToAttack == PieceType.Queen){
				return 4
			} else if (pieceToAttack == PieceType.Bishop || pieceToAttack == PieceType.Rook){
				return 3
			} else if (pieceToAttack == PieceType.Knight){
				return 2
			} else {
				return 1
			}
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

