//
//  Piece.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/20/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

class Piece {
	
	var imageName: String
	var defaultLocation: Int
	
	init(imageName: String, defaultLocation: Int) {
		self.imageName = imageName
		self.defaultLocation = defaultLocation
	}
}
