//
//  AppFunctions.swift
//  SOS-Swift
//
//  Created by John Welch on 10/12/23.
//

import SwiftUI
import Foundation
import Observation


//basic functions
//collect the initial setup for new game and print them, mostly to show things are actually set right
//like unit tests without the overhead
func getInitVars(theType: Int, theSize: Int, theBlueType: Int, theRedType: Int, theCurrentPlayer: String) {
	var gameType: String = ""
	var bluePlayerType: String = ""
	var redPlayerType: String = ""

	if theType == 1 {
		gameType = "Simple"
	} else if theType == 2 {
		gameType = "General"
	}

	if theBlueType == 1 {
		bluePlayerType = "Human"
	} else if theBlueType == 2 {
		bluePlayerType = "Computer"
	}

	if theRedType == 1 {
		redPlayerType = "Human"
	} else if theRedType == 2 {
		redPlayerType = "Computer"
	}
	print("The Game type is: \(gameType)")
	print("The Game Board size is: \(theSize)x\(theSize)")
	print("The blue player type is: \(bluePlayerType)")
	print("The red player type is: \(redPlayerType)")
	print("The current player is: \(theCurrentPlayer)")
}

//basic functional test for the board size picker
func boardSizeSelect(theSelection: Int) {
	print("The board size selection is: \(theSelection)x\(theSelection)")
}

//this builds an array of Cell that gets attached to each button in the game. It's kind of important
//takes in the grid size set in the UI, and then returns an array of cells
func buildStructArray(theGridSize: Int) -> [Cell] {
	var myStructArray: [Cell] = []
	let arraySize = (theGridSize * theGridSize) - 1
	for i in 0...arraySize {
		myStructArray.append(Cell())
		myStructArray[i].index = i
		myStructArray[i].backCol = .gray
	}

	return myStructArray
}

//this takes care of creating the array of unused button indices
func buildUnusedArray (myGridSize: Int)  -> [Int] {
	//set up the initial array of unused buttons
	var theTempArray = [Int]()
	let theGridSize = myGridSize * myGridSize
	for i in 0..<theGridSize {
		theTempArray.append(i)
	}
	//print("The used buttons array is \(theTempArray)")
	return theTempArray

}

//this is the function that handles what do to on click i.e. setting the text in the button to be S, O, or blank,
//and any other needs. it takes the index of the button clicked as an int, and the existing array of cells as
//an array of [Cell], and returns a tuple. By returning a tuple, we can pass back multiple values with some kind
//of usable naming.

func buttonClickStuff(for myIndex: Int, theTitle: String, myArray: Game, myCurrentPlayer: String, myUnusedButtons: [Int]) -> (myColor: Color, myTitle:String, myCommitButtonStatus: Bool, myCurrentPlayer: String) {
	var theCommitButtonStatus: Bool = false
	var theCellTitle: String = ""
	var theCurrentPlayer: String = ""
	//print("the button clicked was button: \(myIndex)")
	//we'll need to build an array of already disabled buttons that we can pass
	//switch statement to cycle between  titles on the button
	switch theTitle {
		//button is current blank, click sets it to "S"
		case "":
			theCellTitle = "S"
			theCommitButtonStatus = false
			//disable all other enabled buttons but the one that you're clicking
			disableOtherButtonsDuringMove(myGridArray: myArray, currentButtonIndex: myIndex)
		//button is currently "S", click sets it to "O"
		case "S":
			theCellTitle = "O"
			theCommitButtonStatus = false
			//disable all other enabled buttons but the one that you're clicking
			disableOtherButtonsDuringMove(myGridArray: myArray, currentButtonIndex: myIndex)
		//button is currently "O", click sets it to ""
		case "O":
			theCellTitle = ""
			theCommitButtonStatus = true
			//enable the other buttons that should be enabled since the button you just clicked
			//is now blank and you can click the other buttons to change your move
			enableOtherButtonsDuringMove(myGridArray: myArray)
		default:
			print("Something went wrong, try restarting the app")
	}
	//testing print statements
	//print("cell button lable is: \(theCellTitle)")
	//bprint("cell button commit status is: \(theCommitButtonStatus)")
	//sets up the values so that the button color can be changed to be correct

	if myCurrentPlayer == "Blue" {
		theCurrentPlayer = "Red"
	} else {
		theCurrentPlayer = "Blue"
	}

	let theColor: Color = Color.blue
	let theReturnTuple = (myColor: theColor, myTitle: theCellTitle, myCommitButtonStatus: theCommitButtonStatus, myCurrentPlayer: theCurrentPlayer)
	return theReturnTuple
}

func newGame (myGridArray: Game) {
	//print("The Size of the grid is: \(myGridArray.gridCellArr.count)")
	for i in 0..<myGridArray.gridCellArr.count {
		myGridArray.gridCellArr[i].title = ""
		myGridArray.gridCellArr[i].backCol = .gray
		myGridArray.gridCellArr[i].buttonDisabled = false
	}
}

//change player on commit move
func changePlayer(myCurrentPlayer: String) -> String {
	var newPlayer: String = ""
	if myCurrentPlayer == "Blue" {
		newPlayer = "Red"
	} else if myCurrentPlayer == "Red" {
		newPlayer = "Blue"
	}
	return newPlayer
}

//change button color on commit move for a single button
func setButtonColor(myCurrentPlayer: String) -> Color {
	var buttonColor: Color = .gray
	if myCurrentPlayer == "Blue" {
		buttonColor = .blue
	} else if myCurrentPlayer == "Red" {
		buttonColor = .red
	}
	return buttonColor
}

//change colors for multiple buttons (SOS)
//will modify for general game to handle multiple players
func setSOSButtonColor(myCurrentPlayer: String, myFirstIndex: Int, mySecondIndex: Int, myThirdIndex: Int, myGridArray: Game) {
	if myCurrentPlayer == "Blue" {
		myGridArray.gridCellArr[myFirstIndex].backCol = .blue
		myGridArray.gridCellArr[mySecondIndex].backCol = .blue
		myGridArray.gridCellArr[myThirdIndex].backCol = .blue
	} else if myCurrentPlayer == "Red" {
		myGridArray.gridCellArr[myFirstIndex].backCol = .red
		myGridArray.gridCellArr[mySecondIndex].backCol = .red
		myGridArray.gridCellArr[myThirdIndex].backCol = .red
	}

}

//func to disable other buttons when making a move.
func disableOtherButtonsDuringMove (myGridArray: Game, currentButtonIndex: Int) {
	//iterate through the array
	for i in 0..<myGridArray.gridCellArr.count {
		//look for buttons that are not the current button and are not already disabled
		if !myGridArray.gridCellArr[i].buttonDisabled && i != currentButtonIndex {
			myGridArray.gridCellArr[i].buttonDisabled = true
		}
	}
}

//func to enable other buttons when the current button being clicked goes to ""
func enableOtherButtonsDuringMove (myGridArray: Game){
	for i in 0..<myGridArray.gridCellArr.count {
		if myGridArray.gridCellArr[i].title == "" {
			myGridArray.gridCellArr[i].buttonDisabled = false
		}
	}
}

//function to commit a move
func commitMove (myCommittedButtonIndex: Int, myUnusedButtons: [Int],myGridArray: Game, myCurrentPlayer: String, myArrayUsedMemberCountdown: Int) -> (myUnusedButtonArray: [Int], myCountDownInt: Int, mySOSFlag: Bool) {
	//create temp array that is mutable for the list of unused buttons
	var theTempArray = myUnusedButtons
	var theTempCounter = myArrayUsedMemberCountdown
	//did the commit result in an SOS? returns Bool
	let theSOSFlag = checkForSOS(myGridArray: myGridArray, myLastButtonClickedIndex: myCommittedButtonIndex, myGridSize: myGridArray.gridSize, myCurrentPlayer: myCurrentPlayer)
	//remove the button we are committing the move for from the array of unused buttons using the button we just clicked
	//this helps avoid out of index errors since we can only click enabled buttons
	
	//we can't just brute force remove by raw index, since the index of a given button can change, i.e. if button 3 is initially at
	//index 4 (0,1,2,3) and we remove the butotn at index 1, in this case, button 1, we now have an array that is 0,2,3, in terms of
	//content, but 0,1,2 in terms of index, so removing index 3 is out of range. So we grab the index of the value via firstIndex(of:)
	//that way, we don't have issues.
	let theButtonToBeDisabledIndex = theTempArray.firstIndex(of: myCommittedButtonIndex)
	//remove the button at theButtonToBeDisabledIndex from the array
	theTempArray.remove(at: theButtonToBeDisabledIndex!)
	//set the color for the button we are committing to that of the current player only if there wasn't an SOS
	if !theSOSFlag {
		myGridArray.gridCellArr[myCommittedButtonIndex].backCol = setButtonColor(myCurrentPlayer: myCurrentPlayer)
	}
	//disable the button we are committing so it can't be changed
	myGridArray.gridCellArr[myCommittedButtonIndex].buttonDisabled = true
	//re-enable all the existing blank buttons
	for i in 0..<myGridArray.gridCellArr.count {
		//if the title is "", reenable it
		if myGridArray.gridCellArr[i].title == "" {
			myGridArray.gridCellArr[i].buttonDisabled = false
		}
	}
	theTempCounter -= 1
	//return theTempArray, countdownInt, and SOSflag back to ContentView
	let theReturnTuple = (myUnusedButtonArray: theTempArray, myCountDownInt: theTempCounter, mySOSFlag: theSOSFlag)
	return theReturnTuple
}

//funciton to check for SOS
func checkForSOS(myGridArray: Game, myLastButtonClickedIndex: Int, myGridSize: Int, myCurrentPlayer: String) -> Bool {
	//first we need to set some flags for leftmost/rightmost/topmost/bottommost positions
	//since that has a lot to do with how we calculate wins
	//we may not need a separate myGridSize
	//print("the index is: \(myLastButtonClickedIndex) the y coord is: \(myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord)")
	//hopefully these is obvious
	var adjacentCellTitle = ""
	var nextAdjacentCellTitle = ""

	//if the grid size is 3, the right/bottom row/colum is 2, if 10, then 9, etc.
	//leftmost column, x = 0, rightmost column, buttonRightEdgeCheck
	let buttonRightEdgeCheck = myGridSize - 1
	//topmost row, y = 0, bottom row, buttonBottomEdgeCheck
	//technically, both high row/colum are the same.
	let buttonBottomEdgeCheck = myGridSize - 1
	//button has an xCoord == 0
	var buttonLeftmostFlag: Bool = false
	//button has a yCoord == 0
	var buttonTopRowFlag: Bool = false
	//button has an xCoord = gridSize - 1 (so if gridSize is 3, rightMost would be 2)
	var buttonRightmostFlag: Bool = false
	//button has a yCoord = gridsize -1 (so if gridSize is 3, bottomMost would be 2)
	var buttonBottomRowFlag: Bool = false
	
	//there's an SOS
	var SOSFlag: Bool = false
	//check for xCoord edges
	switch myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord {
		case 0:
			buttonLeftmostFlag = true
		case buttonRightEdgeCheck:
			buttonRightmostFlag = true
		default:
			buttonLeftmostFlag = false
			buttonRightmostFlag = false
	}
	//check for yCoord edges
	switch myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord {
		case 0:
			buttonTopRowFlag = true
		case buttonBottomEdgeCheck:
			buttonBottomRowFlag = true
		default:
			buttonTopRowFlag = false
			buttonBottomRowFlag = false
	}


	//get the title of the last button clicked
	var theCurrentButtonTitle = myGridArray.gridCellArr[myLastButtonClickedIndex].title
	var theCurrentButtonIndex = myGridArray.gridCellArr[myLastButtonClickedIndex].index

	//set up checks for at least 2 from bottom/right edge for L -> R horizontal, diag down, diag up checks.
	var distanceFromRight = buttonRightEdgeCheck - myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord
	var distanceFromBottom = buttonBottomEdgeCheck - myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord
	//all the S checks here
	if theCurrentButtonTitle == "S" {
		//L - R horizontal, X goes up, Y is constant
		//we aren't on the far right edge
		//set of LTR checks
		if !buttonRightmostFlag {
			//check all LTR options
			if distanceFromRight >= 2 {
				//look for next adjacent cell, current index + 1, because horizontal LTR, SOS would be current index +1, current index +2
				var nextCellIndex = myLastButtonClickedIndex + 1
				var secondCellIndex = myLastButtonClickedIndex + 2
				if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
					//set colors for all three buttons
					setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
					SOSFlag = true
				}
				//L -> R horizontal didn't have SOS, now do L -> R diags
				//nested if already checked for proper distance from right edge, for the diags, we only care about y distance
				if distanceFromBottom >= 2 {
					//in the grids, the diag down index is the current index + (gridsize + 1) so for 3x3, it'd be current + 4, 5x5 would be
					//current + 6. the second adjacent cell is the adjacentcell index + (gridsize + 1)
					var nextCellIndex = (myLastButtonClickedIndex) + (myGridSize + 1)
					var secondCellIndex = (nextCellIndex) + (myGridSize + 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						//set colors for all three buttons
						setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
						SOSFlag = true
					}
					//can't do LTR down, so let's do LTR up!
					//the y coord has to be at least 2 or there's no point in going L -> R diag up, since SOS is 3 buttons, so 2,1,0 for SOS
				}
				//check both diag and vertical up
				if myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 2 {
					//check diag up
					var nextCellIndex = (myLastButtonClickedIndex) - (myGridSize - 1)
					var secondCellIndex = (nextCellIndex) - (myGridSize - 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						//set colors for all three buttons
						setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
						SOSFlag = true
					}
				}
			}
		}
		//vertical up check, can't combine it with diag check because horizontal position causes problems
		//all we care about here is that the y coord of the button clicked is at least 2
		if myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 2 {
			var nextCellIndex = myLastButtonClickedIndex - myGridSize
			var secondCellIndex = nextCellIndex - myGridSize
			if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
				//set colors for all three buttons
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
				SOSFlag = true
			}
		}
		//vertical down check, separate for same reasons as vertical up check
		//all we care about here is that distance from the bottom is at least 2
		if distanceFromBottom >= 2 {
			var nextCellIndex = myLastButtonClickedIndex + myGridSize
			var secondCellIndex = nextCellIndex + myGridSize
			if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
				//set colors for all three buttons
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
				SOSFlag = true
			}
		}
		//start RTL checks
		//horizontal first, we need to care about are we at zero and are we at least 2 from left
		//check for zer
		if !buttonLeftmostFlag {
			//check for at least two in the xCoord
			if myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord >= 2 {
				//check R -> L horizontal, current index - 1 for next cell
				var nextCellIndex = myLastButtonClickedIndex - 1
				var secondCellIndex = nextCellIndex - 1
				if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
					//set colors for all three buttons
					setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
					SOSFlag = true
				}
				//RTL Diag Down
				//since going down, we need to be at least two from the bottom
				if distanceFromBottom >= 2 {
					//check R -> L diag down, (current index) + (gridsize - 1)
					var nextCellIndex = (myLastButtonClickedIndex) + (myGridSize - 1)
					var secondCellIndex = (nextCellIndex) + (myGridSize - 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						//set colors for all three buttons
						setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
						SOSFlag = true
					}
				}
				//RTL Diag Up
				//need to be at least 2 from the top
				if myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 2 {
					//check R -> L diag up, (current index) - (gridSize + 1)
					var nextCellIndex = (myLastButtonClickedIndex) - (myGridSize + 1)
					var secondCellIndex = (nextCellIndex) - (myGridSize + 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						//set colors for all three buttons
						setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
						SOSFlag = true
					}
				}
			}
		}
	}
	//all the "O" checks here
	if theCurrentButtonTitle == "O" {
		//horizontal first. Needs to be both 1 away from the right (xCoord >= 1) AND one away from the left (xCoord <= right edge - 1)
		if (myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord >= 1) && (distanceFromRight >= 1) {
			//cell to the right
			var rightAdjacentCellIndex = myLastButtonClickedIndex + 1
			//cell to the left
			var leftAdjacentCellInded = myLastButtonClickedIndex - 1
			//check cells on either side horizontal are "S"
			if (myGridArray.gridCellArr[rightAdjacentCellIndex].title == "S") && (myGridArray.gridCellArr[leftAdjacentCellInded].title == "S") {
				//set colors for all three buttons
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: rightAdjacentCellIndex, myThirdIndex: leftAdjacentCellInded, myGridArray: myGridArray)
				SOSFlag = true
			}

		}
		//vertical O
		//check for at least 1 from top and bottom
		if (myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 1) && (distanceFromBottom >= 1) {
			//next cell up
			var topAdjacentCellIndex = myLastButtonClickedIndex - myGridSize
			var bottomAdjacentCellIndex = myLastButtonClickedIndex + myGridSize
			//check cells above and below are "S"
			if (myGridArray.gridCellArr[topAdjacentCellIndex].title == "S") && (myGridArray.gridCellArr[bottomAdjacentCellIndex].title == "S") {
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: topAdjacentCellIndex, myThirdIndex: bottomAdjacentCellIndex, myGridArray: myGridArray)
				SOSFlag = true
			}
		}
		//for diags, we have to be 1 from top and bottom AND one from left and right, so four ands:
		//may be able to check both diags in one try
		if (myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord >= 1) && (distanceFromRight >= 1) && (myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 1) && (distanceFromBottom >= 1) {
			//check left high/right low diag (rtl up for high, ltr down for low)
			var highLeftAdjacentCell = (myLastButtonClickedIndex) - (myGridSize + 1)
			var lowRightAdjacentCell = (myLastButtonClickedIndex) + (myGridSize + 1)
			if (myGridArray.gridCellArr[highLeftAdjacentCell].title == "S") && (myGridArray.gridCellArr[lowRightAdjacentCell].title == "S") {
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: highLeftAdjacentCell, myThirdIndex: lowRightAdjacentCell, myGridArray: myGridArray)
				SOSFlag = true
			}
			//check left low/right high diag (rtl down for low, ltr up for high
			var lowLeftAdjacentCell = (myLastButtonClickedIndex) + (myGridSize - 1)
			var highRightAdjacentCell = (myLastButtonClickedIndex) - (myGridSize - 1)
			if (myGridArray.gridCellArr[lowLeftAdjacentCell].title == "S") && (myGridArray.gridCellArr[highRightAdjacentCell].title == "S") {
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: lowLeftAdjacentCell, myThirdIndex: highRightAdjacentCell, myGridArray: myGridArray)
				SOSFlag = true
			}
		}
	}
	return SOSFlag
}

//function to manage checking for game over and handling if it is
func isGameOver(myArrayUsedMemberCountdown: Int, myGameType: Int, myGridArray: Game, mySOSFlag: Bool) -> (myGameIsOver: Bool, myGameIsDraw: Bool) {

	var gameIsOver: Bool = false
	var gameIsDraw: Bool = false
	//we'll need this lateer
	var gridCountdown = myArrayUsedMemberCountdown
	
	//check to see if gridCountDown is zero. If it is, game is over no matter what
	if gridCountdown > 0 {
		//grid countdown is not zero, check for other things
		if myGameType == 1 {
			//simple game
			if mySOSFlag {
				//there's an SOS, game is over
				//grid countdown to zero
				//gridCountdown = 0
				//disable all the buttons
				for i in 0..<myGridArray.gridCellArr.count {
					myGridArray.gridCellArr[i].buttonDisabled = true
				}
				//set the game over flag
				gameIsOver = true
				gameIsDraw = false
				print("game is over!")
			} else {
				//mySOSFlag is not true, game is not over
				gameIsOver = false
				gameIsDraw = false
			}
		} else {
			//game type is general
		}
	} else if gridCountdown <= 0 {
		//0 or less the game is over regardless of winner or not
		//disable the game board
		for i in 0..<myGridArray.gridCellArr.count {
			myGridArray.gridCellArr[i].buttonDisabled = true
		}

		if mySOSFlag {
			//there's a winner, so not a draw
			gameIsOver = true
			gameIsDraw = false
		} else {
			//no winner, is a draw
			gameIsOver = true
			gameIsDraw = true
		}
	}

	let gameIsOverTuple = (myGameIsOver: gameIsOver, myGameIsDraw: gameIsDraw)

	return gameIsOverTuple
}

//function to manage game over alert messages
func gameOverAlert(myPlayerColor: String, myGameIsDraw: Bool) -> Alert {
	var alertTitle: String = ""
	var alertMessage: String = ""

	if myGameIsDraw {
		alertTitle = "Game was a Draw"
		alertMessage = "No one won! Click New Game or resize grid to play again"
	} else {
		alertTitle = "We have a winner!"
		alertMessage = "\(myPlayerColor) Player Won! Click New Game or resize grid to play again"
	}

	var myAlert = Alert(
		title: Text(alertTitle),
		message: Text(alertMessage),
		dismissButton: .default(Text("Okay"))
	)

	return myAlert
}

//function to increment score in general game
func incrementScore(myCurrentPlayer: String, myRedPlayerScore: Int, myBluePlayerScore: Int) -> (myRedPlayerScore: Int, myBluePlayerScore: Int){
	var bluePlayerScore = myBluePlayerScore
	var redPlayerScore = myRedPlayerScore

	if myCurrentPlayer == "Blue" {
		bluePlayerScore += 1
	} else {
		redPlayerScore += 1
	}

	let playerScoreTuple = (myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore)
	return playerScoreTuple
}
