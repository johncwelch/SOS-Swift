//
//  SOS_SwiftUITests.swift
//  SOS-SwiftUITests
//
//  Created by John Welch on 8/29/23.
//  basic UI unit tests here

import XCTest

final class SOS_SwiftUITests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.

		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false

		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	//app launch test, does it actually start
	func testExample() throws {
		// UI tests must launch the application that they test.
		let app = XCUIApplication()
		app.launch()

		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	//tests application launch times
	//this one just repeatedly launches the app for timing purposes, so I don't really use it
	//outside of automation
	func testLaunchPerformance() throws {
		if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
			// This measures how long it takes to launch your application.
			measure(metrics: [XCTApplicationLaunchMetric()]) {
				XCUIApplication().launch()
			}
		}
	}

	//my tests

	//test new game button
	//this tests that once the application has launched, the "new game"button responds to a click
	func testNewGameButton() {
		let SOSApp = XCUIApplication()
		//launch application for button click test
		SOSApp.launch()
		let myCommitButton = SOSApp.buttons["commitButton"]
		let myGameTypeSimpleButton = SOSApp.buttons["gameTypeSimple"]
		let myGameTypeGeneralButton = SOSApp.buttons["gameTypeGeneral"]
		let myBluePlayerTypeHuman = SOSApp.buttons["Blue Player Human"]
		let myBluePlayerTypeComputer = SOSApp.buttons["Blue Player Computer"]
		let myRedPlayerTypeHuman = SOSApp.buttons["Red Player Human"]
		let myRedPlayerTypeComputer = SOSApp.buttons["Red Player Computer"]
		let myCurrentPlayer = SOSApp.staticTexts["Current Player"]
		//click the button
		SOSApp.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["New Game"].click()
		//states that should be a specific way after clicking new game:
		XCTAssertFalse(myCommitButton.isEnabled)
		XCTAssertTrue(myGameTypeSimpleButton.isEnabled)
		XCTAssertTrue(myGameTypeGeneralButton.isEnabled)
		XCTAssertTrue(myBluePlayerTypeHuman.isEnabled)
		XCTAssertTrue(myBluePlayerTypeComputer.isEnabled)
		XCTAssertTrue(myRedPlayerTypeHuman.isEnabled)
		XCTAssertTrue(myRedPlayerTypeComputer.isEnabled)
	}

	func testCommitButton() {
		let SOSApp = XCUIApplication()
		SOSApp.launch()
		let myCommitButton = SOSApp.buttons["commitButton"]
		let myGameTypeSimpleButton = SOSApp.buttons["gameTypeSimple"]
		let myGameTypeGeneralButton = SOSApp.buttons["gameTypeGeneral"]
		let myBluePlayerTypeHuman = SOSApp.buttons["Blue Player Human"]
		let myBluePlayerTypeComputer = SOSApp.buttons["Blue Player Computer"]
		let myRedPlayerTypeHuman = SOSApp.buttons["Red Player Human"]
		let myRedPlayerTypeComputer = SOSApp.buttons["Red Player Computer"]
		//should be disabled before a button has an s or o
		XCTAssertFalse(myCommitButton.isEnabled)
		//should be enabled before commit is clicked
		XCTAssertTrue(myGameTypeSimpleButton.isEnabled)
		XCTAssertTrue(myGameTypeGeneralButton.isEnabled)
		XCTAssertTrue(myBluePlayerTypeHuman.isEnabled)
		XCTAssertTrue(myBluePlayerTypeComputer.isEnabled)
		XCTAssertTrue(myRedPlayerTypeHuman.isEnabled)
		XCTAssertTrue(myRedPlayerTypeComputer.isEnabled)
		//XCTAssertTrue()
		let swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window = SOSApp.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"]
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.groups.containing(.staticText, identifier:"gameTypeLabel")/*[[".groups.containing(.button, identifier:\"Computer\")",".groups.containing(.button, identifier:\"gameTypeGeneral\")",".groups.containing(.button, identifier:\"Commit Move\")",".groups.containing(.button, identifier:\"Human\")",".groups.containing(.staticText, identifier:\"currentPlayer\")",".groups.containing(.staticText, identifier:\"currentPlayerLabel\")",".groups.containing(.button, identifier:\"gameTypeSimple\")",".groups.containing(.button, identifier:\"New Game\")",".groups.containing(.staticText, identifier:\"redPlayerLabel\")",".groups.containing(.staticText, identifier:\"bluePlayerLabel\")",".groups.containing(.popUpButton, identifier:\"Board Size Dropdown\")",".groups.containing(.popUpButton, identifier:\"boardSizeDropdown\")",".groups.containing(.staticText, identifier:\"Board Size\")",".groups.containing(.staticText, identifier:\"gameTypeLabel\")"],[[[-1,13],[-1,12],[-1,11],[-1,10],[-1,9],[-1,8],[-1,7],[-1,6],[-1,5],[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .button).element(boundBy: 8).click()
		//button was clicked from blank, commit button is enabled
		XCTAssertTrue(myCommitButton.isEnabled)
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window.buttons["commitButton"].click()
		//after commit button click, game type and player type radio buttons should be disabled
		XCTAssertFalse(myGameTypeSimpleButton.isEnabled)
		XCTAssertFalse(myGameTypeGeneralButton.isEnabled)
		XCTAssertFalse(myBluePlayerTypeHuman.isEnabled)
		XCTAssertFalse(myBluePlayerTypeComputer.isEnabled)
		XCTAssertFalse(myRedPlayerTypeHuman.isEnabled)
		XCTAssertFalse(myRedPlayerTypeComputer.isEnabled)
	}

	//test simple game selection
	func testSimpleGame() {
		//launch the app
		let SOSApp = XCUIApplication()
		SOSApp.launch()
		//click the "simple" radio button
		SOSApp.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["gameTypeSimple"].click()

		//neither scores should exist for a simple game
		let myBluePlayerScoreLabel = SOSApp.staticTexts["bluePlayerScoreLabel"]
		let myBluePlayerScore = SOSApp.staticTexts["bluePlayerScore"]
		//this should be false when simple game seleected exists
		XCTAssertFalse(myBluePlayerScoreLabel.exists)
		XCTAssertFalse(myBluePlayerScore.exists)

		//verify the red player score and label
		let myRedPlayerScoreLabel = SOSApp.staticTexts["redPlayerScoreLabel"]
		let myRedPlayerScore = SOSApp.staticTexts["redPlayerScore"]
		XCTAssertFalse(myRedPlayerScoreLabel.exists)
		XCTAssertFalse(myRedPlayerScore.exists)
	}
	//test general game selection
	func testGeneralGame() {
		let SOSApp = XCUIApplication()
		SOSApp.launch()
		//Click the "general" radio button
		SOSApp.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["gameTypeGeneral"].click()

		//verify the blue player score and label
		let myBluePlayerScoreLabel = SOSApp.staticTexts["bluePlayerScoreLabel"]
		let myBluePlayerScore = SOSApp.staticTexts["bluePlayerScore"]
		//this should be true when general game seleected exists
		XCTAssertTrue(myBluePlayerScoreLabel.exists)
		XCTAssertTrue(myBluePlayerScore.exists)

		//verify the red player score and label
		let myRedPlayerScoreLabel = SOSApp.staticTexts["redPlayerScoreLabel"]
		let myRedPlayerScore = SOSApp.staticTexts["redPlayerScore"]
		XCTAssertTrue(myRedPlayerScoreLabel.exists)
		XCTAssertTrue(myRedPlayerScore.exists)

	}
	//this tests the appearance of the start game button when you click on blue computer as computer and that it is enabled
	func testStartGameButtonEnableBluePlayerComputer() {
		let SOSApp = XCUIApplication()
		SOSApp.launch()
		SOSApp/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["Blue Player Computer"]/*[[".windows[\"SOS-Swift\"]",".groups.buttons[\"Blue Player Computer\"]",".buttons[\"Blue Player Computer\"]",".windows[\"SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.click()
		let startButton = SOSApp.buttons["startButton"]
		XCTAssertTrue(startButton.exists)
		XCTAssertTrue(startButton.isEnabled)
	}
	//test that start button does NOT appear if only red player is computer
	func testStartGameButtonEnableRedPlayerComputer() {
		let SOSApp = XCUIApplication()
		SOSApp.launch()
		SOSApp.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["Red Player Computer"].click()
		let startButton = SOSApp.buttons["startButton"]
		XCTAssertFalse(startButton.exists)
	}
	//test that start button appears when both players are computer
	func testStartGameButtonEnableBothPlayersComputer() {
		let SOSApp = XCUIApplication()
		SOSApp.launch()
		SOSApp.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["Red Player Computer"].click()
		SOSApp/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["Blue Player Computer"]/*[[".windows[\"SOS-Swift\"]",".groups.buttons[\"Blue Player Computer\"]",".buttons[\"Blue Player Computer\"]",".windows[\"SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.click()
		let startButton = SOSApp.buttons["startButton"]
		XCTAssertTrue(startButton.exists)
		XCTAssertTrue(startButton.isEnabled)
	}

	//test picker
	//verifies that you can change the value in the board size picker

	func testBoardSizeChange() {
		XCUIApplication().launch()
		let swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window = XCUIApplication()/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"]/*[[".windows[\"SOS-Swift\"]",".windows[\"SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		let boardsizedropdownPopUpButton = swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.popUpButtons["boardSizeDropdown"]/*[[".groups",".popUpButtons[\"Board Size Dropdown\"]",".popUpButtons[\"boardSizeDropdown\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
		boardsizedropdownPopUpButton.click()
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.menuItems["4"]/*[[".groups",".popUpButtons[\"Board Size Dropdown\"]",".menus.menuItems[\"4\"]",".menuItems[\"4\"]",".popUpButtons[\"boardSizeDropdown\"]"],[[[-1,3],[-1,2],[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
		boardsizedropdownPopUpButton.click()
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.menuItems["6"]/*[[".groups",".popUpButtons[\"Board Size Dropdown\"]",".menus.menuItems[\"6\"]",".menuItems[\"6\"]",".popUpButtons[\"boardSizeDropdown\"]"],[[[-1,3],[-1,2],[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()

		let boardsizedropdownPopUpButton2 = swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.popUpButtons["boardSizeDropdown"]/*[[".groups.popUpButtons[\"boardSizeDropdown\"]",".popUpButtons[\"boardSizeDropdown\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		boardsizedropdownPopUpButton2.click()
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.menuItems["10"]/*[[".groups",".popUpButtons[\"boardSizeDropdown\"]",".menus.menuItems[\"10\"]",".menuItems[\"10\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
		boardsizedropdownPopUpButton2.click()
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.menuItems["3"]/*[[".groups",".popUpButtons[\"boardSizeDropdown\"]",".menus.menuItems[\"3\"]",".menuItems[\"3\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
	}

}





