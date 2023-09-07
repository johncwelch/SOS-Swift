//
//  SOS_SwiftApp.swift
//  SOS-Swift
//
//  Created by John Welch on 8/29/23.
//  this is the class file where all our non-UI code lives

import SwiftUI
import Cocoa

//custom class to allow for quit on closing window
//contrary to what you see in various places, you don't need to explicitly import a framework for this to work
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
			return true
	}
}

//basic functions
//collect the initial setup for new game and print them, mostly to show things are actually set right
//like unit tests without the overhead
func getInitVars(theType: Int, theSize: Int, theBlueType: Int, theRedType: Int, theCurrentPlayer: String) {
	var gameType: String = ""
	var bluePlayerType: String = ""
	var redPlayerType: String = ""

	if theType == 1 {
		gameType = "Simple"
	} else if theType == 2 {
		gameType = "General"
	}

	if theBlueType == 1 {
		bluePlayerType = "Human"
	} else if theBlueType == 2 {
		bluePlayerType = "Computer"
	}

	if theRedType == 1 {
		redPlayerType = "Human"
	} else if theRedType == 2 {
		redPlayerType = "Computer"
	}
	print("The Game type is: \(gameType)")
	print("The Game Board size is: \(theSize)x\(theSize)")
	print("The blue player type is: \(bluePlayerType)")
	print("The red player type is: \(redPlayerType)")
	print("The current player is: \(theCurrentPlayer)")
}

//basic functional test for the board size picker
func boardSizeSelect(theSelection: Int) {
	print("The board size selection is: \(theSelection)x\(theSelection)")
}

//viewmodifiers to simplify text formatting code
//think of it as a stylesheet for text labels
//this sets the font, the font weight, frame properties, and text selection
struct basicTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		return content
			.font(.body)
			.fontWeight(.bold)
			.frame(width: 120.0,height: 22.0,alignment: .leading)
			.textSelection(.enabled)
	}
}

//sets the same as basicTextModifer, but no frame properties
struct basicTextModifierNoFrame: ViewModifier {
	func body(content: Content) -> some View {
		return content
			.font(.body)
			.fontWeight(.bold)
			.textSelection(.enabled)
	}
}

@main
struct SOS_SwiftApp: App {
	//this line implements the application quitting on last window closed class
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	var body: some Scene {
        WindowGroup {
            ContentView()
		   //set minimum size of the window
			   .frame(minWidth: 800, minHeight: 800)
        }
    }
}
