//
//  ContentView.swift
//  SOS-Swift
//
//  Created by John Welch on 8/29/23.
//  this is the class file for our UI code

import SwiftUI

//build the main window view
struct ContentView: View {
	//vars for controls and current player
	//by using @State vars, we get a LOT of UI functionality for free
	@State var gameType: Int = 1
	@State var boardSize: Int = 3
	@State var bluePlayerType: Int = 1
	@State var redPlayerType: Int = 1
	@State var bluePlayerScore: Int = 0
	@State var redPlayerScore: Int = 0
	@State var currentPlayer: String = "Blue"


	var body: some View {

		//builds the cell array based on boardSize. Any time boardSize changes, this is
		//rebuilt thanks to the magic of state vars
		@State var gridCellArr = buildCellArray(theGridSize: boardSize)
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
				//this Hstack only displays its contents if the gameType is not 1 (simple)
				//because gameType is a state variable, the refresh happens automatically
				//we don't have to do any extra work.
				HStack(alignment: .center) {
					//in an if statement, we don't use the $varname, just the varname
					if gameType != 1 {
						Text("Blue Score")
						Text(String(bluePlayerScore))
						/*TextField(text: $bluePlayerScore) {
							Text("")
						}*/
						.frame(width: 25, height: 22, alignment: .center)
					}
				}
				.frame(width: 105, height: 22, alignment: .leading)

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
				HStack(alignment: .center) {
					//in an if statement, we don't use the $varname, just the varname
					if gameType != 1 {
						Text("Red Score")
						Text(String(redPlayerScore))
						/*TextField(text: $bluePlayerScore) {
							Text("")
						}*/
						.frame(width: 25, height: 22, alignment: .center)
					}
				}
				.frame(width: 105, height: 22, alignment: .leading)
			}
			.padding(.leading, 20.0)

			//new game, record and replay buttons
			VStack(alignment: .leading) {
				Button("New Game"){
					//since myTuple technically never changes and is redefined with
					//every button click, we'll define it as a constant via "let" instead
					//of the mutable "var"
					//using a tuple makes passsing multiple vars to getInitVars() in SOS_SwiftApp.swift somewhat easier

					//clears any existing moves, disables board size/game mode/player mode controls
					let myTuple = (theType: gameType, theSize: boardSize, theBlueType: bluePlayerType, theRedType: redPlayerType, theCurrentPlayer: currentPlayer)

					//function is actually in sos_Swiftapp.swift
					//this lets us put non-ui code in its own class file
					getInitVars(theType: myTuple.theType, theSize: myTuple.theSize, theBlueType: myTuple.theBlueType, theRedType: myTuple.theRedType, theCurrentPlayer: myTuple.theCurrentPlayer)
				}
				.padding(.top,5.0)

				Button("Cancel Game") {
					//used to abort game in progress
				}
				.hidden()

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

		//Hstack for the grid
		//once nice thing about the CSS-like behavior of SwiftUI, it makes a lot of things
		//easier, like the autoresizing of the grid and because the controls Hstack
		//is the width of the window this Hstack inherits that behavior for free

		HStack(alignment: .top) {
			Grid (horizontalSpacing: 0, verticalSpacing: 0){

				//the view (grid) will refresh if you change the state var gridSize,
				//but, you have to include the id: \.self for it to work right, because
				//of how swift handles this. Note, you don't use the id, 
				//this is just telling the view what's going on.

				//row foreach
				ForEach(0..<boardSize, id: \.self) { row in
					GridRow {
						//column foreach
						ForEach(0..<boardSize, id: \.self) {col in
								//put a rectangle in each grid space
								//the overlay is how you add text
								//the border is how you set up grid lines
								//the order is important. if foreground color comes after
								//overlay, it covers the overlay
								//gridCellSize is how we get the size
							GeometryReader { gridCellSize in
								Rectangle()
									.foregroundColor(.teal)
									.overlay(Text("\(row),\(col)").fontWeight(.heavy))
									.border(Color.black)

								Button {

								} label: {
									Text("")
										//.frame(width: proxy.size.width,height: proxy.size.height)
										.frame(width: gridCellSize.frame(in: .global).width,height: gridCellSize.frame(in: .global).height)
								}
									//keeping this for now in case we need to use it later
									//but not required for this stage

								/*if (row + col).isMultiple(of: 2) {
									//the overlay is how you add text
									//the border is how you set up grid lines
									Rectangle()
									//the order is important. if foreground color comes after overlay, it covers the overlay
										.foregroundColor(.teal)
										//this will eventually go away when we add buttons,
										//but for now, we keep the formatting props in the
										//overlay properties
										.overlay(Text("\(row),\(col)").fontWeight(.heavy))
										.border(Color.black )
								} else {
									Rectangle()
										.foregroundColor(.teal)
										.overlay(Text("\(row),\(col)").fontWeight(.heavy))
										.border(Color.black)
								}*/
							}

						}
					}
				}
			}
		}
	}
}

#Preview {
    ContentView()
}
