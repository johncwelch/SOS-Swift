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
//like unit tests without the overhead, also way more flexible
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
//this is only called by the class constructor
func buildStructArray(theGridSize: Int) -> [Cell] {
	//we do this because as passed, [Cell] is a constant
	var myStructArray: [Cell] = []
	//build the array size, so for a 3x3 grid, the arraysize would be 8, (0-8 is 9 cells)
	let arraySize = (theGridSize * theGridSize) - 1
	//bulld the array by appending to the var, setting the index and setting the background color to grey
	for i in 0...arraySize {
		myStructArray.append(Cell())
		myStructArray[i].index = i
		myStructArray[i].backCol = .gray
	}
	//reutrn the array
	return myStructArray
}

//this takes care of creating the array of unused button indices
//important for tracking which buttons are available for use
//takes a size int and returns an int array
//this is used on game start, by "New Game" and when resizing the grid via the picker
func buildUnusedArray(myGridSize: Int)  -> [Int] {
	//set up the initial array of unused buttons
	var theTempArray = [Int]()
	//build the array bounds
	let theGridSize = myGridSize * myGridSize
	//build the array
	for i in 0..<theGridSize {
		theTempArray.append(i)
	}
	//return the array
	return theTempArray
}

//this is the function that handles what do to on click i.e. setting the text in the button to be S, O, or blank,
//and any other needs. it takes the index of the button clicked as an int, and the existing array of cells as
//an array of [Cell], and returns a tuple. By returning a tuple, we can pass back multiple values with some kind
//of usable naming.
//called whenever a game grid button is clicked
func buttonClickStuff(for myIndex: Int, theTitle: String, myArray: Game, myCurrentPlayer: String, myUnusedButtons: [Int]) -> Bool {
	//old tuple return (myTitle:String, myCommitButtonStatus: Bool, myCurrentPlayer: String)

	//mutable vars
	var theCommitButtonStatus: Bool = false
	var theCellTitle: String = ""

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
	//set the current button title to the correct title
	myArray.gridCellArr[myIndex].title = theCellTitle
	//return the bool for the enable/disable status of the commit move button
	return theCommitButtonStatus
}

//called by "New Game" button
//this goes through the array and resets it back to new, so no title, all gray, all enabled
func newGame(myGridArray: Game) {
	for i in 0..<myGridArray.gridCellArr.count {
		myGridArray.gridCellArr[i].title = ""
		myGridArray.gridCellArr[i].backCol = .gray
		myGridArray.gridCellArr[i].buttonDisabled = false
	}
}

//change player
//Called by the "Commit Move" and "Start Game" buttons
func changePlayer(myCurrentPlayer: String) -> String {
	var newPlayer: String = ""
	if myCurrentPlayer == "Blue" {
		newPlayer = "Red"
	} else if myCurrentPlayer == "Red" {
		newPlayer = "Blue"
	}
	//return the string for who the new current player is
	return newPlayer
}

//change button color on commit move for a single button
//called by the "Commit Move" button
func setButtonColor(myCurrentPlayer: String) -> Color {
	var buttonColor: Color = .gray
	if myCurrentPlayer == "Blue" {
		buttonColor = .blue
	} else if myCurrentPlayer == "Red" {
		buttonColor = .red
	}
	//return the new color for the button
	//if we can figure out how to make this a gradient, that would be cool
	return buttonColor
}

//change colors for multiple buttons (SOS)
//will modify for general game to handle multiple players
//called by checkForSOS()
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
//called by buttonClickStuff()
func disableOtherButtonsDuringMove(myGridArray: Game, currentButtonIndex: Int) {
	//iterate through the array
	for i in 0..<myGridArray.gridCellArr.count {
		//look for buttons that are not the current button and are not already disabled
		if !myGridArray.gridCellArr[i].buttonDisabled && i != currentButtonIndex {
			myGridArray.gridCellArr[i].buttonDisabled = true
		}
	}
}

//func to enable other buttons when the current button being clicked goes to ""
//called by blue player radio button when changing setting back to human and by buttonClickStuff()
func enableOtherButtonsDuringMove(myGridArray: Game){
	for i in 0..<myGridArray.gridCellArr.count {
		if myGridArray.gridCellArr[i].title == "" {
			myGridArray.gridCellArr[i].buttonDisabled = false
		}
	}
}

//kind of a dupe, but only used for start game where blue is the computer player
//we only care about the grid array because NOTHING has been clicked and we want to keep it that way
//this will also erase any button that's been clicked and changed, but only at the beginning of a game.
//it's just different enough to be worth the the six extra lines of code it is
//called by blue player radio button, "New Game" button, and on grid size change via the size picker
func disableAllButtonsForBlueComputerPlayerStart(myGridArray: Game) {
	for i in 0..<myGridArray.gridCellArr.count {
		myGridArray.gridCellArr[i].title = ""
		myGridArray.gridCellArr[i].buttonDisabled = true
	}
}

//function to commit a move, called by the "Commit Move" button and the "Start Game" button
func commitMove(myCommittedButtonIndex: Int, myUnusedButtons: [Int],myGridArray: Game, myCurrentPlayer: String, myArrayUsedMemberCountdown: Int) -> (myUnusedButtonArray: [Int], myCountDownInt: Int, mySOSFlag: Bool, mySOSCounter: Int) {

	//create temp array that is mutable for the list of unused buttons
	var theTempArray = myUnusedButtons
	//create the mutable used button countdown
	var theTempCounter = myArrayUsedMemberCountdown
	//did the commit result in an SOS? returns Bool
	let theSOSTuple = checkForSOS(myGridArray: myGridArray, myLastButtonClickedIndex: myCommittedButtonIndex, myGridSize: myGridArray.gridSize, myCurrentPlayer: myCurrentPlayer)
	let theSOSFlag = theSOSTuple.mySOSFlag
	//for general game
	let theSOSCounter = theSOSTuple.mySOSCounter
	//remove the button we are committing the move for from the array of unused buttons using the button we just clicked
	//this helps avoid out of index errors since we can only click enabled buttons
	
	//we can't just brute force remove by raw index, since the index of a given button can change, i.e. if button 3 is initially at
	//index 4 (0,1,2,3) and we remove the button at index 1, in this case, button 1, we now have an array that is 0,2,3, in terms of
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
	//decrement the temp counter for the return
	theTempCounter -= 1
	//return theTempArray, countdownInt, and SOSflag back to ContentView
	let theCommitMoveTuple = (myUnusedButtonArray: theTempArray, myCountDownInt: theTempCounter, mySOSFlag: theSOSFlag, mySOSCounter: theSOSCounter)
	return theCommitMoveTuple
}

//funciton to check for SOS
//called by commitMove()
//there are 8 possible ways to get an SOS for an S evaluation and four for an O eval
//since S is always at the start or finish, while O is always in the middle
func checkForSOS(myGridArray: Game, myLastButtonClickedIndex: Int, myGridSize: Int, myCurrentPlayer: String) -> (mySOSFlag: Bool, mySOSCounter: Int) {
	//first we need to set some flags for leftmost/rightmost/topmost/bottommost positions
	//since that has a lot to do with how we calculate wins

	//needed to count multiple SOS's for general game
	var SOSCounter: Int = 0

	//if the grid size is 3, the right/bottom row/colum is 2, if 10, then 9, etc.
	//leftmost column, x = 0, rightmost column, buttonRightEdgeCheck
	let buttonRightEdgeCheck = myGridSize - 1
	//topmost row, y = 0, bottom row, buttonBottomEdgeCheck
	//technically, both high row/colum are the same.
	let buttonBottomEdgeCheck = myGridSize - 1
	//button has an xCoord == 0
	var buttonLeftmostFlag: Bool = false
	//button has a yCoord == 0
	//note the compiler complains about this not being written to but never read
	//button has an xCoord = gridSize - 1 (so if gridSize is 3, rightMost would be 2)
	var buttonRightmostFlag: Bool = false
	//button has a yCoord = gridsize -1 (so if gridSize is 3, bottomMost would be 2)

	//there's an SOS
	var SOSFlag: Bool = false
	//check for xCoord edges
	//as it turns out, we don't need to check for yCoord edges, w00t!
	switch myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord {
		case 0:
			buttonLeftmostFlag = true
		case buttonRightEdgeCheck:
			buttonRightmostFlag = true
		default:
			buttonLeftmostFlag = false
			buttonRightmostFlag = false
	}

	//get the title of the last button clicked
	let theCurrentButtonTitle = myGridArray.gridCellArr[myLastButtonClickedIndex].title

	//set up checks for at least 2 from bottom/right edge for L -> R horizontal, diag down, diag up checks.
	let distanceFromRight = buttonRightEdgeCheck - myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord
	let distanceFromBottom = buttonBottomEdgeCheck - myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord

	//all the S checks here
	if theCurrentButtonTitle == "S" {
		//L - R horizontal, X goes up, Y is constant
		//we aren't on the far right edge
		//set of LTR checks
		if !buttonRightmostFlag {
			//check all LTR options
			if distanceFromRight >= 2 {
				//look for next adjacent cell, current index + 1, because horizontal LTR, SOS would be current index +1, current index +2
				let nextCellIndex = myLastButtonClickedIndex + 1
				let secondCellIndex = myLastButtonClickedIndex + 2
				if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
					//set colors for all three buttons
					setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
					SOSFlag = true
					SOSCounter += 1
				}
				//L -> R horizontal didn't have SOS, now do L -> R diags
				//nested if already checked for proper distance from right edge, for the diags, we only care about y distance
				if distanceFromBottom >= 2 {
					//in the grids, the diag down index is the current index + (gridsize + 1) so for 3x3, it'd be current + 4, 5x5 would be
					//current + 6. the second adjacent cell is the adjacentcell index + (gridsize + 1)
					let nextCellIndex = (myLastButtonClickedIndex) + (myGridSize + 1)
					let secondCellIndex = (nextCellIndex) + (myGridSize + 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						//set colors for all three buttons
						setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
						SOSFlag = true
						SOSCounter += 1
					}
					//can't do LTR down, so let's do LTR up!
					//the y coord has to be at least 2 or there's no point in going L -> R diag up, since SOS is 3 buttons, so 2,1,0 for SOS
				}
				//check both diag and vertical up
				if myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 2 {
					//check diag up
					let nextCellIndex = (myLastButtonClickedIndex) - (myGridSize - 1)
					let secondCellIndex = (nextCellIndex) - (myGridSize - 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						//set colors for all three buttons
						setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
						SOSFlag = true
						SOSCounter += 1
					}
				}
			}
		}

		//vertical up check, can't combine it with diag check because horizontal position causes problems
		//all we care about here is that the y coord of the button clicked is at least 2
		if myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 2 {
			let nextCellIndex = myLastButtonClickedIndex - myGridSize
			let secondCellIndex = nextCellIndex - myGridSize
			if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
				//set colors for all three buttons
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
				SOSFlag = true
				SOSCounter += 1
			}
		}

		//vertical down check, separate for same reasons as vertical up check
		//all we care about here is that distance from the bottom is at least 2
		if distanceFromBottom >= 2 {
			let nextCellIndex = myLastButtonClickedIndex + myGridSize
			let secondCellIndex = nextCellIndex + myGridSize
			if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
				//set colors for all three buttons
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
				SOSFlag = true
				SOSCounter += 1
			}
		}

		//start RTL checks
		//horizontal first, we need to care about are we at zero and are we at least 2 from left
		//check for zer
		if !buttonLeftmostFlag {
			//check for at least two in the xCoord
			if myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord >= 2 {
				//check R -> L horizontal, current index - 1 for next cell
				let nextCellIndex = myLastButtonClickedIndex - 1
				let secondCellIndex = nextCellIndex - 1
				if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
					//set colors for all three buttons
					setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
					SOSFlag = true
					SOSCounter += 1
				}
				//RTL Diag Down
				//since going down, we need to be at least two from the bottom
				if distanceFromBottom >= 2 {
					//check R -> L diag down, (current index) + (gridsize - 1)
					let nextCellIndex = (myLastButtonClickedIndex) + (myGridSize - 1)
					let secondCellIndex = (nextCellIndex) + (myGridSize - 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						//set colors for all three buttons
						setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
						SOSFlag = true
						SOSCounter += 1
					}
				}
				//RTL Diag Up
				//need to be at least 2 from the top
				if myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 2 {
					//check R -> L diag up, (current index) - (gridSize + 1)
					let nextCellIndex = (myLastButtonClickedIndex) - (myGridSize + 1)
					let secondCellIndex = (nextCellIndex) - (myGridSize + 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						//set colors for all three buttons
						setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: nextCellIndex, myThirdIndex: secondCellIndex, myGridArray: myGridArray)
						SOSFlag = true
						SOSCounter += 1
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
			let rightAdjacentCellIndex = myLastButtonClickedIndex + 1
			//cell to the left
			let leftAdjacentCellInded = myLastButtonClickedIndex - 1
			//check cells on either side horizontal are "S"
			if (myGridArray.gridCellArr[rightAdjacentCellIndex].title == "S") && (myGridArray.gridCellArr[leftAdjacentCellInded].title == "S") {
				//set colors for all three buttons
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: rightAdjacentCellIndex, myThirdIndex: leftAdjacentCellInded, myGridArray: myGridArray)
				SOSFlag = true
				SOSCounter += 1
			}
		}

		//vertical O
		//check for at least 1 from top and bottom
		if (myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 1) && (distanceFromBottom >= 1) {
			//next cell up
			let topAdjacentCellIndex = myLastButtonClickedIndex - myGridSize
			let bottomAdjacentCellIndex = myLastButtonClickedIndex + myGridSize
			//check cells above and below are "S"
			if (myGridArray.gridCellArr[topAdjacentCellIndex].title == "S") && (myGridArray.gridCellArr[bottomAdjacentCellIndex].title == "S") {
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: topAdjacentCellIndex, myThirdIndex: bottomAdjacentCellIndex, myGridArray: myGridArray)
				SOSFlag = true
				SOSCounter += 1
			}
		}

		//for diags, we have to be 1 from top and bottom AND one from left and right, so four ands:
		//may be able to check both diags in one try
		if (myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord >= 1) && (distanceFromRight >= 1) && (myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 1) && (distanceFromBottom >= 1) {
			//check left high/right low diag (rtl up for high, ltr down for low)
			let highLeftAdjacentCell = (myLastButtonClickedIndex) - (myGridSize + 1)
			let lowRightAdjacentCell = (myLastButtonClickedIndex) + (myGridSize + 1)
			if (myGridArray.gridCellArr[highLeftAdjacentCell].title == "S") && (myGridArray.gridCellArr[lowRightAdjacentCell].title == "S") {
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: highLeftAdjacentCell, myThirdIndex: lowRightAdjacentCell, myGridArray: myGridArray)
				SOSFlag = true
				SOSCounter += 1
			}
			//check left low/right high diag (rtl down for low, ltr up for high
			let lowLeftAdjacentCell = (myLastButtonClickedIndex) + (myGridSize - 1)
			let highRightAdjacentCell = (myLastButtonClickedIndex) - (myGridSize - 1)
			if (myGridArray.gridCellArr[lowLeftAdjacentCell].title == "S") && (myGridArray.gridCellArr[highRightAdjacentCell].title == "S") {
				setSOSButtonColor(myCurrentPlayer: myCurrentPlayer, myFirstIndex: myLastButtonClickedIndex, mySecondIndex: lowLeftAdjacentCell, myThirdIndex: highRightAdjacentCell, myGridArray: myGridArray)
				SOSFlag = true
				SOSCounter += 1
			}
		}
	}
	//we return a bool for "was there an SOS" and an int for how many.
	//the latter is only important for a general game, since any SOS wins and finishes a simple game
	let myCheckForSOSTuple = (mySOSFlag: SOSFlag, mySOSCounter: SOSCounter)
	return myCheckForSOSTuple
}

//function to manage checking for game over and handling if it is
//called by "Start Game" and "Commit Move" buttons
func isGameOver(myArrayUsedMemberCountdown: Int, myGameType: Int, myGridArray: Game, mySOSFlag: Bool, myRedPlayerScore: Int, myBluePlayerScore: Int) -> (myGameIsOver: Bool, myGameIsDraw: Bool, myGeneralGameWinner: String) {

	//bools we'll be returning
	var gameIsOver: Bool = false
	var gameIsDraw: Bool = false
	//we'll need these later
	let gridCountdown = myArrayUsedMemberCountdown
	var gameWinner: String = ""

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
			} else {
				//mySOSFlag is not true, game is not over
				gameIsOver = false
				gameIsDraw = false
			}
		//we may not have to do anything here for a general game, since the SOS flag being true and game over being false runs the
		//score increment outside of this function
		}
	} else if gridCountdown <= 0 {
		//0 or less the game is over regardless of winner or not or game type
		//disable the game board
		//also, you CAN'T win a general game until all the squares are filled
		for i in 0..<myGridArray.gridCellArr.count {
			myGridArray.gridCellArr[i].buttonDisabled = true
		}
		//simple game draw
		if myGameType == 1 {
			if mySOSFlag {
				//there's a winner, so not a draw
				gameIsOver = true
				gameIsDraw = false
			} else {
				//no winner, is a draw
				gameIsOver = true
				gameIsDraw = true
			}
		} else {
			//general game all squares are filled is different
			//regardless of who won, game is over
			gameIsOver = true
			//red won
			if myRedPlayerScore > myBluePlayerScore {
				gameWinner = "Red"
				gameIsDraw = false
				//blue won
			} else if myBluePlayerScore > myRedPlayerScore {
				gameWinner = "Blue"
				gameIsDraw = false
				//Draw/no one won
			} else {
				gameWinner = "Draw"
				gameIsDraw = true
			}
		}
	}
	//return two bools and a string as a tuple
	let gameIsOverTuple = (myGameIsOver: gameIsOver, myGameIsDraw: gameIsDraw, myGeneralGameWinner: gameWinner)
	return gameIsOverTuple
}

//function to manage game over alert messages
//part of the "Commit Move" button code, but called whenever playerWon is true
func gameOverAlert(myPlayerColor: String, myGameIsDraw: Bool, myGeneralGameWinner: String, myGameType: Int) -> Alert {
	var alertTitle: String = ""
	var alertMessage: String = ""
	var winningPlayer: String = ""
	
	//build draw/tie game alert
	if myGameIsDraw {
		alertTitle = "Game was a Draw"
		alertMessage = "No one won! Click New Game or resize grid to play again"
	} else {
		//someone won
		if myGameType == 1 {
			//simple game
			winningPlayer = myPlayerColor
		} else {
			//general game
			winningPlayer = myGeneralGameWinner
		}
		alertTitle = "We have a winner!"
		alertMessage = "\(winningPlayer) Player Won! Click New Game or resize grid to play again"
	}
	//build the alert dialog
	let myAlert = Alert(
		title: Text(alertTitle),
		message: Text(alertMessage),
		dismissButton: .default(Text("Okay"))
	)
	//this returns the actual alert that's displayed
	return myAlert
}

//function to increment score in general game
//called by "Start Game" and "Commit Move" buttons
func incrementScore(myCurrentPlayer: String, myRedPlayerScore: Int, myBluePlayerScore: Int, mySOSCounter: Int) -> (myRedPlayerScore: Int, myBluePlayerScore: Int){
	var bluePlayerScore = myBluePlayerScore
	var redPlayerScore = myRedPlayerScore

	if myCurrentPlayer == "Blue" {
		//incrementing by number of SOS's created, not just by one no matter what
		bluePlayerScore = bluePlayerScore + mySOSCounter
	} else {
		redPlayerScore = redPlayerScore + mySOSCounter
	}
	
	//this returns the ints that are displayed in the score fields for a general game
	let playerScoreTuple = (myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore)
	return playerScoreTuple
}

//we need the array of unused buttons as a parameter
//this is where we'll figure out what button we want to use, so we can set that as myCommittedButtonIndex
//we return an int that will be myCommittedButtonIndex in commitMove() and a title that will be the new title of the button
//may do that here, since we can.
//check to see if we need to yoink the clicked button here or if that happens in commitMove()
//called by "Start Game" and "Commit Move" buttons for handling moves for a computer player
func startGame(myUnusedButtons: [Int], myGridArray: Game, myCurrentPlayer: String, myArrayUsedMemberCountdown: Int) -> Int {
	//create title array, shuffle it, and set the first element to be the new button title
	let buttonTitles = ["S","O"]
	//shuffle the array to get as random a result as we can
	let shuffledArray = buttonTitles.shuffled()
	//always use the first item in this array
	let buttonTitle = shuffledArray[0]
	//get the size of the unused button array
	let sizeOfUnusedButtons = myUnusedButtons.count
	//get a random number from 0 to last element of the array
	//get the Index of the button we want to click
	let buttonToClickIndex = Int.random(in: 0..<sizeOfUnusedButtons)
	//this is necessary to avoid some gnarly out of range errors. Basically, the button uses the raw number to determine which one is getting modified
	//so if the size of the array is say 6, then index 5 is a valid choice. But, if there's no button with an index of 5, BOOM. So this ensures the value
	//of the array at the index is what is used, not the raw index itself:
	//if index is [0,1,3,4,6,7], the value at index 5 is 7, but there's now no available button with an index of 5, so if we use 5, it's bad.
	//this prevents that.
	let buttonToClick = myUnusedButtons[buttonToClickIndex]
	//we'll need to set the title. we can ignore the commit button status for now, we're not using it
	//once we set the title, we call commitMove() once we exit this function
	//set the title. doing this here prevents us from having to return it
	myGridArray.gridCellArr[buttonToClick].title = buttonTitle

	//return the index of the button to "click
	return buttonToClick
}

//add an element to the game record array
//called by the Commit Move button for each manual move and for a following computer move. Called by the Start Game button for the initial move
//by the computer blue player, then once each time through the while loop for computer v. computer.
func addRecordedMove(myGameRecord: [moveRecord], myCommittedButtonIndex: Int, myGridArray: Game, myCurrentPlayer: String) -> [moveRecord] {
	var tempGameRecord = myGameRecord
	let theMove = myGridArray.gridCellArr[myCommittedButtonIndex]
	let theTempMoveRecord = moveRecord(moveIndex: theMove.index, moveTitle: theMove.title, movePlayer: myCurrentPlayer, moveColor: theMove.backCol)
	//print("theTempMoveRecord: \(theTempMoveRecord)")
	tempGameRecord.append(theTempMoveRecord)
	//print("tempGameRecord: \(tempGameRecord)")
	return tempGameRecord
}

//called by the playback button, this changes the button with the passed index (myLoopCount) each time
//it's called.
func playbackGame (myGameRecord: [moveRecord], myGridArray: Game, myLoopCount: Int) -> String {
	var theIndex: Int
	var theTitle: String
	var thePlayer: String
	var theColor: Color
	
	theIndex = myGameRecord[myLoopCount].moveIndex
	theTitle = myGameRecord[myLoopCount].moveTitle
	thePlayer = myGameRecord[myLoopCount].movePlayer
	theColor = myGameRecord[myLoopCount].moveColor

	myGridArray.gridCellArr[theIndex].title = theTitle
	myGridArray.gridCellArr[theIndex].backCol = theColor
	
	return thePlayer
}
