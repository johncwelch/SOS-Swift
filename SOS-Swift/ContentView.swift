//
//  ContentView.swift
//  SOS-Swift
//
//  Created by John Welch on 8/29/23.
//

import SwiftUI

struct ContentView: View {
	@State var gameType: Int = 1
	@State var boardSize: Int = 3
	@State var bluePlayerType: Int = 1
	@State var redPlayerType: Int = 1
	@State var currentPlayer: String = "Blue"

	var body: some View {
	    VStack(alignment: .leading) {
		    HStack(alignment: .top) {
			    VStack(alignment: .leading) {
				    Text("Game Type:")
					    .font(.body)
					    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
					    //.padding(.leading, 20.0)
					    .frame(width: 100.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("Game Type label")
					    .accessibilityIdentifier("gameTypeLabel")
				    //this actually draws the buttons
				    gameTypeRadioButtonView(index: 1, selectedIndex: $gameType)
				    gameTypeRadioButtonView(index: 2, selectedIndex: $gameType)
					//
			    }
			    .padding(.leading, 20.0)

			    VStack(alignment: .leading) {
				    Text("Board Size:")
					    .font(.body)
					    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
					    .padding(.leading, 20.0)
					    .frame(width: 200.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("Board Size Label")
					    .accessibilityIdentifier("boardSizeLabel")

				    //the nice thing here, the selection variable is all you need to look at
				    Picker("", selection: $boardSize) {
					    Text("3").tag(3)
					    Text("4").tag(4)
					    Text("5").tag(5)
					    Text("6").tag(6)
					    Text("7").tag(7)
					    Text("8").tag(8)
					    Text("9").tag(9)
					    Text("10").tag(10)
				    }
				    .frame(width: 84.0,alignment: .center)
				    .padding(.leading,10.0)
				    //makes it look like a dropdown list
				    .pickerStyle(MenuPickerStyle())
				    //this is how you initiate actions based on a change event
				    .onChange(of: boardSize) {
					    boardSizeSelect(theSelection: boardSize)
				    }

				    HStack(alignment: .top){
					    Text("Current Player:")
						    .font(.body)
						    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
						    .padding(.leading, 20.0)
						    .frame(width: 120.0, height: 22.0,alignment: .leading)
						    .textSelection(.enabled)
						    .accessibilityLabel("Current Player Label")
						    .accessibilityIdentifier("currentPlayerLabel")

					    Text(currentPlayer)
						    .font(.body)
						    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
						    .frame(width: 40.0,height: 22.0,alignment: .center)
						    .textSelection(.enabled)
						    .accessibilityLabel("Current Player")
						    .accessibilityIdentifier("currentPlayer")
				    }


			    }

			    VStack(alignment: .leading) {
				    Text("Blue Player:")
					    .font(.body)
					    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
					    //.padding(.leading, 20.0)
					    .frame(width: 100.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("Blue Player Label")
					    .accessibilityIdentifier("bluePlayerLabel")
				    bluePlayerTypeRadioButton(index: 1, selectedIndex: $bluePlayerType)
				    bluePlayerTypeRadioButton(index: 2, selectedIndex: $bluePlayerType)
			    }
			    .padding(.leading, 20.0)

			    VStack(alignment: .leading) {
				    Text("Red Player:")
					    .font(.body)
					    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
					    //.padding(.leading, 20.0)
					    .frame(width: 100.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("Red Player Label")
					    .accessibilityIdentifier("redPlayerLabel")
				    redPlayerTypeRadioButton(index: 1, selectedIndex: $redPlayerType)
				    redPlayerTypeRadioButton(index: 2, selectedIndex: $redPlayerType)
			    }
			    .padding(.leading, 20.0)

			    VStack(alignment: .leading) {
				    Button("New Game"){
					    //since myTuple technically never changes and is redefined with
					    //every button click, we'll define it as a constant via "let" instead
					    //of the mutable "var"
					    let myTuple = (theType: gameType, theSize: boardSize, theBlueType: bluePlayerType, theRedType: redPlayerType, theCurrentPlayer: currentPlayer)
					    //function is actually in sos_Swiftapp.swift
					    getInitVars(theType: myTuple.theType, theSize: myTuple.theSize, theBlueType: myTuple.theBlueType, theRedType: myTuple.theRedType, theCurrentPlayer: myTuple.theCurrentPlayer)
				    }
				    .padding(.top,5.0)

				    Button("Record Game") {

				    }
				    //hiding for now, this is an extra goal anyway
				    .hidden()


				    Button("Replay Game") {
					    //only enable this if "record" is enabled.
				    }
				    //hiding for now, this is an extra goal anyway
				    .hidden()

			    }
			    .padding(.leading, 20.0)

		    }
		    .background(Color.gray)
		    //this shoves everything to the top of the window
		    Spacer()
	    }
	    //Text("selected option: \(redPlayerType)")
    }
}

//setup for game type radio buttons, swift is fucking weird this way
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


#Preview {
    ContentView()
}
