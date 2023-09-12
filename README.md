#  SOS-Swift Readme

so as this is a class project, this will be a bit uncommon in terms of format.

The current iteration as of 5 sept. 2023 solves the basic requirements for the Sprint0 assignment: there's a basic UI, some basic unit tests, etc.

The next part, code-wise will be setting up the game board and allowing it to be resized via the dropdown list in the app.


20230907 Cleaned up the text and label formatting code with a couple of ViewModifier structs, basicTextModifierNoFrame and basicTextModifier. The difference is, one modfies frame properties, the other does not. Also moved the three radio button definition structs from ContentView into SOS_SwiftApp.swift, the idea being to have as little as possible code that isn't directly involved with the UI functionality in ContentView.swift

20230912 Added the grid into the app. We get resizing for free. Notes from grid comments. with the Hstack for the grid once nice thing about the CSS-like behavior of SwiftUI, it makes a lot of things easier, like the autoresizing of the grid and because the controls Hstack  is the width of the window, the Hstack inherits that behavior for free. The view (grid) will refresh if you change the state var gridSize, but, you have to include the id: \.self for it to work right, because of how swift handles this. Note, you don't use the id, this is just telling the view what's going on.

	Grid Cell Notes: We put a rectangle in each grid space. The overlay is how you add text, the border is how you set up grid lines. The order is important. if foreground color property comes after overlay text property, it covers the overlay property. I left the code treating "even" cells differently from "odd" cells in just in case I need it later.
