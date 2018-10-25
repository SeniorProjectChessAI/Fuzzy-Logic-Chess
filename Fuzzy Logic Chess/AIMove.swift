//
//  AIMove.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/23/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import Foundation

class AIMove {
	var pieceToMove: Piece
	var attackedPiece: Piece?
	var oldPos: Int
	var newPos: Int
	var isAttackMove: Bool
	var moveBenefit: Double
	
	init(pieceToMove: Piece, attackedPiece: Piece?, oldPos: Int, newPos: Int, isAttackMove: Bool,moveBenefit:Double) {
		self.pieceToMove = pieceToMove
		self.attackedPiece = attackedPiece
		self.oldPos = oldPos
		self.newPos = newPos
		self.isAttackMove = isAttackMove
		self.moveBenefit = moveBenefit
	}
}
