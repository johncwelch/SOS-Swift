//
//  ContentView.swift
//  SOS-Swift
//
//  Created by John Welch on 8/29/23.
//  this is the class file for our UI code

import SwiftUI

//build the main window view
struct ContentView: View {
	//vars for radio buttons and current player
	@State var gameType: Int = 1
	@State var boardSize: Int = 3
	@State var bluePlayerType: Int = 1
	@State var redPlayerType: Int = 1
	@State var currentPlayer: String = "Blue"

	var body: some View {
		//this is the main view within the window
		//the vstack/hstack dance is a very CSS way to do things
		//the area for all the controls that aren't the game grid
		HStack(alignment: .top) {
			//each "column" in the upper band is a separate vstack
			//this is just how swiftui does things
			VStack(alignment: .leading) {
			    Text("Game Type:")
					.modifier(basicTextModifier())
					.accessibilityLabel("Game Type label")
					.accessibilityIdentifier("gameTypeLabel")
				    //this actually draws the buttons
				gameTypeRadioButtonView(index: 1, selectedIndex: $gameType)
				gameTypeRadioButtonView(index: 2, selectedIndex: $gameType)
					//
			}
			.padding(.leading, 20.0)

			//select board size
			VStack(alignment: .leading) {
				Picker("Board Size", selection: $boardSize) {
				    Text("3").tag(3)
				    Text("4").tag(4)
				    Text("5").tag(5)
				    Text("6").tag(6)
				    Text("7").tag(7)
				    Text("8").tag(8)
				    Text("9").tag(9)
				    Text("10").tag(10)
				}
				//picker properties
				//padding has to be separate for each dimensions
					.modifier(basicTextModifierNoFrame())
					.frame(width: 140.0,alignment: .center)
					.padding(.top,2)
					.accessibilityLabel("Board Size Dropdown")
					.accessibilityIdentifier("boardSizeDropdown")
				    //makes it look like a dropdown list
					.pickerStyle(MenuPickerStyle())
				    //this is how you initiate actions based on a change event
					.onChange(of: boardSize) {
					    boardSizeSelect(theSelection: boardSize)
					}

				    //put in a row with the current player label and value
				HStack(alignment: .top){
					Text("Current Player:")
						.modifier(basicTextModifierNoFrame())
						.frame(width: 100.0, height: 22.0,alignment: .leading)
						.accessibilityLabel("Current Player Label")
						.accessibilityIdentifier("currentPlayerLabel")

					Text(currentPlayer)
						.modifier(basicTextModifierNoFrame())
						.frame(width: 30.0,height: 22.0,alignment: .leading)
						.accessibilityLabel("Current Player")
						.accessibilityIdentifier("currentPlayer")
				}
			}
				//select blue player type
			VStack(alignment: .leading) {
				Text("Blue Player:")
					.modifier(basicTextModifier())
					.accessibilityLabel("Blue Player Label")
					.accessibilityIdentifier("bluePlayerLabel")
				bluePlayerTypeRadioButton(index: 1, selectedIndex: $bluePlayerType)
				bluePlayerTypeRadioButton(index: 2, selectedIndex: $bluePlayerType)
			}
			.padding(.leading, 20.0)

			//select red player type
			VStack(alignment: .leading) {
				Text("Red Player:")
					.modifier(basicTextModifier())
					.accessibilityLabel("Red Player Label")
					.accessibilityIdentifier("redPlayerLabel")
				redPlayerTypeRadioButton(index: 1, selectedIndex: $redPlayerType)
				redPlayerTypeRadioButton(index: 2, selectedIndex: $redPlayerType)
			}
			.padding(.leading, 20.0)

			//new game, record and replay buttons
			VStack(alignment: .leading) {
				Button("New Game"){
					//since myTuple technically never changes and is redefined with
					//every button click, we'll define it as a constant via "let" instead
					//of the mutable "var"
					//using a tuple makes passsing multiple vars to getInitVars() in SOS_SwiftApp.swift somewhat easier
					let myTuple = (theType: gameType, theSize: boardSize, theBlueType: bluePlayerType, theRedType: redPlayerType, theCurrentPlayer: currentPlayer)

					//function is actually in sos_Swiftapp.swift
					//this lets us put non-ui code in its own class file
					getInitVars(theType: myTuple.theType, theSize: myTuple.theSize, theBlueType: myTuple.theBlueType, theRedType: myTuple.theRedType, theCurrentPlayer: myTuple.theCurrentPlayer)
				}
				.padding(.top,5.0)

				Button("Record Game") {

				}
				//hiding for now, this is an extra goal anyway
				.hidden()


				Button("Replay Game") {
					//only enable this if "record" is enabled.
				}
				//hiding for now, this is an extra goal anyway
				.hidden()

			}
			.padding(.leading, 10.0)

		}
		//this forces the hstack to be the width of the window
		.frame(maxWidth: .infinity)
		//set the background of the hstack to gray
		.background(Color.gray)
		//this shoves everything to the top of the window
		Spacer()
	}
}

#Preview {
    ContentView()
}
