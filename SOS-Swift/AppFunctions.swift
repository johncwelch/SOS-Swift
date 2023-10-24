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
//of usable naming

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

//change button color on commit move
func setButtonColor(myCurrentPlayer: String) -> Color {
	var buttonColor: Color = .gray
	if myCurrentPlayer == "Blue" {
		buttonColor = .blue
	} else if myCurrentPlayer == "Red" {
		buttonColor = .red
	}
	return buttonColor
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

func commitMove (myCommittedButtonIndex: Int, myUnusedButtons: [Int],myGridArray: Game, myCurrentPlayer: String) -> [Int] {
	//create temp array that is mutable for the list of unused buttons
	var theTempArray = myUnusedButtons
	print("the y coord is: \(myGridArray.gridCellArr[myCommittedButtonIndex].yCoord)")
	checkForSOS(myGridArray: myGridArray, myLastButtonClickedIndex: myCommittedButtonIndex, myGridSize: myGridArray.gridSize)
	//print("The coordinates of the button we just commmitted are: \(myGridArray.gridCellArr[myCommittedButtonIndex].xCoord),\(myGridArray.gridCellArr[myCommittedButtonIndex].yCoord)")
	//remove the button we are committing the move for from the array of unused buttons using the button we just clicked
	//this helps avoid out of index errors since we can only click enabled buttons
	
	//we can't just brute force remove by raw index, since the index of a given button can change, i.e. if button 3 is initially at
	//index 4 (0,1,2,3) and we remove the butotn at index 1, in this case, button 1, we now have an array that is 0,2,3, in terms of
	//content, but 0,1,2 in terms of index, so removing index 3 is out of range. So we grab the index of the value via firstIndex(of:)
	//that way, we don't have issues.
	let theButtonToBeDisabledIndex = theTempArray.firstIndex(of: myCommittedButtonIndex)
	//remove the button at theButtonToBeDisabledIndex from the array
	theTempArray.remove(at: theButtonToBeDisabledIndex!)
	//set the color for the button we are committing to that of the current player
	myGridArray.gridCellArr[myCommittedButtonIndex].backCol = setButtonColor(myCurrentPlayer: myCurrentPlayer)
	//disable the button we are committing so it can't be changed
	myGridArray.gridCellArr[myCommittedButtonIndex].buttonDisabled = true
	//re-enable all the existing blank buttons
	for i in 0..<myGridArray.gridCellArr.count {
		//if the title is "", reenable it
		if myGridArray.gridCellArr[i].title == "" {
			myGridArray.gridCellArr[i].buttonDisabled = false
		}
	}
	//return theTempArray back to ContentView
	return theTempArray
}

func checkForSOS(myGridArray: Game, myLastButtonClickedIndex: Int, myGridSize: Int) {
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
	//all the S checks here
	if theCurrentButtonTitle == "S" {
		//L - R horizontal, X goes up, Y is constant
		//set up checks for at least 2 from bottom/right edge for L -> R horizontal, diag down, diag up checks.
		var distanceFromRight = buttonRightEdgeCheck - myGridArray.gridCellArr[myLastButtonClickedIndex].xCoord
		var distanceFromBottom = buttonBottomEdgeCheck - myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord

		//we aren't on the far right edge
		//set of LTR checks
		if !buttonRightmostFlag {
			//check all LTR options
			if distanceFromRight >= 2 {
				print("check LTR horizontal!")
				//L -> R horizontal SOS possible
				//look for next adjacent cell, current index + 1, because horizontal LTR, SOS would be current index +1, current index +2
				//no array traversal needed
				var nextCellIndex = myLastButtonClickedIndex + 1
				var secondCellIndex = myLastButtonClickedIndex + 2
				if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
					print("LTR horizontal SOS!")
					SOSFlag = true
				}
				//L -> R horizontal didn't have SOS, now do L -> R diags
				//nested if already checked for proper distance from right edge, for the diags, we only care about y distance
				if distanceFromBottom >= 2 {
					print("check LTR diag down")
					//safe to check L -> R diag down
					//in the grids, the diag down index is the current index + (gridsize + 1) so for 3x3, it'd be current + 4, 5x5 would be
					//current + 6. the second adjacent cell is the adjacentcell index + (gridsize + 1)
					var nextCellIndex = (myLastButtonClickedIndex) + (myGridSize + 1)
					var secondCellIndex = (nextCellIndex) + (myGridSize + 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						print("LTR Diag down SOS!")
						SOSFlag = true
					}
					//can't do LTR down, so let's do LTR up!
					//the y coord has to be at least 2 or there's no point in going L -> R diag up, since SOS is 3 buttons, so 2,1,0 for SOS
				}
				
				//check both diag and vertical up
				if myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 2 {
					print("check LTR diag up")
					//safe to check L -> R diag up
					//check diag up
					var nextCellIndex = (myLastButtonClickedIndex) - (myGridSize - 1)
					var secondCellIndex = (nextCellIndex) - (myGridSize - 1)
					if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
						print("LTR Diag up SOS!")
						SOSFlag = true
					}
				}
			}
		}
		//vertical up check, can't combine it with diag check because horizontal position causes problems
		//all we care about here is that the y coord of the button clicked is at least 2
		if myGridArray.gridCellArr[myLastButtonClickedIndex].yCoord >= 2 {
			print("check vertical up")
			var nextCellIndex = myLastButtonClickedIndex - myGridSize
			var secondCellIndex = nextCellIndex - myGridSize
			if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
				print("vertical up SOS!")
				SOSFlag = true
			}

		}
		//vertical down check, separate for same reasons as vertical up check
		//all we care about here is that distance from the bottom is at least 2
		if distanceFromBottom >= 2 {
			print("check vertical down")
			var nextCellIndex = myLastButtonClickedIndex + myGridSize
			var secondCellIndex = nextCellIndex + myGridSize
			if (myGridArray.gridCellArr[nextCellIndex].title == "O") && (myGridArray.gridCellArr[secondCellIndex].title == "S") {
				print("vertical down SOS!")
				SOSFlag = true
			}
		}
	}
}
