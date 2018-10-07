//  Die.swift
//  Fuzzy Logic Chess
//
//  Created by Reece on 9/18/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//
// Handles RNG rolls of a D6 and displays the result using an appropriate image of a die
import Foundation
import GameplayKit
import UIKit

var last_rolled = -1	// holds the result of the last die roll

let die_blank = #imageLiteral(resourceName: "die0")
let die_1 = #imageLiteral(resourceName: "die1")
let die_2 = #imageLiteral(resourceName: "die2")
let die_3 = #imageLiteral(resourceName: "die3")
let die_4 = #imageLiteral(resourceName: "die4")
let die_5 = #imageLiteral(resourceName: "die5")
let die_6 = #imageLiteral(resourceName: "die6")
let d6 = GKRandomDistribution.d6()

// returns the integer value of the last die roll
func lastDie() -> Int {
	return last_rolled
}
