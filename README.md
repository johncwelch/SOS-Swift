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
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.1  done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.2  done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.1	done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.2  done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.3  done  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7.1  done  
	

##20230907:  
Cleaned up the text and label formatting code with a couple of ViewModifier structs, basicTextModifierNoFrame and basicTextModifier. The difference is, one modfies frame properties, the other does not. Also moved the three radio button definition structs from ContentView into SOS_SwiftApp.swift, the idea being to have as little as possible code that isn't directly involved with the UI functionality in ContentView.swift

##20230912:  
Added the grid into the app. We get resizing for free. Notes from grid comments. with the Hstack for the grid once nice thing about the CSS-like behavior of SwiftUI, it makes a lot of things easier, like the autoresizing of the grid and because the controls Hstack  is the width of the window, the Hstack inherits that behavior for free. The view (grid) will refresh if you change the state var gridSize, but, you have to include the id: \.self for it to work right, because of how swift handles this. Note, you don't use the id, this is just telling the view what's going on.

	Grid Cell Notes: We put a rectangle in each grid space. The overlay is how you add text, the border is how you set up grid lines. The order is important. if foreground color property comes after overlay text property, it covers the overlay property. I left the code treating "even" cells differently from "odd" cells in just in case I need it later. Next step is some grid unit tests.

##20230917:  
Added in Htstack with score text fields and "Cancel Game" button (nothing hooked up yet. hidden for now because we may not actually need it) Set up if statement to use gameType state var to hide and show fields within the hstack for the score fields. If it's a simple game, there's no score shown. If a general game, there's a score. By hooking this to the state var, when you choose between simple and general, the fields automatically show and hide. To simplify things, the only way to switch states once a game is started is to click new game button.

##20230919:  
GOT THE BUTTONS IN!!!! the hard part was getting the size to match the cell. Answer? GeometryReader! So we enclose the Rectangle() for each cell in GeometryReader{}, and then using the \<var\> in variable for GR, we add a button with the frame for the label text set to using the GeometryReader data:
		
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
added:  if myIndex \<= ((theGame.gridSize * theGame.gridSize) - 1) after let myIndex = (row * theGame.gridSize) + col, put all the direct Button() code in that if, to avoid the out of range errors happening when grid size was shrunk. 

##20231022  
added:  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func disableOtherButtonsDuringMove (myGridArray: Game, currentButtonIndex: Int), this handles disabling other buttons during a move, so you can't cheat and set multiple buttons.  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func enableOtherButtonsDuringMove (myGridArray: Game), this handles enabling the other buttons during a move so you can change your mind if you want.  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func commitMove (myCommittedButtonIndex: Int, myUnusedButtons: [Int],myGridArray: Game, myCurrentPlayer: String) \-\> [Int], this let us remove some statements out of the Commit Button action in ContentView, and sets up everything in the commit move functionality except for checking for an SOS/game win.  
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
			added func gameOverAlert(myPlayerColor: String) \-\> Alert which will display appropriate alert when game is over  
			added func isGameOver(myArrayUsedMemberCountdown: Int, myGameType: Int, myGridArray: Game, mySOSFlag: Bool) \-\> Bool which checks to see if game is over  
			added .alert(isPresented: $playerWon, content: { gameOverAlert(myPlayerColor: currentPlayer) }) for commit move button which displays game over alert if playerWon is true. (yeah, less than amazing varname, we may even fix it)
			
##20231025  
updated the alert to .alert(isPresented: $playerWon, content: { gameOverAlert(myPlayerColor: currentPlayer, myGameIsDraw: gameWasDraw) }), which passes the gameDraw status to gameOverAlert() so we can alternate game over messages based on if the game is a draw (no winner) or not (winner.)  

updated gameOverAlert() to add game draw bool, and set title and message vars based on gamedraw status, so we can alternate between different messages. for general game, may update to show score in alert, but maybe not. This completes all simple game user stories for human players  

added gamePlayerTypeDisabled state var so we can disable the game type and player type controls once a move is committed. They're re-enabled for new game or grid resize, which is effectively a new game.  
  
added func incrementScore(myCurrentPlayer: String, myRedPlayerScore: Int, myBluePlayerScore: Int) \-\> (myRedPlayerScore: Int, myBluePlayerScore: Int) to handle score incrementing during a game. also updated new game and grid size change to set scores back to 0

updated the following to handle general game, especially the case where one move creates multiple SOS's:  
  
incrementScore() with an SOScounter that is added to the current player score so that a correct score is given  
  
gameOverAlert() with a general game winner string and game type. If it's a simple game, then the current player is the winner (since that doesn't change for a simple game getting an SOS), if it's a general game, then the general Game winner is used. Draws are still draws  
   
isGameOver() added general game code, mostly for the "countdown is \<= 0" parts, since the only way to win a general game or finish it at all is to fill in every square. It uses the scores passed to it to set the game winner string used by gameOverAlert()  
  
checkForSOS() added an SOS counter that is incremented for every case of the SOS flag being set true. This allows for cases where you have *multiple* SOS's created by a single move in a general game.  
  
commitMove() since this is what calls checkForSOS(), added a counter var to pull from the tuple checkForSOS() returns and added that to the return tuple for commitMove()  
  
Commit Move button action code:  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;added call to incrementScore() before game over check, so if the game is over, the score is corret. Called when   gameType is general AND SOSFlag is true  
  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;updated calls to isGameOver() and gameOverAlert()  
	  
this completes user stories 6.2 and 7.1. All that's left for the homework is generate some unit tests

##20231026  
  
figured out unit tests for this stuff. Lord. Anyway, SO MANY UNIT TESTS  

##20231031  
added a "start game" button to better deal with setting computer opponents. We still only allow this at the beginning of a game, to avoid switching mid stream. Created showStartGameButton bool state var to manage showing the start game button. If both player types are human, it's hidden. If either one is computer, it shows.  
  
added manual click sink in game button click to disallow manual button clicks for a computer on game start. Added for both players, probably will only ever need for blue. Basically:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (currentPlayer == "\<color\>") && (\<color\>PlayerType == 2) {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}  
added shell for start game function (really only used for blue player being computer)  
Cleaned up buttonClickStuff() to remove unused button color set code and entry in return tuple  
  
startGame() now takes the same args as commitMove(), because we're going to call commitMove() from within startGame(). No idea on the complete return of startGame() yet. But, it's going to do a LOT of what commitMove() does. as of now, startGame():  
  
* creates a string array of S and O  
* shuffles that array, then puts the first element of the shuffled array into a string var  
* it then grabs a random index out of the unused button array via Int.random()  
* it sets the title of the button at the random index to whatever value it got from the shuffled string array. that's working!  
  
Next we do the code for calling commitMove() and managing the return from that correctly. Basically, that will just get passed back out of startGame() to ContentView and run from there.  
  
Once that's done, if there's no win, we change players and go from there.  
  
First we'll deal with the other player being human.  
  
Then we deal with both players being computer.  

##20231102  
Start Game button works correctly, calls commitMove() correctly, does not check for a win since it can't, it's only used for the first move  

next is to check for a robot player or human. If new player is human, then wait for button click like we do now. if the new player is a robot, then call commitMove() from inside itself. This could get ugly, since there's no real elegant way to do this. We always have to call commitMove(), even if from a separate function. So we'll go with the dumb way first and hope it works.  
  
modified start game to not pass the raw index for 0..\<unusedbuttonarray.count but rather the value at that index, avoids some nasty out of bounds issues that way  
starting with blue as computer player and red human works! We still have to disallow clicks for when blue is set to computer at start as first move.

works with blue as human and red as computer, no changes!  
  
Got computer v. computer working by putting the code from the commit move button action section into the start game section (since the game never leaves that code for computer v. computer) and changed the if !playerWon to while !playerWon. It runs the initial move code for start game just the same, but the last statement before the loop changes the player from blue to red. At that point, if the red player is a computer too, then it just loops until playerWon is true. Side benefit to @State vars: the alert function attached to the Commit Move button ALSO works for the game ending in Start Game, so W00T! Less work!  
  
Yes, I know, code duplication between commit move and start move, but fixing that is probably more trouble than it is worth, and I didn't have to change any of the actual functions, just the way I'm using them in ContentView, so FUCK YEAH!!!  

The last thing to do is clean up the initial state code so you can't click a button if you start a game with blue as the computer, and start game doesn't appear if blue is human and red is a computer.  
  
Got the initial state cleaned up for starting the game. Added func disableAllButtonsForBlueComputerPlayerStart (myGridArray: Game) which is only run when the blue player is set to computer. it does two things:  
  
* sets the title of every button to ""
* disables every button  

if blue is changed back to human, then enableOtherButtonsDuringMove(myGridArray: theGame) is run and all the buttons are re-enabled. we also run disableAllButtonsForBlueComputerPlayerStart() for a new game (if blue is set to computer) and for resizing, which is also a form of new game. since you can only set the player types before the first move is made, this works rather nicely. now all i need is a unit test or two for the new stuff and this sprint is done.

##20231109  
Code Cleanup Phase:  
  
* Remove extraneous lastButtonClickedIndex = theGame.gridCellArr[myIndex].index from button click in ContentView  
* Set button title in buttonClickStuff, not ContentView  
* Update buttonClickStuff() to only return a bool, it's all we need  
* Do we really need buttonTitle for computer moves outside of startButton()? We do not  
* Update startGame() to only return the button clicked index int  
* May not need start button state code for changing red player to computer at all, it was not  
* Fixed error with hiding start game button on blue player start, it was requiring both players to be human to hide, that was incorrect  	  
* Change all the vars to lets as the compiler is begging us to. Ignore the "change this to _" shit.
		Honestly, no one has time for that kind of obfuscatory nonsense.  
* removed player change code from buttonClickStuff(), it wasn't used at all
* got rid of buttonTopRowFlag and buttonTopRowFlag and entire swith/case in checkForSOS(), they weren't used/needed
* converted unmutated var's to let's, the compiler is much happier, and really, that's what's important
* removed the applicationWillTerminate function that deleted app settings on quit, we don't need it anymore (left it there, just commented out, it's kind of useful at times)
* Cleaned up comments, ensured all functions have what calls them and what they return listed in the comments


##20231114
added moveRecord{} struct as the primary entity for recording moves during a game.
