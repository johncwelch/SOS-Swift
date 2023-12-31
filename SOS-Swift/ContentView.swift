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
	//var to disable the game type & player type radio buttons so you can't change game type in the middle of playing
	@State var gamePlayerTypeDisabled: Bool = false
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
	//needed to have multiple game over alert states in the alert func
	@State var gameWasDraw: Bool = false
	//used to store game winner for general game for alert pop
	@State var generalGameWinner: String = ""
	//used to show/hide Start Game Button
	@State var showStartGameButton: Bool = false
	//for when the button is visible but needs to be disabled
	@State var disableStartGameButton: Bool = false

	//game recording vars
	//create an empty array of moveRecordStructs
	@State var gameMoveRecord = [moveRecord]()
	//toggle for recording games
	@State var recordGame: Bool = false
	//enabled state for playback button
	@State var playbackDisabled: Bool = true
	//used to disable the record game button during a game. avoids many problems
	@State var recordToggleDisabled: Bool = false


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
					.accessibilityLabel("gameTypeSimple")
				gameTypeRadioButtonView(index: 2, selectedIndex: $gameType)
					.accessibilityLabel("gameTypeGeneral")
					//
			}
			.padding(.leading, 20.0)
			//so what we're doing is technically disabling the Vstack the radio buttons are contained in
			//but that has the desired effect and we don't have to have one .disabled() method per radio button this way.
			.disabled(gamePlayerTypeDisabled)

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
						//boardSizeSelect(theSelection: theGame.gridSize)
						//print("Old Grid size is:\(arrayUsedMemberCountdown)")
						//set the countdown var to match the new size of the grid
						arrayUsedMemberCountdown = theGame.gridCellArr.count
						//print("New Grid size is:\(arrayUsedMemberCountdown)")
						//reinitialize the unused array since all the buttons are blanked on a resize
						arrayUsedButtonsList = buildUnusedArray(myGridSize: theGame.gridSize)
						//reset playerwon to false since new game
						playerWon = false
						//enable the game and player type radio buttons
						gamePlayerTypeDisabled = false
						//enable the start game button if it is visible
						disableStartGameButton = false
						//set scores to zero
						bluePlayerScore = 0
						redPlayerScore = 0
						//disable the buttons if the blue player is a computer, since blue always goes first
						if bluePlayerType == 2 {
							disableAllButtonsForBlueComputerPlayerStart(myGridArray: theGame)
						}
						//clear the game recording array
						gameMoveRecord.removeAll()
						//print("gameMoveRecord size is: \(gameMoveRecord.count)")
						//set the record toggle to off
						self.recordGame = false
						//disable the playback button
						self.playbackDisabled = true
						//enable the record game toggle
						self.recordToggleDisabled = false
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
					.accessibilityLabel("Blue Player Human")
				bluePlayerTypeRadioButton(index: 2, selectedIndex: $bluePlayerType)
					.accessibilityLabel("Blue Player Computer")
					.onChange(of: bluePlayerType) {
						//we hide whenever blue player is human
						if (bluePlayerType == 1) {
							//old if condition:(bluePlayerType == 1) && (redPlayerType == 1)
							showStartGameButton = false
							//if they change blue back to human, re-enable all the buttons
							enableOtherButtonsDuringMove(myGridArray: theGame)
							//modifying this because we don't need the start game button for the red player
							//only the blue, since blue ALWAYS goes first in a new game.
						} else if (bluePlayerType == 2) {
							showStartGameButton = true
							disableAllButtonsForBlueComputerPlayerStart(myGridArray: theGame)
						}
					}
				//this Hstack only displays its contents if the gameType is not 1 (simple)
				//because gameType is a state variable, the refresh happens automatically
				//we don't have to do any extra work.
				HStack(alignment: .center) {
					//in an if statement, we don't use the $varname, just the varname
					//if the game is simple, (1) then don't show the score
					if gameType != 1 {
						Text("Blue Score")
							//used for unit tests
							.accessibilityLabel("bluePlayerScoreLabel")
						//since score is an int, we coerce it to a string to display it
						Text(String(bluePlayerScore))
							.accessibilityLabel("bluePlayerScore")
						/*TextField(text: $bluePlayerScore) {
							Text("")
						}*/
						.frame(width: 25, height: 22, alignment: .center)

					}
				}
				.frame(width: 105, height: 22, alignment: .leading)

			}
			.padding(.leading, 20.0)
			.disabled(gamePlayerTypeDisabled)


			//select red player type
			VStack(alignment: .leading) {
				Text("Red Player:")
					.modifier(basicTextModifier())
					.accessibilityLabel("Red Player Label")
					.accessibilityIdentifier("redPlayerLabel")
				//radio buttons to chose between human and computer
				redPlayerTypeRadioButton(index: 1, selectedIndex: $redPlayerType)
					.accessibilityLabel("Red Player Human")
				redPlayerTypeRadioButton(index: 2, selectedIndex: $redPlayerType)
					.accessibilityLabel("Red Player Computer")
					.onChange(of: redPlayerType) {
						//we only show when blue player is computer
						//this is more of a doublecheck
						if (bluePlayerType == 1) {
							//slightly redundant but not overly so
							showStartGameButton = false
							//this may not be needed, we'll clean it up in the "make it pretty" spring
						}
					}
				HStack(alignment: .center) {
					//in an if statement, we don't use the $varname, just the varname
					if gameType != 1 {
						Text("Red Score")
							.accessibilityLabel("redPlayerScoreLabel")
						Text(String(redPlayerScore))
							.accessibilityLabel("redPlayerScore")
						.frame(width: 25, height: 22, alignment: .center)
					}
				}
				.frame(width: 105, height: 22, alignment: .leading)
			}
			.padding(.leading, 20.0)
			.disabled(gamePlayerTypeDisabled)

			//new game button
			VStack(alignment: .leading) {
				Button {
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
					//enable the game and player type radio buttons
					gamePlayerTypeDisabled = false
					disableStartGameButton = false
					//set scores to zero
					bluePlayerScore = 0
					redPlayerScore = 0
					//disable the buttons if the blue player is a computer, since blue always goes first
					if bluePlayerType == 2 {
						disableAllButtonsForBlueComputerPlayerStart(myGridArray: theGame)
					}
					//clear the game recording array
					gameMoveRecord.removeAll()
					//print("gameMoveRecord size is: \(gameMoveRecord.count)")
					//set the record toggle to off
					self.recordGame = false
					//disable the playback button
					self.playbackDisabled = true
					//enable the record game toggle
					self.recordToggleDisabled = false
				} label: {
					Text("New Game")
				}
				.padding(.top,5.0)


				//Commit Move button used to save the move just made, and set that button to disabled.
				//also changes color of the button to reflect the player who made the move
				//disables itself and changes who the current player is
				Button {
					//used for computer moves

					//on commit...
					//once you commit a move, we set the game type and player type buttons to disabled. the only way they re-enable
					//is for new game or grid size change which is effectively a new game
					gamePlayerTypeDisabled = true
					//also disable the record game toggle
					recordToggleDisabled = true

					//call commitMove() which alwasy calls checkForSOS() which may call setSOSButtonColor() (if there is an SOS)
					let theCommitTuple = commitMove(myCommittedButtonIndex: lastButtonClickedIndex, myUnusedButtons: arrayUsedButtonsList, myGridArray: theGame, myCurrentPlayer: currentPlayer, myArrayUsedMemberCountdown: arrayUsedMemberCountdown)
					//set the new values for the used buttons array and the "are we done yet" counter
					arrayUsedButtonsList = theCommitTuple.myUnusedButtonArray
					arrayUsedMemberCountdown = theCommitTuple.myCountDownInt

					//if we're recording, add the move to the record array. we put it after commitMove so we get the color right
					//check to see state of recordGame
					if recordGame {
						print("gameMoveRecord before function: \(gameMoveRecord)")
						//add the committed move to the array
						gameMoveRecord = addRecordedMove(myGameRecord: gameMoveRecord, myCommittedButtonIndex: lastButtonClickedIndex, myGridArray: theGame, myCurrentPlayer: currentPlayer)
						print("gameMoveRecord after function: \(gameMoveRecord)")
					}

					//set the SOSFlag, so we know if we need to increase score for general game
					//changing these to vars, because we may change them with computer players
					var SOSFlag = theCommitTuple.mySOSFlag
					//used for incrementing scores in general game because you can have one move create multiple SOS's
					var SOSCounter = theCommitTuple.mySOSCounter
					//once we click commit, we want it to be disabled
					buttonBlank = true
					//once we start the game manually, we don't need start game to be usable
					//since we can't change the player type mid game anyway
					disableStartGameButton = true
					//no one has won, and general game and SOS, increment score
					if (gameType == 2) && (SOSFlag) {
						let incrementScoreTuple = incrementScore(myCurrentPlayer: currentPlayer, myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore, mySOSCounter: SOSCounter)
						redPlayerScore = incrementScoreTuple.myRedPlayerScore
						bluePlayerScore = incrementScoreTuple.myBluePlayerScore
					}

					let gameOverTuple  = isGameOver(myArrayUsedMemberCountdown: arrayUsedMemberCountdown, myGameType: gameType, myGridArray: theGame, mySOSFlag: SOSFlag, myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore)

					//get is game a draw flag
					gameWasDraw = gameOverTuple.myGameIsDraw
					//winner of general game
					generalGameWinner = gameOverTuple.myGeneralGameWinner
					//get is game over/player won flag
					playerWon = gameOverTuple.myGameIsOver

					//if the game is over, exit the code here, because we don't want to
					//deal with the game making a computer move after it's been won
					//this is important since the computer player doesn't "click" the button
					//but rather just runs commitMove()
					if playerWon {
						//if the game is over and recordGame is true, we want to enable playback
						if recordGame {
							self.playbackDisabled = false
						}
						return
					}

					//change the player/increment score only if playerWon is false and gameType is general
					if !playerWon {
						//regardless of game type, we still change the player because no one won
						currentPlayer = changePlayer(myCurrentPlayer: currentPlayer)
					}

					//check to see if the next player is human or not. If human, then we don't do anything and wait
					//for the button click. If the next player is a computer, we call commitMove as with start button
					//but now we check for a win since we have to
					
					//first, make sure the game isn't over. doing this separately, may combine it with the player
					//change if later
					if !playerWon {
						//check for computer player. Since there's no real difference in the code other than the test,
						//we can collapse this into a single thing.
						//right now the else is there as a test statement, will be removed
						if ((currentPlayer == "Blue") && (bluePlayerType == 2)) || ((currentPlayer == "Red") && (redPlayerType == 2)) {

							//make the computer move, return button clicked index
							lastButtonClickedIndex = startGame(myUnusedButtons: arrayUsedButtonsList, myGridArray: theGame)

							//here's where we duplicate a lot of code, but we only do it once, so it's fine.
							//we can look at fixing it in the next sprint maybe.
							let theCommitTuple = commitMove(myCommittedButtonIndex: lastButtonClickedIndex, myUnusedButtons: arrayUsedButtonsList, myGridArray: theGame, myCurrentPlayer: currentPlayer, myArrayUsedMemberCountdown: arrayUsedMemberCountdown)

							arrayUsedButtonsList = theCommitTuple.myUnusedButtonArray
							arrayUsedMemberCountdown = theCommitTuple.myCountDownInt

							//if we're recording, add the move to the record array. we put it after commitMove so we get the color right
							//check to see state of recordGame
							if recordGame {
								print("gameMoveRecord before function: \(gameMoveRecord)")
								//add the committed move to the array
								gameMoveRecord = addRecordedMove(myGameRecord: gameMoveRecord, myCommittedButtonIndex: lastButtonClickedIndex, myGridArray: theGame, myCurrentPlayer: currentPlayer)
								print("gameMoveRecord after function: \(gameMoveRecord)")
							}

							SOSFlag = theCommitTuple.mySOSFlag
							SOSCounter = theCommitTuple.mySOSCounter
							buttonBlank = true
							disableStartGameButton = true

							if (gameType == 2) && (SOSFlag) {
								let incrementScoreTuple = incrementScore(myCurrentPlayer: currentPlayer, myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore, mySOSCounter: SOSCounter)
								redPlayerScore = incrementScoreTuple.myRedPlayerScore
								bluePlayerScore = incrementScoreTuple.myBluePlayerScore
							}

							let gameOverTuple  = isGameOver(myArrayUsedMemberCountdown: arrayUsedMemberCountdown, myGameType: gameType, myGridArray: theGame, mySOSFlag: SOSFlag, myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore)
							
							gameWasDraw = gameOverTuple.myGameIsDraw
							generalGameWinner = gameOverTuple.myGeneralGameWinner
							playerWon = gameOverTuple.myGameIsOver
							
							if playerWon {
								//if the game is over and recordGame is true, we want to enable playback
								if recordGame {
									self.playbackDisabled = false
								}
								return
							}
							
							if !playerWon {
								currentPlayer = changePlayer(myCurrentPlayer: currentPlayer)
							}

						} else if ((currentPlayer == "Blue") && (bluePlayerType == 1)) || ((currentPlayer == "Red") && (redPlayerType == 1))  {
							//print("Next player is \(currentPlayer) and is a human player")
						}
					}

				} label: {
					Text("Commit Move")					
				}
				.disabled(buttonBlank)
				.accessibilityLabel("commitButton")
				.alert(isPresented: $playerWon, content: { gameOverAlert(myPlayerColor: currentPlayer, myGameIsDraw: gameWasDraw, myGeneralGameWinner: generalGameWinner, myGameType: gameType) })
				
				//Start Game button for blue player as computer
				//only show button if true
				if showStartGameButton {
					Button {
						//since we are effectively starting the game, and we don't actually click the commit move
						//button, we replicate much of that here
						//disable things
						gamePlayerTypeDisabled = true
						recordToggleDisabled = true

						//since this only works on the first move, which is always blue, there's no point in caring
						//about red, but it literally takes half a line of code to set it up, so why not?
						if ((currentPlayer == "Blue") && (bluePlayerType == 2)) || ((currentPlayer == "Red") && (redPlayerType == 2)) {
							//get the last button "clicked" in the first computer move
							lastButtonClickedIndex = startGame(myUnusedButtons: arrayUsedButtonsList, myGridArray: theGame)
						}
						
						//so now we have a title and a button clicked, let's call commit move
						let theCommitTuple = commitMove(myCommittedButtonIndex: lastButtonClickedIndex, myUnusedButtons: arrayUsedButtonsList, myGridArray: theGame, myCurrentPlayer: currentPlayer, myArrayUsedMemberCountdown: arrayUsedMemberCountdown)

						arrayUsedButtonsList = theCommitTuple.myUnusedButtonArray
						arrayUsedMemberCountdown = theCommitTuple.myCountDownInt

						//if we're recording, add the move to the record array. we put it after commitMove so we get the color right
						//check to see state of recordGame
						if recordGame {
							print("gameMoveRecord before function: \(gameMoveRecord)")
							//add the committed move to the array
							gameMoveRecord = addRecordedMove(myGameRecord: gameMoveRecord, myCommittedButtonIndex: lastButtonClickedIndex, myGridArray: theGame, myCurrentPlayer: currentPlayer)
							print("gameMoveRecord after function: \(gameMoveRecord)")
						}

						var SOSFlag = theCommitTuple.mySOSFlag
						//used for incrementing scores in general game because you can have one move create multiple SOS's
						var SOSCounter = theCommitTuple.mySOSCounter
						//even though we didn't "click" commit move, we want the commit button to be disabled
						buttonBlank = true
						//once we start the game regardless of how, we don't need start game to be usable
						//since we can't change the player type mid game anyway
						disableStartGameButton = true
						//no one has won, and general game and SOS, increment score. note a win is impossible
						//for start button since it can only be used as the first move
						if (gameType == 2) && (SOSFlag) {
							let incrementScoreTuple = incrementScore(myCurrentPlayer: currentPlayer, myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore, mySOSCounter: SOSCounter)
							redPlayerScore = incrementScoreTuple.myRedPlayerScore
							bluePlayerScore = incrementScoreTuple.myBluePlayerScore
						}
						//we don't check for winning game here, the button isn't enabled for that
						//get is game over/player won flag

						//change the player
						currentPlayer = changePlayer(myCurrentPlayer: currentPlayer)
						
						//if both players aren't computer, we want to bug out here. This button only gets clicked if
						//both players are computer, so we can cheat with this:
						//red is a human, bug out of this code
						if (currentPlayer == "Red") && (redPlayerType == 1) {
							return
						}

						//this is a while because when we start with both players as computers, we never really leave
						//the start game click code. So for that, it all happens here.

						while !playerWon {
							//check for computer player. Since there's no real difference in the code other than the test,
							//we can collapse this into a single thing.
							//right now the else is there as a test statement, will be removed
							if ((currentPlayer == "Blue") && (bluePlayerType == 2)) || ((currentPlayer == "Red") && (redPlayerType == 2)) {
								//print("Next player is \(currentPlayer) and is a computer player")

								//make the computer move, return button clicked index
								lastButtonClickedIndex = startGame(myUnusedButtons: arrayUsedButtonsList, myGridArray: theGame)
								
								//there is more than a little code dupe here, but, because of how this runs
								//trying to shove it in a function doesn't make it faster or better, just a bit
								//neater. meh. 
								let theCommitTuple = commitMove(myCommittedButtonIndex: lastButtonClickedIndex, myUnusedButtons: arrayUsedButtonsList, myGridArray: theGame, myCurrentPlayer: currentPlayer, myArrayUsedMemberCountdown: arrayUsedMemberCountdown)

								arrayUsedButtonsList = theCommitTuple.myUnusedButtonArray
								arrayUsedMemberCountdown = theCommitTuple.myCountDownInt

								//if we're recording, add the move to the record array. we put it after commitMove so we get the color right
								//check to see state of recordGame
								if recordGame {
									print("gameMoveRecord before function: \(gameMoveRecord)")
									//add the committed move to the array
									gameMoveRecord = addRecordedMove(myGameRecord: gameMoveRecord, myCommittedButtonIndex: lastButtonClickedIndex, myGridArray: theGame, myCurrentPlayer: currentPlayer)
									print("gameMoveRecord after function: \(gameMoveRecord)")
								}

								SOSFlag = theCommitTuple.mySOSFlag
								SOSCounter = theCommitTuple.mySOSCounter
								buttonBlank = true
								disableStartGameButton = true

								if (gameType == 2) && (SOSFlag) {
									let incrementScoreTuple = incrementScore(myCurrentPlayer: currentPlayer, myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore, mySOSCounter: SOSCounter)
									redPlayerScore = incrementScoreTuple.myRedPlayerScore
									bluePlayerScore = incrementScoreTuple.myBluePlayerScore
								}

								let gameOverTuple  = isGameOver(myArrayUsedMemberCountdown: arrayUsedMemberCountdown, myGameType: gameType, myGridArray: theGame, mySOSFlag: SOSFlag, myRedPlayerScore: redPlayerScore, myBluePlayerScore: bluePlayerScore)

								gameWasDraw = gameOverTuple.myGameIsDraw
								generalGameWinner = gameOverTuple.myGeneralGameWinner
								playerWon = gameOverTuple.myGameIsOver

								if playerWon {
									if recordGame {
										self.playbackDisabled = false
									}
									return
								}

								if !playerWon {
									currentPlayer = changePlayer(myCurrentPlayer: currentPlayer)
								}

							} else if ((currentPlayer == "Blue") && (bluePlayerType == 1)) || ((currentPlayer == "Red") && (redPlayerType == 1))  {
								//print("Next player is \(currentPlayer) and is a human player")
							}
						}

					} label: {
						Text("Start Game")
					}
					.onAppear(perform: {
						//enable the start game button if it is visible
						disableStartGameButton = false
					})
					.disabled(disableStartGameButton)
					.accessibilityLabel("startButton")
					//since the only condition the start button is used is as a first move in a game, we don't need the
					//game won alert
				}
			}
			.padding(.leading, 10.0)
		}
		//this forces the hstack to be the width of the window
		.frame(maxWidth: .infinity)
		//set the background of the hstack to gray
		.background(Color.gray)
		//this shoves everything to the top of the window

		//hstack for record and playback.
		HStack(alignment: .top) {
			//record game button
			Toggle("Record Game:", isOn: $recordGame)
				.toggleStyle(.switch)
				.modifier(basicTextModifierNoFrame())
				.padding(.trailing, 10.0)
				.disabled(recordToggleDisabled)
				.accessibilityLabel("recordGameToggle")
				/*.onChange(of: recordGame) {
					print("Toggle State is: \(recordGame)")
				}*/
			//playback button
			Button {
				//call newGame() to clear all the buttons
				//doesn't actually create a new game, but we want this for playback
				newGame(myGridArray: theGame)
				//disable all the buttons so you can't click on them during/after playback
				for i in 0..<theGame.gridCellArr.count {
					theGame.gridCellArr[i].buttonDisabled = true
				}
				//print("gameMoveRecordSize: \(gameMoveRecord.count)")
				
				//local vars for array index position (thePlayBackCounter) and for making sure
				//we don't go out of bounds for theGameMoveRecord (theGameMoveRecordArrayBounds)
				var thePlayBackCounter = 0
				let theGameMoveRecordArrayBounds = gameMoveRecord.count - 1
				
				//timer that fires off once a second and plays back one move from gameMoveRecord each time
				Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
					//bounds check
					if thePlayBackCounter <= theGameMoveRecordArrayBounds {
						//play back one move
						currentPlayer = playbackGame(myGameRecord: gameMoveRecord, myGridArray: theGame, myLoopCount: thePlayBackCounter)
					} else {
						//we're done here. We don't empty the array here because we want to be able to play it back
						//multiple times
						timer.invalidate()
					}
					//increment our array index position
					thePlayBackCounter += 1
				}
			} label: {
				Text("Playback")
			}
			.disabled(playbackDisabled)
			.accessibilityLabel("playBackRecordedGame")

		}
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

								let myIndex = (row * theGame.gridSize) + col
								//set up the initial array of unused buttons

								//sanity check that avoids out of range errors when downsizing grid
								if myIndex <= ((theGame.gridSize * theGame.gridSize) - 1) {
									Button {
										//this is where we run the core function that does all the work
										//if the current player is a computer type
										//ignore the manual click
										if (currentPlayer == "Blue") && (bluePlayerType == 2) {
											return
										}

										if (currentPlayer == "Red") && (redPlayerType == 2) {
											return
										}
										
										//set lastButtonClickedIndex to index of button that was clicked
										lastButtonClickedIndex = theGame.gridCellArr[myIndex].index
										//send the current button title, the game array,
										//the current player and the unused buttons array
										//to buttonClickStuff

										//we get back a bool with the commit button disable status

										//the only return we really use is the commit button status so
										buttonBlank = buttonClickStuff(for: theGame.gridCellArr[myIndex].index, theTitle: theGame.gridCellArr[myIndex].title, myArray: theGame)
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
