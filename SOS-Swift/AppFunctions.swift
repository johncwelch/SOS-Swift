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
			enableOtherButtonsDuringMove(myGridArray: myArray, myUnusedButtons: myUnusedButtons)
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
func enableOtherButtonsDuringMove (myGridArray: Game, myUnusedButtons: [Int]){
	for i in 0..<myGridArray.gridCellArr.count {
		if myGridArray.gridCellArr[i].title == "" {
			myGridArray.gridCellArr[i].buttonDisabled = false
		}
	}
}

func commitMove (myCommittedButtonIndex: Int, myUnusedButtons: [Int],myGridArray: Game, myCurrentPlayer: String) -> [Int] {
	//create temp array that is mutable for the list of unused buttons
	var theTempArray = myUnusedButtons

	print("The coordinates of the button we just commmitted are: \(myGridArray.gridCellArr[myCommittedButtonIndex].xCoord),\(myGridArray.gridCellArr[myCommittedButtonIndex].yCoord)")
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

