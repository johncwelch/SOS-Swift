//
//  AppStructs.swift
//  SOS-Swift
//
//  Created by John Welch on 10/12/23.
//

import SwiftUI
import Foundation
import Observation

//View Structs

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


//setup for game type radio buttons, swiftui is weird this way
struct gameTypeRadioButtonView: View {
	var index: Int
	@Binding var selectedIndex: Int

	var body: some View {
		//in swiftUI ALL BUTTONS ARE BUTTONS
		Button(action: {
			selectedIndex = index
		}) {
			//this sets up the view for the basic button. You define it here once, then implement it in
			//the main view
			HStack {
				//literally build the buttons this way because fuck if I know, this UI by code shit is
				//stupid
				Image(systemName:  self.selectedIndex == self.index ? "largecircle.fill.circle" : "circle")
					.foregroundColor(.black)
				//set the label for each one
				if index == 1 {
					Text("Simple")
				} else if index == 2 {
					Text("General")
				}

			}
			//.padding(.leading, 20.0)
		}
	}
}

//setup for the blue player radio buttons
struct bluePlayerTypeRadioButton: View {
	var index: Int
	@Binding var selectedIndex: Int

	var body: some View {
		Button(action: {
			selectedIndex = index
		}) {
			HStack {
				Image(systemName:  self.selectedIndex == self.index ? "largecircle.fill.circle" : "circle")
					.foregroundColor(.black)
				if index == 1 {
					Text("Human")
				} else if index == 2 {
					Text("Computer")
				}
			}
		}
	}
}

//setup for the red player radio buttons
struct redPlayerTypeRadioButton: View {
	var index: Int
	@Binding var selectedIndex: Int

	var body: some View {
		Button(action: {
			selectedIndex = index
		}) {
			HStack {
				Image(systemName:  self.selectedIndex == self.index ? "largecircle.fill.circle" : "circle")
					.foregroundColor(.black)
				if index == 1 {
					Text("Human")
				} else if index == 2 {
					Text("Computer")
				}
			}
		}
	}
}

//struct we can use to record the items needed to record a move
//the index of the button, the title of the button, the player who
//made the move, and the background color of the button.
//the player may not be strictly necessary
struct moveRecord {
	var moveIndex: Int
	var moveTitle: String
	var movePlayer: String
	var moveColor: Color
}
