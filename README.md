#  SOS-Swift Readme

so as this is a class project, this will be a bit uncommon in terms of format.

The current iteration as of 5 sept. 2023 solves the basic requirements for the Sprint0 assignment: there's a basic UI, some basic unit tests, etc.

The next part, code-wise will be setting up the game board and allowing it to be resized via the dropdown list in the app.

User Storys and status  
	&nbsp;1.1	done  
	1.2	done  
	2.1	done  
	2.2	done  
	2.3	done  
	3.1	done  
	4.1	done  
	4.2  done  
	5.1  
	5.2  
	6.1	done  
	6.2  
	6.3  done  
	7.1  
	

20230907: Cleaned up the text and label formatting code with a couple of ViewModifier structs, basicTextModifierNoFrame and basicTextModifier. The difference is, one modfies frame properties, the other does not. Also moved the three radio button definition structs from ContentView into SOS_SwiftApp.swift, the idea being to have as little as possible code that isn't directly involved with the UI functionality in ContentView.swift

20230912: Added the grid into the app. We get resizing for free. Notes from grid comments. with the Hstack for the grid once nice thing about the CSS-like behavior of SwiftUI, it makes a lot of things easier, like the autoresizing of the grid and because the controls Hstack  is the width of the window, the Hstack inherits that behavior for free. The view (grid) will refresh if you change the state var gridSize, but, you have to include the id: \.self for it to work right, because of how swift handles this. Note, you don't use the id, this is just telling the view what's going on.

	Grid Cell Notes: We put a rectangle in each grid space. The overlay is how you add text, the border is how you set up grid lines. The order is important. if foreground color property comes after overlay text property, it covers the overlay property. I left the code treating "even" cells differently from "odd" cells in just in case I need it later. Next step is some grid unit tests.

20230917: Added in Htstack with score text fields and "Cancel Game" button (nothing hooked up yet. hidden for now because we may not actually need it) Set up if statement to use gameType state var to hide and show fields within the hstack for the score fields. If it's a simple game, there's no score shown. If a general game, there's a score. By hooking this to the state var, when you choose between simple and general, the fields automatically show and hide. To simplify things, the only way to switch states once a game is started is to click new game button.

20230919: GOT THE BUTTONS IN!!!! the hard part was getting the size to match the cell. Answer? GeometryReader! So we enclose the Rectangle() for each cell in GeometryReader{}, and then using the <var> in variable for GR, we add a button with the frame for the label text set to using the GeometryReader data:
		
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
	
20231012 GOT THE RESIZING WORKING WITH THE BUTTON TITLE CHANGES!!
	so now when you click on a button, it cycles through "", "S", and "O", and when a button is showing "S" or "O", the "Commit Move" button is enabled. I still have to implement locking out other buttons when "S" or "O" is showing so "bad" moves can't be made. Commit move also changes the current player, and sets the background color of the button to the player that made the move. 
	
	this was remarkably difficult due to how SwiftUI handles certain things and required me redoing how I create the array that's attached to the buttons completely. But, it's working, each button knows what it is and where it is, which will be critical in calculating "SOS" or not. But the next immediate thing is wiring in the code to prevent more than one button having a title and having new game do its thing. 

20231013 New Game functionality done. This clears user story 3.1 completely 

20231017 added:  if myIndex <= ((theGame.gridSize * theGame.gridSize) - 1) after let myIndex = (row * theGame.gridSize) + col, put all the direct Button() code in that if, to avoid the out of range errors happening when grid size was shrunk. 
