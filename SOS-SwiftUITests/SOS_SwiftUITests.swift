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
		//launch application for button click test
		XCUIApplication().launch()
		//click the button
		XCUIApplication()/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["New Game"]/*[[".windows[\"SOS-Swift\"]",".groups.buttons[\"New Game\"]",".buttons[\"New Game\"]",".windows[\"SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.click()

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

