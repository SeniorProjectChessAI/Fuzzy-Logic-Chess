//
//  AI.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/22/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

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



//returns an array of cells (near AI king) an opponent's piece can potentially move to on their next turn
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
				if (!AIKing.getUnfilteredMoves(board: board).contains(b.location)){//make sure piece isn't already guarding the King
					helpPieces.append(b)
					break
				}
			}
		}
	}
	return helpPieces
}

func getAllLegalMoves(board:Board,thisTeam:Team){
	//loops through each piece for a specified team and returns its legal moves array
	var teamsPieces = (thisTeam == Team.Black) ? board.blackPieces : board.whitePieces
	
	for p in teamsPieces {
		var legalMovesForPiece = [Int]()
		for um in p.getUnfilteredMoves(board: board){
			if (p.getCanMove() && board.getPieceAtLocation(location:um) == nil){
					legalMovesForPiece.append(um)
				}
			else if (p.getCanAttack() && board.getPieceAtLocation(location:um) != nil && board.getPieceAtLocation(location:um)?.team != thisTeam){
				legalMovesForPiece.append(um)
			}
		}
		print("legal moves for \(p.type) at index \(p.location) are \(legalMovesForPiece)")
	}
	
}
