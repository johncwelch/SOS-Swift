#  SOS-Swift Readme

so as this is a class project, this will be a bit uncommon in terms of format.

The current iteration as of 5 sept. 2023 solves the basic requirements for the Sprint0 assignment: there's a basic UI, some basic unit tests, etc.

The next part, code-wise will be setting up the game board and allowing it to be resized via the dropdown list in the app.


20230907 Cleaned up the text and label formatting code with a couple of ViewModifier structs, basicTextModifierNoFrame and basicTextModifier. The difference is, one modfies frame properties, the other does not. Also moved the three radio button definition structs from ContentView into SOS_SwiftApp.swift, the idea being to have as little as possible code that isn't directly involved with the UI functionality in ContentView.swift
