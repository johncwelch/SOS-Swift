//
//  ContentView.swift
//  SOS-Swift
//
//  Created by John Welch on 8/29/23.
//  this is the class file for our UI code

import SwiftUI
import Observation

//build the main window view
struct ContentView: View {
	//vars for controls and current player
	//by using @State vars, we get a LOT of UI functionality for free
	//initial game type, always simple on launch, 1 == simple, 2 == general
	@State var gameType: Int = 1
	//initial player types, always human on launch, 1 == human, 2 == computer
	@State var bluePlayerType: Int = 1
	@State var redPlayerType: Int = 1
	//initial scores, always 0 on launch
	@State var bluePlayerScore: Int = 0
	@State var redPlayerScore: Int = 0
	//initial player, always Blue on launch
	@State var currentPlayer: String = "Blue"
	//index of last button clicked
	@State var lastButtonClickedIndex: Int = 0
	//color of text in the buttons
	@State var buttonTextColor: Color = .white
	//used to change state of commit button, true (disabled) on launch
	@State var buttonBlank: Bool = true
	//creates array of classes used to track button behavior and actions
	//when button grid is attached, each button has its own theGame element
	//attached
	@State var theGame = Game(gridSize: 3)
	//matches array size in theGame, which is initially 9
	@State var arrayUsedMemberCountdown: Int = 9
	//array to track used buttons. By default, all arrays in swift are mutable/dynamic
	//so we don't need to set a specific size. This creates an array of 0 items
	//we also use the = [Int]() to reinitialize the array for a new game

	//initialize the unused buttons array
	@State var arrayUsedButtonsList = buildUnusedArray(myGridSize: 3)
	//this ends up making popping a "you won!" alert much easier
	@State var playerWon: Bool = false


	var body: some View {
		//@State var gridCellArr = buildCellArray(theGridSize: boardSize)
		//builds the cell array based on boardSize. Any time boardSize changes, this is
		//rebuilt thanks to the magic of state vars

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
				    //this actually draws the buttons, simple = 1, general = 2
				gameTypeRadioButtonView(index: 1, selectedIndex: $gameType)
				gameTypeRadioButtonView(index: 2, selectedIndex: $gameType)
					//
			}
			.padding(.leading, 20.0)

			//select board size
			VStack(alignment: .leading) {
				Picker("Board Size", selection: $theGame.gridSize) {
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
					//test func to show size of board based on selection
					.onChange(of: theGame.gridSize) {
						    boardSizeSelect(theSelection: theGame.gridSize)
						//print("Old Grid size is:\(arrayUsedMemberCountdown)")
						//set the countdown var to match the new size of the grid
						arrayUsedMemberCountdown = theGame.gridCellArr.count
						//print("New Grid size is:\(arrayUsedMemberCountdown)")
						//reinitialize the unused array since all the buttons are blanked on a resize
						arrayUsedButtonsList = buildUnusedArray(myGridSize: theGame.gridSize)
						//reset playerwon to false since new game
						playerWon = false
					}

				    //put in a row with the current player label and value
				HStack(alignment: .top){
					//label for field
					Text("Current Player:")
						.modifier(basicTextModifierNoFrame())
						.frame(width: 100.0, height: 22.0,alignment: .leading)
						.accessibilityLabel("Current Player Label")
						.accessibilityIdentifier("currentPlayerLabel")
					//actual name of current player, changes based on exection of changePlayer via "Commit Move" button
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
				//radio buttons to chose between human and computer
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
				//radio buttons to chose between human and computer
				redPlayerTypeRadioButton(index: 1, selectedIndex: $redPlayerType)
				redPlayerTypeRadioButton(index: 2, selectedIndex: $redPlayerType)
				HStack(alignment: .center) {
					//in an if statement, we don't use the $varname, just the varname
					if gameType != 1 {
						Text("Red Score")
						Text(String(redPlayerScore))
						.frame(width: 25, height: 22, alignment: .center)
					}
				}
				.frame(width: 105, height: 22, alignment: .leading)
			}
			.padding(.leading, 20.0)

			//new game, record and replay buttons
			VStack(alignment: .leading) {
				Button("New Game"){
					//newGame clears any existing "S" or "O" text, 
					//sets all button colors back to gray
					//and enables all buttons on the grid.
					//It doesn't change anything else
					newGame(myGridArray: theGame)
					//set the current player to blue
					currentPlayer = "Blue"
					//set the countdown to the current size. this is not strictly
					//necessary, but it makes sure the countdown is what we expect
					arrayUsedMemberCountdown = theGame.gridCellArr.count
					//reinitialize the array of used buttons to be empty, in a new game
					//there are no used buttons
					arrayUsedButtonsList = buildUnusedArray(myGridSize: theGame.gridSize)
					//reset playerWon to false since new game
					playerWon = false
				}
				.padding(.top,5.0)


				//used to save the move just made, and set that button to disabled.
				//also changes color of the button to reflect the player who made the move
				//disables itself and changes who the current player is
				Button {

					//on commit...
					//call commitMove() which alwasy calls checkForSOS() which may call setSOSButtonColor() (if there is an SOS)
					let theCommitTuple = commitMove(myCommittedButtonIndex: lastButtonClickedIndex, myUnusedButtons: arrayUsedButtonsList, myGridArray: theGame, myCurrentPlayer: currentPlayer, myArrayUsedMemberCountdown: arrayUsedMemberCountdown)
					arrayUsedButtonsList = theCommitTuple.myUnusedButtonArray
					arrayUsedMemberCountdown = theCommitTuple.myCountDownInt
					let SOSFlag = theCommitTuple.mySOSFlag
					buttonBlank = true
					playerWon = isGameOver(myArrayUsedMemberCountdown: arrayUsedMemberCountdown, myGameType: gameType, myGridArray: theGame, mySOSFlag: SOSFlag)

					//change the player only if playerWon is false
					if !playerWon {
						currentPlayer = changePlayer(myCurrentPlayer: currentPlayer)
					}

				} label: {
					Text("Commit Move")					
				}
				.disabled(buttonBlank)
				.alert(isPresented: $playerWon, content: { gameOverAlert(myPlayerColor: currentPlayer) })

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
				ForEach(0..<theGame.gridSize, id: \.self) { row in
					GridRow {
						//column foreach
						ForEach(0..<theGame.gridSize, id: \.self) { col in
								//put a rectangle in each grid space
								//the overlay is how you add text
								//the border is how you set up grid lines
								//the order is important. if foreground color comes after
								//overlay, it covers the overlay
								//gridCellSize is how we get the size
							GeometryReader { gridCellSize in
								//this sets up the index for gridCellArr so we "know" what button
								//we're clicking
								//let myIndex = row * boardSize + col
								let myIndex = (row * theGame.gridSize) + col
								//set up the initial array of unused buttons
								//let arrayUsedButtonslist
								//print("The used buttons array is \(arrayUsedButtonslist)")
								//sanity check that avoids out of range errors when downsizing grid
								if myIndex <= ((theGame.gridSize * theGame.gridSize) - 1) {
									Button {
										//this is where we run the core function that does all the work
										lastButtonClickedIndex = theGame.gridCellArr[myIndex].index
										let theTuple = buttonClickStuff(for: theGame.gridCellArr[myIndex].index, theTitle: theGame.gridCellArr[myIndex].title, myArray: theGame, myCurrentPlayer: currentPlayer, myUnusedButtons: arrayUsedButtonsList)

										theGame.gridCellArr[myIndex].title = theTuple.myTitle
										buttonBlank = theTuple.myCommitButtonStatus
										lastButtonClickedIndex = theGame.gridCellArr[myIndex].index

										//print("Current button index is: \(theGame.gridCellArr[myIndex].index)")
										//print("Button Coords are: \(theGame.gridCellArr[myIndex].xCoord),\(theGame.gridCellArr[myIndex].yCoord)")

									} label: {
										//set the text of the button to be the title of the button
										Text(theGame.gridCellArr[myIndex].title)
											//set the font of the button text to be system with a
											//size of 36, a weight of heavy, and to be a serif font
											.font(.system(size: 36, weight: .heavy, design: .serif))

											//this ensures the buttons are always the right size
											.frame(width: gridCellSize.frame(in: .global).width,height: gridCellSize.frame(in: .global).height, alignment: .center)
									}
									//styles button. Since I only have to do this once, here, there's no
									//real point in building a separate button style
									//note that .background is necessary to avoid weird button display errors
									.foregroundStyle(buttonTextColor)
									//this allows the button color to change on commit
									.background(theGame.gridCellArr[myIndex].backCol)
									.border(Color.black)
									//once a move is committed, buttonDisabled is set to true, and the button is
									//disabled so it can't be used again
									.disabled(theGame.gridCellArr[myIndex].buttonDisabled)
									.onAppear(perform: {
										//this has each button set its own coordinates as it appears
										//which is IMPORTANT later on
										theGame.gridCellArr[myIndex].xCoord = col
										theGame.gridCellArr[myIndex].yCoord = row

									})
								}
							}
						}
					}
				}
				//this is needed to force all squares to redraw. If it's not there, then when you go from 3x3 to 4x4 for example,
				//the original 9 squares don't actually update. That's not good, so this fixes it.
				.id(theGame.gridSize)
			}
		}
	}
}

#Preview {
    ContentView()
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
