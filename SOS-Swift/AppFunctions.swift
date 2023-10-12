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
	}

	return myStructArray
}

//this is the function that handles what do to on click i.e. setting the text in the button to be S, O, or blank,
//and any other needs. it takes the index of the button clicked as an int, and the existing array of cells as
//an array of [Cell], and returns a tuple. By returning a tuple, we can pass back multiple values with some kind
//of usable naming

func buttonClickStuff(for myIndex: Int, theTitle: String, myArray: [Cell], myCurrentPlayer: String) -> (myColor: Color, myTitle:String, myCommitButtonStatus: Bool, myCurrentPlayer: String) {
	//switch statement to cycle between  titles on the button
	//print("Index passed is: \(myIndex)")
	var theCommitButtonStatus: Bool = false
	var theCellTitle: String = ""
	var theCurrentPlayer: String = ""
	switch theTitle {
		case "":
			theCellTitle = "S"
			theCommitButtonStatus = false
		case "S":
			theCellTitle = "O"
			theCommitButtonStatus = false
		case "O":
			theCellTitle = ""
			theCommitButtonStatus = true
		default:
			print("Something went wrong, try restarting the app")
	}
	//testing print statements
	print("cell button lable is: \(theCellTitle)")
	print("cell button commit status is: \(theCommitButtonStatus)")
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

func newGame () {

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
