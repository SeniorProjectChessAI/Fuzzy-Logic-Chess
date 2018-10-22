//
//  AI.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/22/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//
import Foundation

 var AIKing: Piece!

	//get king and queens position
	func getKingsWeakSpots(board:Board)->[Int]{
		//loop through blackpiece array to get AI's king
		
		for i in board.blackPieces {
			if (i.type == PieceType.King){
				AIKing = i
				
				break
			}
		}
		let kingUnfilteredMoves = AIKing!.getUnfilteredMoves(board: board)
		var emptySquaresNearKing = [Int]()
		for m in kingUnfilteredMoves {
			if (board.getPieceAtLocation(location: m) == nil){
				emptySquaresNearKing.append(m)
			}
		}
		return emptySquaresNearKing
	}



	//get the neighboring cells of (king/queen) an opponent can move to before an attack (vulnerable cells_

//returns an array of cells an opponent's piece can potentially move to on their next turn
func getCellsInDanger(board:Board, vulnerableSquares:[Int]) -> [Int]{
	var cellsInDanger = [Int]()
	for w in board.whitePieces{
			for um in w.getUnfilteredMoves(board: board){
				if (vulnerableSquares.contains(um) && !cellsInDanger.contains(um)){
					cellsInDanger.append(um)
					print ("opp's \(w.type) can move to cell \(um) on the next move")
				}
			}
		
	}
	return cellsInDanger
}

func getHelpPieces(board:Board,cellsInDanger:[Int])->[Piece]{
	//find AI pieces that can legally move to block opponents pieces from cells in danger
	var helpPieces = [Piece]()
	for b in board.blackPieces {
		for um in b.getUnfilteredMoves(board: board){
			if (b.type != PieceType.King && cellsInDanger.contains(um) && cellsInDanger.firstIndex(of: um) == 0){
				if (AIKing.getUnfilteredMoves(board: board).contains(b.location)){//make sure piece isn't already guarding the King
				}
				helpPieces.append(b)
				break
			}
		}
	}
	return helpPieces
}
