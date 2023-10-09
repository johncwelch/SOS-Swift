//
//  AppData.swift
//  SOS-Swift
//
//  Created by John Welch on 10/7/23.
//

import SwiftUI
import Foundation

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
func buildCellArray(theGridSize: Int) -> [Cell] {
	var myStructArray: [Cell] = []
	let arraySize = (theGridSize * theGridSize) - 1
	for i in 0...arraySize {
		myStructArray.append(Cell())
	}

	for i in 0...arraySize {
		myStructArray[i].index = i
	}
	//print statement used to validate the array size when the dropdown changes.
	//should be one less than the total number of cells in the grid since we start counting at zero
	//print("Built Cell Array with \(arraySize) elements")
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
	print("cell button lable is: \(theCellTitle)")
	print("cell button commit status is: \(theCommitButtonStatus)")
	//this really isn't needed, but it's going to be a help later.
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

func changePlayer(myCurrentPlayer: String) -> String {
	var newPlayer: String = ""
	if myCurrentPlayer == "Blue" {
		newPlayer = "Red"
	} else if myCurrentPlayer == "Red" {
		newPlayer = "Blue"
	}
	return newPlayer
}

func setButtonColor(myCurrentPlayer: String) -> Color {
	var buttonColor: Color = .gray
	if myCurrentPlayer == "Blue" {
		buttonColor = .blue
	} else if myCurrentPlayer == "Red" {
		buttonColor = .red
	}
	return buttonColor
}

//game classes

//this is the class we use to modify the buttons on click. This avoids having to sling actual buttons back and forth
//makes memory usage smaller, and our lives more sane
@Observable
class Cell: Identifiable {
	let id = UUID()
	var title: String = ""
	var buttonDisabled: Bool = false
	var index: Int = 0
	var xCoord: Int = 0
	var yCoord: Int = 0
	var backCol: Color = .gray
	//var disabled: Bool = false
}

//View Structs

//viewmodifiers to simplify text formatting code
//think of it as a stylesheet for text labels
//this sets the font, the font weight, frame properties, and text selection
struct basicTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		return content
			.font(.body)
			.fontWeight(.bold)
			.frame(width: 120.0,height: 22.0,alignment: .leading)
			.textSelection(.enabled)
	}
}

//sets the same as basicTextModifer, but no frame properties
struct basicTextModifierNoFrame: ViewModifier {
	func body(content: Content) -> some View {
		return content
			.font(.body)
			.fontWeight(.bold)
			.textSelection(.enabled)
	}
}


//setup for game type radio buttons, swiftui is weird this way
struct gameTypeRadioButtonView: View {
	var index: Int
	@Binding var selectedIndex: Int

	var body: some View {
		//in swiftUI ALL BUTTONS ARE BUTTONS
		Button(action: {
			selectedIndex = index
		}) {
			//this sets up the view for the basic button. You define it here once, then implement it in
			//the main view
			HStack {
				//literally build the buttons this way because fuck if I know, this UI by code shit is
				//stupid
				Image(systemName:  self.selectedIndex == self.index ? "largecircle.fill.circle" : "circle")
					.foregroundColor(.black)
				//set the label for each one
				if index == 1 {
					Text("Simple")
				} else if index == 2 {
					Text("General")
				}

			}
			//.padding(.leading, 20.0)
		}
	}
}

//setup for the blue player radio buttons
struct bluePlayerTypeRadioButton: View {
	var index: Int
	@Binding var selectedIndex: Int

	var body: some View {
		Button(action: {
			selectedIndex = index
		}) {
			HStack {
				Image(systemName:  self.selectedIndex == self.index ? "largecircle.fill.circle" : "circle")
					.foregroundColor(.black)
				if index == 1 {
					Text("Human")
				} else if index == 2 {
					Text("Computer")
				}
			}
		}
	}
}

//setup for the red player radio buttons
struct redPlayerTypeRadioButton: View {
	var index: Int
	@Binding var selectedIndex: Int

	var body: some View {
		Button(action: {
			selectedIndex = index
		}) {
			HStack {
				Image(systemName:  self.selectedIndex == self.index ? "largecircle.fill.circle" : "circle")
					.foregroundColor(.black)
				if index == 1 {
					Text("Human")
				} else if index == 2 {
					Text("Computer")
				}
			}
		}
	}
}

