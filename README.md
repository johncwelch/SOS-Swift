#  SOS-Swift Readme

so as this is a class project, this will be a bit uncommon in terms of format.

The current iteration as of 5 sept. 2023 solves the basic requirements for the Sprint0 assignment: there's a basic UI, some basic unit tests, etc.

The next part, code-wise will be setting up the game board and allowing it to be resized via the dropdown list in the app.

##User Storys and status  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.1	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.2	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.1	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.2	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.3	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.1	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.1	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.2  done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.1  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.2  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.1	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.2  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.3  done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7.1  
	

##20230907:  
Cleaned up the text and label formatting code with a couple of ViewModifier structs, basicTextModifierNoFrame and basicTextModifier. The difference is, one modfies frame properties, the other does not. Also moved the three radio button definition structs from ContentView into SOS_SwiftApp.swift, the idea being to have as little as possible code that isn't directly involved with the UI functionality in ContentView.swift

##20230912:  
Added the grid into the app. We get resizing for free. Notes from grid comments. with the Hstack for the grid once nice thing about the CSS-like behavior of SwiftUI, it makes a lot of things easier, like the autoresizing of the grid and because the controls Hstack  is the width of the window, the Hstack inherits that behavior for free. The view (grid) will refresh if you change the state var gridSize, but, you have to include the id: \.self for it to work right, because of how swift handles this. Note, you don't use the id, this is just telling the view what's going on.

	Grid Cell Notes: We put a rectangle in each grid space. The overlay is how you add text, the border is how you set up grid lines. The order is important. if foreground color property comes after overlay text property, it covers the overlay property. I left the code treating "even" cells differently from "odd" cells in just in case I need it later. Next step is some grid unit tests.

##20230917:  
Added in Htstack with score text fields and "Cancel Game" button (nothing hooked up yet. hidden for now because we may not actually need it) Set up if statement to use gameType state var to hide and show fields within the hstack for the score fields. If it's a simple game, there's no score shown. If a general game, there's a score. By hooking this to the state var, when you choose between simple and general, the fields automatically show and hide. To simplify things, the only way to switch states once a game is started is to click new game button.

##20230919:  
GOT THE BUTTONS IN!!!! the hard part was getting the size to match the cell. Answer? GeometryReader! So we enclose the Rectangle() for each cell in GeometryReader{}, and then using the <var> in variable for GR, we add a button with the frame for the label text set to using the GeometryReader data:
		
		GeometryReader { gridCellSize in
			Rectangle()
				.foregroundColor(.teal)
				.overlay(Text("\(row),\(col)").fontWeight(.heavy))
				.border(Color.black)

			Button {

			} label: {
				Text("")
					.frame(width: gridCellSize.frame(in: .global).width,height: gridCellSize.frame(in: .global).height)
			}
		}

	et voila, we have a clickable button that is always the size of the cell it is in. Because that is just AWESOME AS HELL and so easy. 
	
##20231012  
GOT THE RESIZING WORKING WITH THE BUTTON TITLE CHANGES!!
	so now when you click on a button, it cycles through "", "S", and "O", and when a button is showing "S" or "O", the "Commit Move" button is enabled. I still have to implement locking out other buttons when "S" or "O" is showing so "bad" moves can't be made. Commit move also changes the current player, and sets the background color of the button to the player that made the move. 
	
	this was remarkably difficult due to how SwiftUI handles certain things and required me redoing how I create the array that's attached to the buttons completely. But, it's working, each button knows what it is and where it is, which will be critical in calculating "SOS" or not. But the next immediate thing is wiring in the code to prevent more than one button having a title and having new game do its thing. 

##20231013  
New Game functionality done. This clears user story 3.1 completely 

##20231017  
added:  if myIndex <= ((theGame.gridSize * theGame.gridSize) - 1) after let myIndex = (row * theGame.gridSize) + col, put all the direct Button() code in that if, to avoid the out of range errors happening when grid size was shrunk. 

##20231022  
added:  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func disableOtherButtonsDuringMove (myGridArray: Game, currentButtonIndex: Int), this handles disabling other buttons during a move, so you can't cheat and set multiple buttons.  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func enableOtherButtonsDuringMove (myGridArray: Game), this handles enabling the other buttons during a move so you can change your mind if you want.  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func commitMove (myCommittedButtonIndex: Int, myUnusedButtons: [Int],myGridArray: Game, myCurrentPlayer: String) -> [Int], this let us remove some statements out of the Commit Button action in ContentView, and sets up everything in the commit move functionality except for checking for an SOS/game win.  
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;It sets the color of the button you're committing.  
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Removes it from the unused button array.  
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Disables it so it can't be changed.  
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;And ensures the unused buttons are enable.  
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;started on func checkForSOS(myGridArray: Game, myLastButtonClickedIndex: Int, myGridSize: Int), which will check for SOS. the edge detection is done, now to do the searching for "S" and for "O". Will do "S" first, it's more linear

##20231023  
added:  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func checkForSOS(myGridArray: Game, myLastButtonClickedIndex: Int, myGridSize: Int)   
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eventually this will return a "game won" flag if the game is won  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;currently implementing "S" checks:  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LTR up diag  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LTR down diag  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LTR horizontal  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vertical up  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vertical down  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;are done. There's also a curious bug related to resizing the grid to the same size causing the coords and indices to blow the fuck up. No idea yet, but will troubleshoot if we've time.  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Also figured out quick formula for S term checks that doesn't require array traversal:  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LTR Horizontal is index + 1 for next square  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LTR Diag Down is (index) + (gridsize + 1)  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LTR Diag Up is (index) - (gridsize -1)  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vertical Up is index - gridsize  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vertical Down is index + gridsize  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RTL Horizontal is index - 1  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RTL Diag Down is (index) + (gridsize - 1)  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RTL Diag Up is (index) - (gridsize + 1)  
  
##20231024  
added:  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RTL Horizontal  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RTL Diag Up  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RTL Diag Down  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;So now all checks for S buttons are done. Next is "O", which will require less checks because O is in the middle of SOS, so only 4 checks needed not 8:  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;horizontal  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vertical    
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;diag up   
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;diag down  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Implemented Horizontal O Check  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Implemented Vertical O Check  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Implemented Both Diagonal O Checks  
			to do:  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;color all three cells on SOS, done via func setSOSButtonColor(myCurrentPlayer: String, myFirstIndex: Int, mySecondIndex: Int, myThirdIndex: Int, myGridArray: Game)  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Winner functionality (pop alert, all buttons disabled, must change grid size or new game to play again)  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Game over with no winner  
			modified commitMove() to not color the button if mySOSFlag is true (not false)  
			modified checkForSOS() to return a bool, SOSFlag  
			added func gameOverAlert(myPlayerColor: String) -> Alert which will display appropriate alert when game is over  
			added func isGameOver(myArrayUsedMemberCountdown: Int, myGameType: Int, myGridArray: Game, mySOSFlag: Bool) -> Bool which checks to see if game is over  
			added .alert(isPresented: $playerWon, content: { gameOverAlert(myPlayerColor: currentPlayer) }) for commit move button which displays game over alert if playerWon is true. (yeah, less than amazing varname, we may even fix it)
  
