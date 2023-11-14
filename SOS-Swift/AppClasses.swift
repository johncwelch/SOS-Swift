//
//  AppClasses.swift
//  SOS-Swift
//
//  Created by John Welch on 10/12/23.
//

import SwiftUI
import Foundation
import Observation

//game classes

//this is the class we use to modify the buttons on click. This avoids having to sling actual buttons back and forth
//makes memory usage smaller, and our lives more sane
//as well, since classes are all pass by reference, using them for this instead of structs makes life SO MUCH BETTER
@Observable
class Cell: Identifiable {
	let id = UUID()
	var title: String = ""
	var buttonDisabled: Bool = false
	var index: Int = 0
	var xCoord: Int = 0
	var yCoord: Int = 0
	var backCol: Color = .gray
}

//class that is a collection of cells that are attached to the buttons in contentview
@Observable class Game {
	//this sets the size of the grid, passsed when creating the array
	var gridSize: Int {
		didSet {
			//builds the array based on the int passed in which is set in the picker
			//note that buildStructArray is an external func
			gridCellArr = buildStructArray(theGridSize: gridSize)
		}
	}

	//create the array var
	var gridCellArr: [Cell] = []

	//initialization
	init(gridSize: Int) {
		self.gridSize = gridSize
		self.gridCellArr = buildStructArray(theGridSize: gridSize)
	}
}
