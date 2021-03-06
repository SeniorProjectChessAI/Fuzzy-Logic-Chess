//
//  ViewController.swift
//  Fuzzy Logic Chess
//
//  Created by Illya Balakin on 9/1/18.
//  Copyright © 2018 KSU CS Seniors Project 6A. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    //show the menu
    
    @IBOutlet weak var mainBackgroundImage: UIImageView!
    @IBOutlet weak var blackGraveyard: Graveyard!
    @IBOutlet weak var whiteGraveyard: Graveyard!
    @IBOutlet weak var board: Board!
    @IBOutlet weak var die_imageView: UIImageView!
    @IBOutlet weak var aiWaitingSymbol: UIActivityIndicatorView!
    @IBOutlet weak var aiWaitingText: UITextField!
    @IBOutlet weak var aiStackView: UIStackView!
    @IBOutlet weak var swipeView: UIStackView!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var swipeImage: UIImageView!
    @IBOutlet weak var blackTeamLabel: UILabel!
    @IBOutlet weak var whiteTeamLabel: UILabel!
    @IBOutlet weak var currentTeamLabel: UILabel!
    @IBOutlet weak var turnBallWhite1: UIImageView!
    @IBOutlet weak var turnBallWhite2: UIImageView!
    @IBOutlet weak var turnBallBlack1: UIImageView!
    @IBOutlet weak var turnBallBlack2: UIImageView!

    // board variables
    var light = UIColor.init()
    var dark = UIColor.init()
    let whitePieceColor = UIColor.init(displayP3Red: 186.0/255.0, green: 166.0/255.0, blue: 136.0/255.0, alpha: 1.0)
    let darkPieceColor = UIColor.init(displayP3Red: 54.0/255.0, green: 38.0/255.0, blue: 19.0/255.0, alpha: 1.0)
    var evenColor = UIColor.init()
    var oddColor = UIColor.init()
    var evenCode = "" // used for custom tile images
    var oddCode = "" // used for custom tile images
    var staggerOn = true
    var staggerOff = false;
    
    var menu_vc : MenuViewController!
    
    // variables for selected/clicked cells
    var tileIsSelected: Bool = false
    var previouslySelectedTileColor: UIColor?
    var previouslySelectedTileIndex: Int?
    var previouslySelectedTileTeam: Team?
    var currentTeam: Team?
    var legalMoves: [Int] = []
    var turnCounter = 0; //[0,1] -> first player's turns, [2,3] -> second player's turns
    var isDieRolling = false //for disabling cell selection while die rolling
    var firstPieceMoved: Piece?
    var dieTimer: Timer!
    var dieCounter = 5 //how many times the die rolls
    var castlingTileIndices: [Int] = [2,6,58,62]
    var gyCellWidth : CGFloat!
    var blackPiecesRemoved = 0
    var whitePiecesRemoved = 0

    // for randomMove()
    var isRandom:Bool = true
    var imminentKingAttacks: [Int]? = []
    var kingThreats: [AIMove]? = []
    var retreatMove: AIMove? = nil
    var previousFromTile: Tile?
    var previousToTile: Tile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onRecievePopupData(_:)), name: Notification.Name(rawValue: "startNewGame"), object: nil)
        
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        AppDelegate.menu_bool = true
        let slideUp = UISwipeGestureRecognizer(target: self, action: #selector(showCT(gesture:)))
        slideUp.direction = .up
        view.addGestureRecognizer(slideUp)
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissCT(gesture:)))
        slideDown.direction = .down
        view.addGestureRecognizer(slideDown)
        
        // divides board collectionView into 8 columns and sets spacing
        var screenWidth = UIScreen.main.bounds.width
        if(screenWidth >= 710) {
            //print("SCREEN WIDTH: \(screenWidth)")
            screenWidth = 710
        }
        let itemSize = (screenWidth - 10) / 8
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        board.collectionViewLayout = layout
        
        // sets graveyard collectionView cell sizes according to screen size
        let itemSize2 = (screenWidth - 10) / 12
        gyCellWidth = itemSize2
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = CGSize(width: itemSize2, height: itemSize2)
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        whiteGraveyard.collectionViewLayout = layout2
        blackGraveyard.collectionViewLayout = layout2
        
        board.setup()
        startGame()
    }
    
    // sets all game variables and starts the game
    func startGame() {
        displayDie(num: 0)
        turnCounter = 0
        
        if(GAME_TYPE == 0) { // AI game
            var difficulty = ""
            
            switch(DIFFICULTY) {
            case 1: difficulty = "Medium"
                 light = UIColor.init(displayP3Red: 234.0/255.0, green: 243.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                 dark = UIColor.init(displayP3Red: 116/255.0, green: 134/255.0, blue: 165/255.0, alpha: 1.0)

            case 2: difficulty = "Hard"
                light = UIColor.init(displayP3Red: 230/255.0, green: 223/255.0, blue: 226/255.0, alpha: 1.0)
                dark = UIColor.init(displayP3Red: 132/255.0, green: 99/255.0, blue: 110/255.0, alpha: 1.0)

            default: difficulty = "Easy"
            light = UIColor.init(displayP3Red: 210.0/255.0, green: 215.0/255.0, blue: 208/255.0, alpha: 1.0)
            dark = UIColor.init(displayP3Red: 114.0/255.0, green: 135.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            }
            
            blackTeamLabel.text = "AI (\(difficulty))"
            whiteTeamLabel.text = "Player"
            
        } else {
            // Two Player Game
            light = UIColor.init(displayP3Red: 234/255.0, green: 230/255.0, blue: 244/255.0, alpha: 1.0)
            dark = UIColor.init(displayP3Red: 131/255.0, green: 111/255.0, blue: 134/255.0, alpha: 1.0)
        }
        
        setGameColors()
        
        updateTurnDisplay()
        //AppDelegate.menu_bool = true
         imminentKingAttacks = []
        kingThreats = []
         retreatMove = nil
        currentTeam = Team.White
        legalMoves = []
        turnCounter = 0
        AIKing = board.getPieceAtLocation(location: 4)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            UIView.animate(withDuration: 1.5, animations: {
                self.swipeImage.alpha = 1
                self.swipeLabel.alpha = 1
            })
        
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//        if (launchedBefore)  {
//            print("did load before")
//
//        } else {
//            print("hasn't loaded before")
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
//            UIView.animate(withDuration: 1.5, animations: {
//                self.swipeImage.alpha = 1
//                self.swipeLabel.alpha = 1
//            })
//        }

    }
    
    func restartGame() {
        resetBoard()
        startGame()
        
        //print("---------NEW GAME---------\n")
        //print("Turn #\(turnCounter)")
    }
    
    // Resets the board
    func resetBoard() {
        board.setup()
        board.reloadData()
        whiteGraveyard.resetGraveyard()
        blackGraveyard.resetGraveyard()
        //whiteGraveyard.reloadData()
        //blackGraveyard.reloadData()
    }
    
    // Displays end of game popup view
    func endGame(winner: Team) {
        let winMessage = ["winMessage" : "\(winner.rawValue) Wins"]
        showPopup()
        turnCounter = 0
        updateTurnDisplay()

        // send winMessage to PopupViewController
        NotificationCenter.default.post(name: Notification.Name(rawValue: "winMessage"), object: nil, userInfo: winMessage)
    }
    
    func showPopup() {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGamePopup") as! PopupViewController
        
        self.addChild(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
    

    
    @objc func onRecievePopupData(_ notification:Notification) {
        
        // handle difficulty change in popup
        if let data = notification.userInfo as? [String:Int] {
            for (_, difficulty) in data {
                DIFFICULTY = difficulty
                //print("Popup difficulty:  \(difficulty)")
            }
        }
        
        restartGame()
    }
    func setGameColors() {
        if(GAME_TYPE == 0) {
            switch(DIFFICULTY) {
            case 0: mainBackgroundImage.image = UIImage(named: "green.jpg")
            let sendData = [0 : 0]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuMessage"), object: nil, userInfo: sendData)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuTableMessage"), object: nil, userInfo: sendData)
            case 1: mainBackgroundImage.image = UIImage(named: "blue.jpg")
            let sendData = [0 : 1]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuMessage"), object: nil, userInfo: sendData)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuTableMessage"), object: nil, userInfo: sendData)
            case 2: mainBackgroundImage.image = UIImage(named: "red.jpg")
            let sendData = [0 : 2]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuMessage"), object: nil, userInfo: sendData)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuTableMessage"), object: nil, userInfo: sendData)
            default:mainBackgroundImage.image = UIImage(named: "green.jpg")
            let sendData = [0 : 0]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuMessage"), object: nil, userInfo: sendData)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuTableMessage"), object: nil, userInfo: sendData)
            }
        } else {
            mainBackgroundImage.image = UIImage(named: "purple.jpg")
            let sendData = [0 : 3]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuMessage"), object: nil, userInfo: sendData)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "difficultyMenuTableMessage"), object: nil, userInfo: sendData)
        }
    }
    
    
    // Number of views in the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == whiteGraveyard || collectionView == blackGraveyard) {
            return 21
        }
        return 64
    }
    
    // Populate UICollectionView with Tile objects
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Populates the graveyard cells
        if(collectionView == whiteGraveyard || collectionView == blackGraveyard) {
            
            let gyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GYCell", for: indexPath) as! GraveyardCell
            
            // makes graveyard cells overlap
            let centerX = gyCellWidth / 2.0 + CGFloat(indexPath.item) * (gyCellWidth/2)
            let centerY = gyCellWidth / 2.0
            gyCell.center = CGPoint(x: centerX, y: centerY)
            
            return gyCell
        }
        else {
            let tile = collectionView.dequeueReusableCell(withReuseIdentifier: "tile", for: indexPath) as! Tile
            
            tile.location = indexPath.row
            tile.setPiece(piece: board.getPieceAtLocation(location: indexPath.row))
            tile.setLegalMoveView()
            
            setTileColorVariables(index: indexPath.row)
            
            if indexPath.row % 2 == 0 {
                tile.backgroundColor = evenColor
            } else {
                tile.backgroundColor = oddColor
            }
            
            return tile
        }
    }
    
    
    // Sets tile color variables according to Tile index
    func setTileColorVariables(index: Int) {
        
        // checks if start of new row and turns on staggered colors
        if(index % 8 == 0) {
            if(staggerOn) {
                staggerOn = false
                staggerOff = true
                
                evenColor = dark
                oddColor = light
                
                //evenCode = "d" // used for custom tile images
                //oddCode = "l" // used for custom tile images
            } else {
                staggerOn = true
                staggerOff = false
                
                evenColor = light
                oddColor = dark
                
                //evenCode = "l" // used for custom tile images
                //oddCode = "d" // used for custom tile images
            }
        }
    }
    
    
    // Called when Tile is clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Tile clicked: \(indexPath.row)")
        
        // checks if current turn is the players turn (at time of cell click...)
        //        if (turnCounter == 0 || turnCounter == 1) {
        //            currentTeam = Team.White;
        //
        //            playersTurn(indexPath: indexPath)
        //            // AI turn gets called at the end of playersTrun() function
        //        }
        
        if(GAME_TYPE == 0) { // AI game
            if (turnCounter == 0) {
                playersTurn(indexPath: indexPath)
            } else if (turnCounter == 1) {
                playersTurn(indexPath: indexPath)
                
                for bp in board.blackPieces{
                    bp.firstMove = FirstAction.None //resets what AI piece did for first move
                }
				
            }
        } else { // Two Player game
            playersTurn(indexPath: indexPath)
        }
    }
    
    // Plays turns for the AI
    func AITurn() {

        aiWaitingSymbol.alpha = 0
        aiWaitingText.alpha = 0

        imminentKingAttacks = cellsCanAttackAIKing(board: board)
        kingThreats = getKingThreats(board: board)

        var chosenMove: AIMove!
        //print("imminent king attacks: \(imminentKingAttacks != nil)")
        //print("king threats: \(kingThreats!.count)")

        if(imminentKingAttacks != nil){
            //print("imminent attack")
            chosenMove = getKingRescueMove(board: board, cellsInDanger: imminentKingAttacks!, turnCounter: turnCounter)


        } else if ((kingThreats?.count)! > 0){
            //print("king threat")
            retreatMove = kingRetreatMove(board: board)
            if (retreatMove != nil){//move king backward if possible
                //print("retreating from king threat")
                
                chosenMove = retreatMove
            } else {
                //print("defending king threat")

                chosenMove = defendKing(board: board, threatMoves: kingThreats!, turnCounter: turnCounter)


                //if defendmove nil, return any move to avoid crash
            }
        } else {
            //print("making a regular move")
            
            var legalMovesArray = getBestLegalMoves(board: board, thisTeam: Team.Black, turnCounter:turnCounter)
            legalMovesArray.sort(by: { $1.moveBenefit > $0.moveBenefit })
//            for l in legalMovesArray{
//                //print("move: \(l.pieceToMove.type) at \(l.oldPos) to \(l.newPos) with benefit value \(l.moveBenefit)")
//            }
            chosenMove = getMoveByDifficulty(movesArray: legalMovesArray, difficulty: DIFFICULTY)
            //print("chosen move: \(defendMove.pieceToMove.type) at \(defendMove.oldPos) to \(defendMove.newPos) with benefit value \(defendMove.moveBenefit). \(defendMove.isAttackMove ? "This is an attack move":"")")
        }
		
            chosenMove = (chosenMove == nil) ? getBestLegalMoves(board: board, thisTeam: Team.Black, turnCounter: turnCounter).first: chosenMove

                let fromPos = chosenMove.oldPos
                let toPos = chosenMove.newPos
        
        
                if (previousToTile != nil){
                    revertTileColor(tile: previousFromTile!)
                    revertTileColor(tile: previousToTile!)
                }

                let fromTile = board.cellForItem(at: IndexPath(row: fromPos, section: 0)) as! Tile
                let toTile = board.cellForItem(at: IndexPath(row: toPos, section: 0)) as! Tile
                previousFromTile = fromTile
                previousToTile = toTile
                let fromTileOriginalColor = fromTile.backgroundColor
                let toTileOriginalColor = toTile.backgroundColor
        
                fromTile.backgroundColor = UIColor.init(displayP3Red: 112/255, green: 224/255, blue: 108/255, alpha: 1)
                toTile.backgroundColor = UIColor.init(displayP3Red: 112/255, green: 224/255, blue: 108/255, alpha: 1)
        
                UIView.animate(withDuration: 2, animations: {
                    fromTile.backgroundColor = fromTileOriginalColor
                    toTile.backgroundColor = toTileOriginalColor
                }, completion: nil)

                let dieRollNotNeeded: Bool = chosenMove.attackedPiece?.type == PieceType.Pawn && (fromTile.piece!.type == PieceType.King || fromTile.piece!.type == PieceType.Queen)
                
                if (chosenMove.isAttackMove && !dieRollNotNeeded){//if best move is an attack
                    chosenMove.pieceToMove.firstMove = FirstAction.Attacked

                    fromTile.backgroundColor = UIColor.yellow
                    toTile.backgroundColor = UIColor.magenta
                    toTile.legalMoveView.tintColor = UIColor.black
                    toTile.showLegalMoveView(show: true)
                    toTile.MinRollLabel.alpha = 1
                    let lowestRollNeeded = fromTile.piece?.getMinRollNeeded(pieceToAttack: (toTile.piece?.type)!)
                    toTile.setMinRollLabel(minRoll: lowestRollNeeded!)
                    
                    isDieRolling = true
                    dieTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(rollDie), userInfo: fromTile, repeats: true)
                    
                    attacker = chosenMove.pieceToMove.type
                    attackerTeam = chosenMove.pieceToMove.team
                    victim = chosenMove.attackedPiece!.type
                    victimTeam = chosenMove.attackedPiece!.team
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.afterDieRollAI(fromPos:fromPos,toPos:toPos,chosenMove:chosenMove)
                    })
                    
                } else {
                    if (dieRollNotNeeded){
                        chosenMove.pieceToMove.firstMove = FirstAction.Attacked
                        sendToGraveyard(piece:board.getPieceAtLocation(location: toPos)!)
                    } else {
                        chosenMove.pieceToMove.firstMove = FirstAction.Moved
                    }
                    board.getPieceAtLocation(location: toPos)?.location = 64
                    
                    let moveFromTile = board.cellForItem(at: IndexPath(row: fromPos, section: 0)) as! Tile
                    moveFromTile.removePiece()
                    let moveToTile = board.cellForItem(at: IndexPath(row: toPos, section: 0)) as! Tile
                    moveToTile.setPiece(piece: chosenMove.pieceToMove)
//                    moveFromTile.backgroundColor = UIColor.init(displayP3Red: 0.0/255.0, green: 0.0/255.0, blue: 200.0/255.0, alpha: 0.5)
//                    moveToTile.backgroundColor = UIColor.init(displayP3Red: 200.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)

                    if (turnCounter == 2){// if finished ai's first turn, increase turncounter, do 2nd turn
                        aiWaitingSymbol.alpha = 1
                        aiWaitingText.alpha = 1
                        turnCounter += 1
                        updateTurnDisplay()
                        turnCounter -= 1
                        if (blackPiecesRemoved < 15 || (cellsCanAttackAIKing(board: board) != nil && AIKing.getCanAttack())) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            self.turnCounter += 1
                            self.AITurn()
                        })
                        }
                        else {
                            aiWaitingSymbol.alpha = 0
                            aiWaitingText.alpha = 0
                            turnCounter = 0
                            updateTurnDisplay()
                        }
                        
                    } else if (turnCounter == 3){//if second turn, reset turncounter
                        turnCounter = 0
                        updateTurnDisplay()
                    }
					print("turncounter after move is \(turnCounter)")
                }
            }

    
    func playersTurn(indexPath: IndexPath) {
        
        UIView.animate(withDuration: 1.5, animations: {
            self.swipeImage.alpha = 0
            self.swipeLabel.alpha = 0
        })
        
        let tile = board.cellForItem(at: indexPath) as! Tile
        
        //decide which array is referenced based on turncounter
        if (turnCounter == 0 || turnCounter == 1) {
            currentTeam = Team.White;
        } else if (turnCounter == 2 || turnCounter == 3) {
            currentTeam = Team.Black;
        }
        //        print("controlling team is \(currentTeam)")
        //        print("piece at \(board.getPieceAtLocation(location: indexPath.row)?.location) is \(board.getPieceAtLocation(location: indexPath.row)?.team)")
        
        if(!tileIsSelected && tile.hasPiece() && (currentTeam == tile.piece?.team) && !isDieRolling) {//clicked piece while no cells are highlighted
            legalMoves = tile.piece?.getUnfilteredMoves(board:board) ?? []
            previouslySelectedTileTeam = tile.piece?.team
            legalMoves = showLegalMoves(tile: tile);
            attacker = tile.piece?.type
            attackerTeam = tile.piece?.team
            
            //print("attacker =  \(attacker)")
            //print("attacker team = (\(attackerTeam)")
            
            previouslySelectedTileColor = tile.backgroundColor
            tile.backgroundColor = UIColor.cyan
            tileIsSelected = true;
            previouslySelectedTileIndex = indexPath.row
            
            if (tile.piece?.type == PieceType.King){
                let piecesRemoved = tile.piece?.team == Team.Black ? blackPiecesRemoved : whitePiecesRemoved
                if (legalMoves.isEmpty && tile.piece?.firstMove == FirstAction.Moved && piecesRemoved >= 15){
                    turnCounter += 1
                    tile.piece?.firstMove = FirstAction.None
                    
                }
            }
        }
        else if(tileIsSelected && !isDieRolling) {//clicked a piece while some tile is selected
            victim = board.getPieceAtLocation(location: indexPath.row)?.type
            victimTeam = board.getPieceAtLocation(location: indexPath.row)?.team
            
            //print("victim =  \(victim)")
            //print("victim team = \(victimTeam)")
            //print("previous index: \(previouslySelectedTileIndex)")

            let previousTile = board.cellForItem(at: IndexPath(row: previouslySelectedTileIndex!, section: 0)) as! Tile
            let tile = board.cellForItem(at: indexPath) as! Tile
            
            if(legalMoves.contains(indexPath.row)) {
                //piece moved legally
                
                if (previousToTile != nil){
                    revertTileColor(tile: previousFromTile!)
                    revertTileColor(tile: previousToTile!)
                }
                
                previousFromTile = previousTile
                previousToTile = tile
                
                if (turnCounter == 0 || turnCounter == 2){
                    firstPieceMoved = previousTile.piece
                    if (tile.isEmpty()){
                        previousTile.piece?.firstMove = FirstAction.Moved
                        
                        
                    }else {
                        previousTile.piece?.firstMove = FirstAction.Attacked
                    }
                } else if (turnCounter == 1 || turnCounter == 3){
                    previousTile.piece?.firstMove = FirstAction.None
                    firstPieceMoved?.firstMove = FirstAction.None
                }
                
                if (turnCounter >= 3){
                    turnCounter = 0;
                } else {
                    turnCounter += 1;
                }
                
                if (previousTile.piece?.type == PieceType.King){
                    if ((previousTile.piece?.legalCastlingMovesArray.contains( tile.location))!){
                        let rookFromPos = previousTile.piece?.getCastlingRookLocation(clickedIndex: tile.location)
                        let rookToPos = tile.location + (previousTile.piece?.rookMoveAddVal)!
                        let castlingRook = board.getPieceAtLocation(location: rookFromPos!)
                        castlingRook?.location = rookToPos
                        let rookTileFrom = board.cellForItem(at: IndexPath(row: rookFromPos!, section: 0)) as! Tile
                        rookTileFrom.removePiece()
                        let rookTileTo = board.cellForItem(at: IndexPath(row: rookToPos, section: 0)) as! Tile
                        rookTileTo.setPiece(piece: castlingRook)
                    }
                }
                let dieRollNotNeeded: Bool = victim == PieceType.Pawn && (attacker == PieceType.King || attacker == PieceType.Queen)
                if (tile.hasPiece() && !dieRollNotNeeded) {
                    isDieRolling = true
                    dieTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(rollDie), userInfo: previousTile, repeats: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.afterDieRoll(previousTile:previousTile,indexPath:indexPath,tile:tile)
                    })
                }
                else {
                    if (dieRollNotNeeded){
                        sendToGraveyard(piece:tile.piece!)
                    }
                    previousTile.piece?.resetCastleLegalMoveVal()
                    
                    board.getPieceAtLocation(location: indexPath.row)?.location = 64
                    var pieceCount = 0
                    for bp in board.blackPieces{
                        if (bp.location == 64){
                            //print("removedPiece: \(bp.type) at \(bp.location)")
                            board.blackPieces.remove(at: pieceCount)
                            break
                        }
                        pieceCount += 1
                    }
                    //all captured pieces move to '64th' tile since I can't figure out how to remove pieces from array in swift
                    
                    // set previously selected piece to newly selected tile
                    tile.setPiece(piece: previousTile.piece)
                    previousTile.piece?.onMove();
                    
                    // remove previously selected tile's image and restore original tile color

                    previousTile.removePiece()
                    previousTile.backgroundColor = previouslySelectedTileColor
                    
                    
                    //print("piece moved to tile \(indexPath.row) ")
                    if (turnCounter == 2 && GAME_TYPE == 0){
                        aiWaitingSymbol.alpha = 1
                        aiWaitingText.alpha = 1
                        updateTurnDisplay()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                            self.AITurn()
                        })
                    } else {
                        updateTurnDisplay()
                        
                    }
                }
                
                
                //print("turn #\(turnCounter)")
                
                // hide legalMoves indicators
                hideLegalMoves()
                
                // reset variables
                tileIsSelected = false
                legalMoves.removeAll()
                previouslySelectedTileTeam = nil
                
            } else if (tile.piece?.team == previouslySelectedTileTeam){
                //print("Switch pieces to move")
                // remove previously selected tile's image and restore original tile color
                previousTile.backgroundColor = previouslySelectedTileColor
                
                // hide legalMoves indicators
                hideLegalMoves()
                
                // reset variables
                tileIsSelected = false
                previouslySelectedTileTeam = nil
                legalMoves.removeAll()
                
                legalMoves = tile.piece?.getUnfilteredMoves(board:board) ?? []
            }

            var lastPiece: Piece?
            if (previousTile.isEmpty()){
                lastPiece = tile.piece
            } else {
                lastPiece = previousTile.piece
            }
            let piecesRemoved = lastPiece!.team == Team.Black ? blackPiecesRemoved : whitePiecesRemoved
            
            if (piecesRemoved >= 15){
                if (lastPiece!.type == PieceType.King){
                    if (turnCounter == 1 || turnCounter == 3){
                        if (lastPiece?.firstMove == FirstAction.Attacked)
                        {
                            if (turnCounter >= 3){
                                turnCounter = 0;
                            } else {
                                turnCounter += 1;
                            }
                            lastPiece?.firstMove = FirstAction.None
                        }
                        else if (lastPiece?.type == PieceType.King){
                            if (lastPiece?.firstMove != FirstAction.None && piecesRemoved >= 15){
                                if (turnCounter == 1 || turnCounter == 3){
                                    if (lastPiece?.firstMove == FirstAction.Moved){
                                        let kingLegalMoves = lastPiece?.getUnfilteredMoves(board: board)
                                        var kingCanAttack = false
                                        for i in kingLegalMoves! {
                                            if (board.getPieceAtLocation(location: i) != nil){
                                                kingCanAttack = true
                                                break;
                                            }
                                            kingCanAttack = false
                                        }
                                        
                                        if (kingCanAttack){
                                        } else {
                                            if (turnCounter >= 3){
                                                turnCounter = 0;
                                            } else {
                                                turnCounter += 1;
                                            }
                                            lastPiece?.firstMove = FirstAction.None
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Checks if the next turn is the start of the AI Turns
        //        if(turnCounter == 3) {
        //            AITurn()
        //        }
    }
    
    
    func showLegalMoves(tile:Tile) -> [Int] {
        //check to see 1) if either team's second turn 2) can move/attack
        //if can move -> keep empty legal moves
        //if can attack -> keep legal moves to opponent's piece
        //print("first move: \(tile.piece?.firstMove)")
        for i in legalMoves {
            let availableTile = board.cellForItem(at: IndexPath(row: i, section: 0)) as! Tile
            if(availableTile.hasPiece()) {
                if(availableTile.piece?.team != previouslySelectedTileTeam && (tile.piece?.getCanAttack())!) {
                    //legal moves to opponents pieces
                    availableTile.legalMoveView.tintColor = UIColor.red
                    availableTile.showLegalMoveView(show: true)
                    availableTile.MinRollLabel.alpha = 1
                    let lowestRollNeeded = tile.piece?.getMinRollNeeded(pieceToAttack: (availableTile.piece?.type)!)
                    availableTile.setMinRollLabel(minRoll: lowestRollNeeded!)
                    
                } else {
                    let removeInt: Int  = (legalMoves.firstIndex(of: i)!);
                    //print(removeInt)
                    //print("\(legalMoves[removeInt]) removed")
                    legalMoves.remove(at: removeInt)
                    //print(legalMoves);
                    
                    
                }
            }
            if (availableTile.isEmpty()){
                if (tile.piece?.type == PieceType.King && castlingTileIndices.contains(i) && (tile.piece?.getCanMove())! && (tile.piece?.isCastleAvailable(board: board))!){
                    availableTile.legalMoveView.tintColor = UIColor.blue
                    availableTile.showLegalMoveView(show: true)
                    
                } else if ((tile.piece?.getCanMove())!){
                    availableTile.legalMoveView.tintColor = UIColor.green
                    availableTile.showLegalMoveView(show: true)
                } else {
                    let removeInt: Int  = (legalMoves.firstIndex(of: i)!);
                    legalMoves.remove(at: removeInt)
                }
                //array of legal moves to empty squares
            }
        }
        return legalMoves;
    }
    
    func hideLegalMoves() {
        for i in legalMoves {
            let availableTile = board.cellForItem(at: IndexPath(row: i, section: 0)) as! Tile
            availableTile.MinRollLabel.alpha = 0
            
            availableTile.showLegalMoveView(show: false)
        }
    }
    
    //menu button
    @IBAction func menu_action(_ sender: UIBarButtonItem) {
        
        if AppDelegate.menu_bool {
            //show the menu
            show_menu()
        }
        else{
            //close the menu
            close_menu()
            
        }
    }
    
    //function to show and open up the menu
    func show_menu(){
        
        UIView.animate(withDuration: 0.3) { ()->Void in
            
            self.menu_vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)
            self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.addChild(self.menu_vc)
            self.view.addSubview(self.menu_vc.view)
            AppDelegate.menu_bool = false
            
        }
        
    }
    
    //fucntion to close the menu
    func close_menu(){
        
        
        UIView.animate(withDuration: 0.3, animations: {()->Void in
            self.menu_vc.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)        }) { (finished) in
                self.menu_vc.view.removeFromSuperview()        }
        
        AppDelegate.menu_bool = true
        
    }
    
    // Called during die roll to display result
    func displayDie(num: Int) {
        
        switch num {
        case 0:
            die_imageView.image = nil
        case 1:
            die_imageView.image = die_1
        case 2:
            die_imageView.image = die_2
        case 3:
            die_imageView.image = die_3
        case 4:
            die_imageView.image = die_4
        case 5:
            die_imageView.image = die_5
        case 6:
            die_imageView.image = die_6
        default:
            print("ERROR: Invalid die roll")
        }
    }
    
    // rolls the 6 sided die
    @objc func rollDie(){
        if (dieCounter >= 0){
            dieCounter -= 1
            last_rolled = d6.nextInt()

            // for testing purposes
//            if (attackerTeam == Team.White) {
//            last_rolled = 6
//            }
//            else {
//            last_rolled = 1
//            }
            //
            
            displayDie(num: last_rolled)
        } else {
            dieTimer.invalidate()
            //afterDieRoll(previousTile: previousTile, indexPath: indexPath, tile: tile)
            dieCounter = 5
        }
    }
    
    func afterDieRoll(previousTile:Tile,indexPath:IndexPath,tile:Tile){
        isDieRolling = false;
        displayDie(num: 0)
        attack()
        
        if attackResult() == false { // if attack is NOT successfull
            updateTurnDisplay()
            if (previousToTile != nil){
                revertTileColor(tile: previousFromTile!)
                revertTileColor(tile: previousToTile!)
            }
            print("Attack Failed! - piece NOT moved")
        }
        else { // if attack was successful
            updateTurnDisplay()
            previousTile.piece?.resetCastleLegalMoveVal()
            
            board.getPieceAtLocation(location: indexPath.row)?.location = 64
            var pieceCount = 0
            for bp in board.blackPieces{
                if (bp.location == 64){
                    //print("removedPiece: \(bp.type) at \(bp.location)")
                    board.blackPieces.remove(at: pieceCount)
                    break
                }
                pieceCount += 1
            }
            //all captured pieces move to '64th' tile since I can't figure out how to remove pieces from array in swift
            
            
            // send captured piece to graveyard
            if(tile.hasPiece()) {
                sendToGraveyard(piece: tile.piece!)
            }
            
            // set previously selected piece to newly selected tile
            tile.setPiece(piece: previousTile.piece)
            previousTile.piece?.onMove();
            
            // remove previously selected tile's image and restore original tile color
            previousTile.removePiece()
            previousTile.backgroundColor = previouslySelectedTileColor
            
            //print("Attack Successful! - piece moved to tile \(indexPath.row)")
            if (victimTeam == Team.Black){
                blackPiecesRemoved += 1
            } else if (victimTeam == Team.White) {
                whitePiecesRemoved += 1
            }
            
            if (victim == PieceType.King) {
                endGame(winner: attackerTeam)
            }
        }
        if (turnCounter == 2 && GAME_TYPE == 0){
            aiWaitingSymbol.alpha = 1
            aiWaitingText.alpha = 1
            updateTurnDisplay()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.AITurn()
            })
        } else if (GAME_TYPE == 1){
            updateTurnDisplay()
        }
    }
    
    func afterDieRollAI(fromPos:Int,toPos:Int,chosenMove:AIMove){
        isDieRolling = false;
        displayDie(num: 0)
        attack()
        let fromTile = board.cellForItem(at: IndexPath(row: fromPos, section: 0)) as! Tile
        let toTile = board.cellForItem(at: IndexPath(row: toPos, section: 0)) as! Tile

        toTile.MinRollLabel.alpha = 0
        toTile.showLegalMoveView(show: false)
		if attackResult() == false { // if attack is NOT successful
			print("Attack Failed! - piece NOT moved")
            if (previousToTile != nil){
                revertTileColor(tile: fromTile)
                revertTileColor(tile: toTile)
            }
        }
        else {
            fromTile.backgroundColor = UIColor.init(displayP3Red: 112/255, green: 224/255, blue: 108/255, alpha: 1)
            toTile.backgroundColor = UIColor.init(displayP3Red: 112/255, green: 224/255, blue: 108/255, alpha: 1)
            sendToGraveyard(piece: board.getPieceAtLocation(location: toPos)!)
            if (victim == PieceType.King) {
                endGame(winner: Team.Black)
            }
            board.getPieceAtLocation(location: toPos)?.location = 64
            var pieceCount = 0
            for wp in board.whitePieces{
                if (wp.location == 64){
                    board.whitePieces.remove(at: pieceCount)
                    break
                }
                pieceCount += 1
            }
            let moveFromTile = board.cellForItem(at: IndexPath(row: fromPos, section: 0)) as! Tile
            moveFromTile.removePiece()
            let moveToTile = board.cellForItem(at: IndexPath(row: toPos, section: 0)) as! Tile
            moveToTile.setPiece(piece: chosenMove.pieceToMove)
            
            whitePiecesRemoved += 1
        }
        if (turnCounter == 2 && GAME_TYPE == 0){
            aiWaitingSymbol.alpha = 1
            aiWaitingText.alpha = 1
            turnCounter += 1
            updateTurnDisplay()
            turnCounter -= 1
			if (blackPiecesRemoved < 15 || (cellsCanAttackAIKing(board: board) != nil && AIKing.getCanAttack())) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.turnCounter += 1
                    self.AITurn()
                })
            }
            else {
                aiWaitingSymbol.alpha = 0
                aiWaitingText.alpha = 0
                turnCounter = 0
                updateTurnDisplay()
            }
        } else if (turnCounter >= 3){
            turnCounter = 0
            updateTurnDisplay()
            
        }
        //print("turncounter after die roll is \(turnCounter)")
    }
        
    // Send captured piece to correct graveyard
    func sendToGraveyard(piece: Piece) {
        switch(piece.team) {
        case .Black:
            whiteGraveyard.addPiece(piece: piece)
        case .White:
            blackGraveyard.addPiece(piece: piece)
        }
    }
    
    func updateTurnDisplay(){
        turnBallWhite1.tintColor = UIColor.gray
        turnBallWhite1.alpha = 0.5
        turnBallWhite2.tintColor = UIColor.gray
        turnBallWhite2.alpha = 0.5
        turnBallBlack1.tintColor = UIColor.gray
        turnBallBlack1.alpha = 0.5
        turnBallBlack2.tintColor = UIColor.gray
        turnBallBlack2.alpha = 0.5
        
        switch(turnCounter) {
        case 0:
            currentTeamLabel.text = " WHITE "
            turnBallWhite1.tintColor = whitePieceColor
            turnBallWhite1.alpha = 1
        case 1:
            currentTeamLabel.text = " WHITE "
            turnBallWhite2.tintColor = whitePieceColor
            turnBallWhite2.alpha = 1
        case 2:
            currentTeamLabel.text = " BLACK "
            
            turnBallBlack1.tintColor = UIColor.black
            turnBallBlack1.alpha = 1
        case 3:
            currentTeamLabel.text = " BLACK "
            
            turnBallBlack2.tintColor = UIColor.black
            turnBallBlack2.alpha = 1
        default:
            currentTeamLabel.text = " WHITE "
            turnBallWhite1.tintColor = whitePieceColor
            turnBallWhite1.alpha = 1
        }
    }
    func showCaptureTable() {
    let captureVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "capturePopUp") as! CaptureViewController
    
    self.addChild(captureVC)
    captureVC.view.frame = self.view.frame
    self.view.addSubview(captureVC.view)
    captureVC.didMove(toParent: self)
    }
    
    func revertTileColor(tile:Tile){
        let tileLocation:Int = (tile.location)
        let isEvenRow:Bool = ((tileLocation / 8) % 2) == 0
        let isEvenCol:Bool = ((tileLocation % 8) % 2) == 0
        
        if (isEvenRow){
            if (isEvenCol){
                tile.backgroundColor = dark

            } else {
                tile.backgroundColor = light
            }
        } else if (!isEvenRow){
            if (isEvenCol){
                tile.backgroundColor = light


            } else {
                tile.backgroundColor = dark
            }
        }

    }
    
    
    @objc func showCT(gesture: UISwipeGestureRecognizer) {
        if (self.view.subviews.count == 2){
            UIView.animate(withDuration: 0.4) {
                self.showCaptureTable()
            }
        }
    }
    
    @objc func dismissCT(gesture: UISwipeGestureRecognizer) {
        print(self.view.subviews.count)
        if (self.view.subviews.count == 3){
            UIView.animate(withDuration: 0.4) {
                self.view.subviews.last!.willMove(toWindow: nil)
                self.view.subviews.last!.removeFromSuperview()
            }
        }

    }
}
