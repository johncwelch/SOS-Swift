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

	/*func applicationWillTerminate(_ notification: Notification) {
		//this prevents the window size from being saved. we don't want that, it gets weird
		if let bundleID = Bundle.main.bundleIdentifier {
			UserDefaults.standard.removePersistentDomain(forName: bundleID)
		}
	}*/
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
