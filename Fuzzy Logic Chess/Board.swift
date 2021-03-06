//
//  Board.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/20/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class Board : UICollectionView {
	
	var blackPieces = [Piece]()
	var whitePieces = [Piece]()
	var aiFirstWavePieces = [Piece]()

	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		
		super.init(frame: frame, collectionViewLayout: layout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	func setup() {
		
		blackPieces.removeAll()
		whitePieces.removeAll()
		aiFirstWavePieces.removeAll()

		
		// Black pieces
		blackPieces.append(Noble(type: PieceType.Rook, team: Team.Black, imageName: "b rook.png", location: 0, firstAction: FirstAction.None, pieceValue: -50))
		blackPieces.append(Knight(type: PieceType.Knight, team: Team.Black, imageName: "b knight.png", location: 1, firstAction: FirstAction.None,pieceValue: -45))
		blackPieces.append(Noble(type: PieceType.Bishop, team: Team.Black, imageName: "b bishop.png", location: 2, firstAction: FirstAction.None , pieceValue: -50))
		blackPieces.append(Noble(type: PieceType.Queen, team: Team.Black, imageName: "b queen.png", location: 3, firstAction: FirstAction.None, pieceValue: -90))
		blackPieces.append(Piece(type: PieceType.King, team: Team.Black, imageName: "b king.png", location: 4, firstAction: FirstAction.None, pieceValue: -999))
		blackPieces.append(Noble(type: PieceType.Bishop, team: Team.Black, imageName: "b bishop.png", location: 5, firstAction: FirstAction.None, pieceValue: -50))
		blackPieces.append(Knight(type: PieceType.Knight, team: Team.Black, imageName: "b knight.png", location: 6, firstAction: FirstAction.None, pieceValue: -45))
		blackPieces.append(Noble(type: PieceType.Rook, team: Team.Black, imageName: "b rook.png", location: 7, firstAction: FirstAction.None, pieceValue: -50))

		for i in 8...15 {
			blackPieces.append(Pawn(type: PieceType.Pawn, team: Team.Black, imageName: "b pawn.png", location: i, firstAction: FirstAction.None, pieceValue: -10))
		}
		
		aiFirstWavePieces.append(getPieceAtLocation(location: 0)!)
		aiFirstWavePieces.append(getPieceAtLocation(location: 2)!)
		aiFirstWavePieces.append(getPieceAtLocation(location: 5)!)
		aiFirstWavePieces.append(getPieceAtLocation(location: 7)!)
		aiFirstWavePieces.append(getPieceAtLocation(location: 9)!)
		aiFirstWavePieces.append(getPieceAtLocation(location: 14)!)

		
		
		// White pieces
		for i in 48...55 {
			whitePieces.append(Pawn(type: PieceType.Pawn, team: Team.White, imageName: "w pawn.png", location: i, firstAction: FirstAction.None, pieceValue: 10))
		}

		whitePieces.append(Noble(type: PieceType.Rook, team: Team.White, imageName: "w rook" + ".png", location: 56, firstAction: FirstAction.None, pieceValue: 50))
		whitePieces.append(Knight(type: PieceType.Knight, team: Team.White, imageName: "w knight" + ".png", location: 57, firstAction: FirstAction.None, pieceValue: 45))
		whitePieces.append(Noble(type: PieceType.Bishop, team: Team.White, imageName: "w bishop" + ".png", location: 58, firstAction: FirstAction.None, pieceValue: 50))
		whitePieces.append(Noble(type: PieceType.Queen, team: Team.White, imageName: "w queen" + ".png", location: 59, firstAction: FirstAction.None, pieceValue: 90))
		whitePieces.append(Piece(type: PieceType.King, team: Team.White, imageName: "w king" + ".png", location: 60, firstAction: FirstAction.None, pieceValue: 999))
		whitePieces.append(Noble(type: PieceType.Bishop, team: Team.White, imageName: "w bishop" + ".png", location: 61, firstAction: FirstAction.None, pieceValue: 50))
		whitePieces.append(Knight(type: PieceType.Knight, team: Team.White, imageName: "w knight" + ".png", location: 62, firstAction: FirstAction.None, pieceValue: 45))
		whitePieces.append(Noble(type: PieceType.Rook, team: Team.White, imageName: "w rook" + ".png", location: 63, firstAction: FirstAction.None, pieceValue: 50))
	

	}
	
	// will return nil if no piece at given location is found
	func getPieceAtLocation(location: Int) -> Piece? {
		
		var gPiece:Piece?
		gPiece = whitePieces.filter{ $0.location == location }.first
		if (gPiece != nil){
			return gPiece
		}
		gPiece = blackPieces.filter{ $0.location == location }.first
		if (gPiece != nil){
			return gPiece
		}

		return nil

	}
	//sort array: whitePieces.sort(by: { $1.location < $0.location })

	
}
