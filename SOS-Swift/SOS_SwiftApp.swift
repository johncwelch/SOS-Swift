//
//  SOS_SwiftApp.swift
//  SOS-Swift
//
//  Created by John Welch on 8/29/23.
//

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
func getInitVars(theType: Int, theSize: Int, theBlueType: Int, theRedType: Int, theCurrentPlayer: String) {
	print(theType)
	print(theSize)
	print(theBlueType)
	print(theRedType)
	print(theCurrentPlayer)
}

func boardSizeSelect(theSelection: Int) {
	print("The selection is: \(theSelection)")
}

@main
struct SOS_SwiftApp: App {
	//this line implements the application quitting on last window closed class
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	var body: some Scene {
        WindowGroup {
            ContentView()
		   //set min/max size
			   .frame(minWidth: 800, minHeight: 800)
        }
    }
}
