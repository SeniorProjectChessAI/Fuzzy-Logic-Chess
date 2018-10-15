//
//  attackLogic.swift
//  Fuzzy Logic Chess
//
//  Created by Reece on 10/14/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import Foundation


var attacker: PieceType!
var victim: PieceType!
var victimTeam: Team!
var attackSuccess: Bool!

func attack() {
	if (attacker == PieceType.Pawn) {
		if (victim == PieceType.Pawn) {
			attackSuccess = lastDie() >= 4 ? true : false
			return
		}
		else if (victim == PieceType.Knight) {
			attackSuccess = lastDie() >= 5 ? true : false
			return
		}
		else if ((victim == PieceType.Bishop) || (victim == PieceType.Rook) ||
			(victim == PieceType.King) || (victim == PieceType.Queen)) {
			attackSuccess = lastDie() == 6 ? true : false
			return
		}
	}
		
	else if (attacker == PieceType.Knight) {
		if (victim == PieceType.Pawn) {
			attackSuccess = lastDie() >= 3 ? true : false
			return
		}
		else if (victim == PieceType.Knight) {
			attackSuccess = lastDie() >= 4 ? true : false
			return
		}
		else if ((victim == PieceType.Bishop) || (victim == PieceType.Rook)) {
			attackSuccess = lastDie() >= 5 ? true : false
			return
		}
		else if ((victim == PieceType.King) || (victim == PieceType.Queen)) {
			attackSuccess = lastDie() == 6 ? true : false
			return
		}
	}
		
	else if ((attacker == PieceType.Bishop) || attacker == PieceType.Rook) {
		if (victim == PieceType.Pawn) {
			attackSuccess = lastDie() >= 2 ? true : false
			return
		}
		else if (victim == PieceType.Knight) {
			attackSuccess = lastDie() >= 3 ? true : false
			return
		}
		else if ((victim == PieceType.Bishop) || (victim == PieceType.Rook)) {
			attackSuccess = lastDie() >= 4 ? true : false
			return
		}
		else if ((victim == PieceType.King) || (victim == PieceType.Queen)) {
			attackSuccess = lastDie() >= 5 ? true : false
			return
		}
	}
		
	else if ((attacker == PieceType.Queen) || (attacker == PieceType.King)) {
		if (victim == PieceType.Pawn) {
			attackSuccess = true
			return
		}
		else if (victim == PieceType.Knight) {
			attackSuccess = lastDie() >= 2 ? true : false
			return
		}
		else if ((victim == PieceType.Bishop) || (victim == PieceType.Rook)) {
			attackSuccess = lastDie() >= 3 ? true : false
			return
		}
		else if ((victim == PieceType.King) || (victim == PieceType.Queen)) {
			attackSuccess = lastDie() >= 4 ? true : false
			return
		}
	}
}

func attackResult() -> Bool {
	return attackSuccess
}

func lastPieceTarget() -> PieceType {
	return victim
}

func lastTeamTarget() -> Team {
	return victimTeam
}






