//
//  Board.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/20/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import Foundation

class Board {
	
	var blackPieces = [Piece]()
	var whitePieces = [Piece]()
	
	init() {
		
		// Black pieces
		blackPieces.append(Piece(imageName: "b rook.png", defaultLocation: 0))
		blackPieces.append(Piece(imageName: "b knight.png", defaultLocation: 1))
		blackPieces.append(Piece(imageName: "b bishop.png", defaultLocation: 2))
		blackPieces.append(Piece(imageName: "b queen.png", defaultLocation: 3))
		blackPieces.append(Piece(imageName: "b king.png", defaultLocation: 4))
		blackPieces.append(Piece(imageName: "b bishop.png", defaultLocation: 5))
		blackPieces.append(Piece(imageName: "b knight.png", defaultLocation: 6))
		blackPieces.append(Piece(imageName: "b rook.png", defaultLocation: 7))
		
		for i in 8...15 {
			blackPieces.append(Piece(imageName: "b pawn.png", defaultLocation: i))
		}
		
		
		// White pieces
		for i in 48...55 {
			whitePieces.append(Piece(imageName: "w pawn.png", defaultLocation: i))
		}
		
		whitePieces.append(Piece(imageName: ("w rook" + ".png"), defaultLocation: 56))
		whitePieces.append(Piece(imageName: ("w knight" + ".png"), defaultLocation: 57))
		whitePieces.append(Piece(imageName: ("w bishop" + ".png"), defaultLocation: 58))
		whitePieces.append(Piece(imageName: ("w queen" + ".png"), defaultLocation: 59))
		whitePieces.append(Piece(imageName: ("w king" + ".png"), defaultLocation: 60))
		whitePieces.append(Piece(imageName: ("w bishop" + ".png"), defaultLocation: 61))
		whitePieces.append(Piece(imageName: ("w knight" + ".png"), defaultLocation: 62))
		whitePieces.append(Piece(imageName: ("w rook" + ".png"), defaultLocation: 63))
	}
	
	
}
