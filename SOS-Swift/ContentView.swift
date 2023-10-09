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
	@State var lastButtonClickedIndex: Int = 0
	@State var buttonTextColor: Color = .white
	@State var buttonBlank: Bool = true
	//@State var cellButtonTitle: String = ""


	@State var gridCellArr = buildCellArray(theGridSize: 3)


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
				    //test func to show size of board based on selection
					.onChange(of: boardSize) {
					    boardSizeSelect(theSelection: boardSize)

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

					//function is actually in appData.swift
					//this lets us put non-ui code in its own class file
					getInitVars(theType: myTuple.theType, theSize: myTuple.theSize, theBlueType: myTuple.theBlueType, theRedType: myTuple.theRedType, theCurrentPlayer: myTuple.theCurrentPlayer)
				}
				.padding(.top,5.0)


				//used to save the move just made, and set that button to disabled.
				//also changes color of the button to reflect the player who made the move
				//disables itself and changes who the current player is
				Button {
					//on commit...
					//set the background color to that of the current player
					gridCellArr[lastButtonClickedIndex].backCol = setButtonColor(myCurrentPlayer: currentPlayer)
					//disable that button from further use
					gridCellArr[lastButtonClickedIndex].buttonDisabled = true
					//disable the commit button
					buttonBlank = true
					//change the player
					currentPlayer = changePlayer(myCurrentPlayer: currentPlayer)
				} label: {
					Text("Commit Move")					
				}
				.disabled(buttonBlank)

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
						ForEach(0..<boardSize, id: \.self) { col in
								//put a rectangle in each grid space
								//the overlay is how you add text
								//the border is how you set up grid lines
								//the order is important. if foreground color comes after
								//overlay, it covers the overlay
								//gridCellSize is how we get the size
							GeometryReader { gridCellSize in
								//this sets up the index for gridCellArr so we "know" what button
								//we're clicking
								let myIndex = row * boardSize + col
								//Rectangle()
									//.foregroundColor(.teal)
									//.overlay(Text("\(row),\(col)").fontWeight(.heavy))
									//.border(Color.black)

								Button {
									//this is where we run the core function that does all the work
									var theTuple = buttonClickStuff(for: gridCellArr[myIndex].index, theTitle: gridCellArr[myIndex].title, myArray: gridCellArr, myCurrentPlayer: currentPlayer)

									gridCellArr[myIndex].title = theTuple.myTitle
									buttonBlank = theTuple.myCommitButtonStatus
									lastButtonClickedIndex = gridCellArr[myIndex].index

									//print statements to validate the button clicked properties
									//print("the current index is: \(gridCellArr[myIndex].index), the current button grid location is \(gridCellArr[myIndex].xCoord),\(gridCellArr[myIndex].yCoord)")
									//print("buttonBlank is: \(buttonBlank)")

								} label: {
									//set the text of the button to be the title of the button
									Text(gridCellArr[myIndex].title)
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
								.background(gridCellArr[myIndex].backCol)
								.border(Color.black)
								//once a move is committed, buttonDisabled is set to true, and the button is
								//disabled so it can't be used again
								.disabled(gridCellArr[myIndex].buttonDisabled)

								.onAppear(perform: {
									//print("my index is: \(myIndex)")
									//this has each button set its own coordinates as it appears
									//which is IMPORTANT later on
									gridCellArr[myIndex].xCoord = col
									gridCellArr[myIndex].yCoord = row
								})

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
