//
//  AI.swift
//  Fuzzy Logic Chess
//
//  Created by Brian Iruka on 10/22/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

 var AIKing: Piece!//AIs king

	//get empty spots around King (can me modified for Queen as well)
	func getKingsVulnerableCells(board:Board)->[Int]{
		//loop through blackpiece array to get AI's king, stores it
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

//returns array of AI Moves containing opponents pieces that can reach AI King within their next two moves
//only called when there are vulnerable cells near king
func getKingThreats(board:Board){
	var threatMoves: [AIMove] = []
	for wp in board.whitePieces {
		let oldPieceLocation = wp.location
		let emptyKingSquares: [Int] = getKingsVulnerableCells(board: board)
		for um in wp.getUnfilteredMoves(board: board){
			if (board.getPieceAtLocation(location: um) == nil) {
				if (emptyKingSquares.contains(um)){
					print("King attack eminent")
					let attackProb = Double(7 - wp.getMinRollNeeded(pieceToAttack: AIKing.type))/6
					threatMoves.append(AIMove(pieceToMove: wp, attackedPiece: AIKing, oldPos: oldPieceLocation, newPos: um, isAttackMove: false, moveBenefit:attackProb))
				}
				wp.changeLocation(location: um)
				for um2 in wp.getUnfilteredMoves(board: board){
					if (board.getPieceAtLocation(location: um2) == nil) {
					print("if \(wp.type) at \(oldPieceLocation) moved to \(um), a next possible move could be \(um2)")
						if (emptyKingSquares.contains(um2)){
							print("King attack eminent")
							let attackProb = Double(7 - wp.getMinRollNeeded(pieceToAttack: AIKing.type))/6
							threatMoves.append(AIMove(pieceToMove: wp, attackedPiece: AIKing, oldPos: oldPieceLocation, newPos: um2, isAttackMove: false, moveBenefit:attackProb))
						}
						
					}
				}
			}

		}
		wp.changeLocation(location: oldPieceLocation)
	}
	for t in threatMoves {
		print("cell \(t.newPos) next to king is in danger from \(t.pieceToMove.type) at cell \(t.oldPos)")
		print("can move next to king within the next two moves")
	}
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

func getHelperPieces(board:Board,cellsInDanger:[Int])->[Piece]{
	//find AI pieces that can legally move to block opponents pieces from cells in danger
	var helperPieces = [Piece]()
	for b in board.blackPieces {
		for um in b.getUnfilteredMoves(board: board){
			if (b.type != PieceType.King && cellsInDanger.contains(um) && cellsInDanger.firstIndex(of: um) == 0){
				if (!AIKing.getUnfilteredMoves(board: board).contains(b.location)){//make sure piece isn't already guarding the King
					helperPieces.append(b)
					break
				}
			}
		}
	}
	return helperPieces
}

func getAllLegalMoves(board:Board,thisTeam:Team){//not currently used
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

func getBestLegalMoves(board:Board,thisTeam:Team,turnCounter:Int)->[AIMove]{
	//creates AImove objects for each of AIs possible legal moves, calculates benefit
	//returns an array of each AImove object
	var teamsPieces = (thisTeam == Team.Black) ? board.blackPieces : board.whitePieces
	var otherTeamsPieces = (thisTeam == Team.Black) ? board.whitePieces : board.blackPieces
	//can return
	var availableMoves = [AIMove]()
	var teamCount = 0
	
	for p in teamsPieces {
		for um in p.getUnfilteredMoves(board: board){//evaluates each legal move for each piece
			var attkPiece: Piece
			var attackProb: Double // the chance this piece will capture another
			var defendProb: Double = 0.0 //the chance another piece will capture this piece
			let denominator: Double = 6.0
			var mBenefit: Double = 0.0 //total benefit of moving piece to a certain index
			if (p.getCanMove() && board.getPieceAtLocation(location:um) == nil){
					var neighboringPiecesArray = [Piece]()
					for otp in otherTeamsPieces {//builds array of other teams pieces neighboring legal move iteration
						let dist = getTileIndexDistance(fromLocation: um, toLocation: otp.location)
						if (dist == 1){
							neighboringPiecesArray.append(otp)
						}
					}
					var maxMBenefit: Double = 0.0
					for np in neighboringPiecesArray{//calculates the greatest move benefit of all the pieces neighboring legal move
						attackProb = Double(7 - p.getMinRollNeeded(pieceToAttack: np.type))/denominator
						let currentMaxBenefit = Double(np.pieceValue) * attackProb

						if (currentMaxBenefit > maxMBenefit){
							maxMBenefit = currentMaxBenefit
							defendProb = Double(7 - np.getMinRollNeeded(pieceToAttack: p.type))/denominator
							
						}
					}
					if (turnCounter == 2 && neighboringPiecesArray != nil){
						//I think AI should not consider the negative benefit of moving its piece on its first move, since it has another move to attack a piece
						availableMoves.append(AIMove(pieceToMove: p, attackedPiece: nil, oldPos: p.location, newPos: um, isAttackMove: false, moveBenefit:maxMBenefit/2))
					} else if (turnCounter == 3 && neighboringPiecesArray != nil){
						//AI should consider its own pieces value and possibly move away if its in danger, since other player moves next
						let maxMBenefit = maxMBenefit + Double(p.pieceValue) * defendProb
						availableMoves.append(AIMove(pieceToMove: p, attackedPiece: nil, oldPos: p.location, newPos: um, isAttackMove: false, moveBenefit:maxMBenefit/2))
					}

			}
			else if (p.getCanAttack() && board.getPieceAtLocation(location:um) != nil && board.getPieceAtLocation(location:um)?.team != thisTeam){//if AI has attacking move available
				attkPiece = board.getPieceAtLocation(location: um)!
				attackProb = Double(7 - p.getMinRollNeeded(pieceToAttack: attkPiece.type))/denominator
				mBenefit = Double(attkPiece.pieceValue) * attackProb

				availableMoves.append(AIMove(pieceToMove: p, attackedPiece: attkPiece, oldPos: p.location, newPos: um, isAttackMove: true,moveBenefit:mBenefit))
			}
		}
	}
	return availableMoves
}

func getPiecesDistance(firstPiece:Piece,secondPiece:Piece) ->Int {//returns shortest distance (in cells) between two given pieces
	let firstPieceRow = firstPiece.location / 8
	let secondPieceRow = secondPiece.location / 8
	let firstPieceCol = firstPiece.location % 8
	let secondPieceCol = secondPiece.location % 8
	
	let rowDist = abs(firstPieceRow-secondPieceRow)
	let colDist = abs(firstPieceCol-secondPieceCol)
	
	if (rowDist >= colDist){//distance is the greater value between how many rows/cols two pieces are apart
		return rowDist
	}
	return colDist
}

func getOppsNearKing(board:Board,king:Piece) ->[Piece] {//not currently used
	//returns array of opponents pieces within a two cell radius
	//can be added/tweaked for better King defense
	var oppArray = king.team == Team.Black ? board.blackPieces : board.whitePieces
	var oppsNearKingArray = [Piece]();
	for i in oppArray {
		if (getPiecesDistance(firstPiece: king, secondPiece: i) == 3){
			oppsNearKingArray.append(i)
		}
	}
	return oppsNearKingArray
}

func getTileIndexDistance(fromLocation:Int,toLocation:Int) -> Int {//accepts two ints corresponding to tile location and returns the distance (in cells)
	let toLocationRow = fromLocation / 8
	let fromLocationRow = toLocation / 8
	let toLocationCol = fromLocation % 8
	let fromLocationCol = toLocation % 8
	
	let rowDist = abs(toLocationRow-fromLocationRow)
	let colDist = abs(toLocationCol-fromLocationCol)
	
	if (rowDist >= colDist){
		return rowDist
	}
	return colDist
}

//return the appropriate move based on difficulty level
func getMoveByDifficulty(movesArray:[AIMove],difficulty:String)->AIMove{
	var chosenAIMove:AIMove = movesArray.first!

	switch difficulty {
		case "easy"://picks random element from moves array
			//should be reconfigured so that it only picks a random element with a move benefit > 0
			var movesArray2 = [AIMove]();
			for m in movesArray{
				if m.moveBenefit >= 0{
					movesArray2.append(m)
				}
			}
		chosenAIMove = movesArray2.randomElement()!
		print("easy mode")
		
		
		case "medium"://idea: create a new array that holds the middle 1/3 moves sorted by move benefit
		//for example if moves array has 3 elements m1 with move benefit 1, m2 with 2, and m3 with 3, the new array would only hold m2
		//hint on how to implement: your new array's size would be 1/3 of old array,
		//once you have the new array, simply call array.randomelement()
			
			var movesArray2 = [AIMove]();
			var sum:Double = 0
			var mean:Double = 0
			
			for m in movesArray{
				if m.moveBenefit > 0{
					sum = sum + m.moveBenefit
				}
			}
			mean = sum/Double(movesArray2.capacity)
			mean = mean + mean/2
			
			for m in movesArray{
				if m.moveBenefit >= mean{
					movesArray2.append(m)
				}
			}
			
		chosenAIMove = movesArray2.randomElement()!
		print("medium mode")
		case "hard":
			for m in movesArray{//finds and returns the aimove with the greatest movebenefit
				if (m.moveBenefit > chosenAIMove.moveBenefit){
					chosenAIMove = m
				}
			}
		print("hard mode")
		default:
		print("something went wrong")
	}
	return chosenAIMove
}
