//
//  SOS_SwiftUITests.swift
//  SOS-SwiftUITests
//
//  Created by John Welch on 8/29/23.
//

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
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
	
	//test new game button
	func testNewGameButton() {
		//launch application for button click test
		XCUIApplication().launch()
		//click the button
		XCUIApplication()/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"].buttons["New Game"]/*[[".windows[\"SOS-Swift\"]",".groups.buttons[\"New Game\"]",".buttons[\"New Game\"]",".windows[\"SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.click()
		
	}
	
	//test picker
	func testBoardSizePicker() {
		
		XCUIApplication().launch()
		//select new values in the board size picker

		let swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window = XCUIApplication()/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1"]/*[[".windows[\"SOS-Swift\"]",".windows[\"SwiftUI.ModifiedContent<SOS_Swift.ContentView, SwiftUI._FlexFrameLayout>-1-AppWindow-1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.popUpButtons["3"]/*[[".groups.popUpButtons[\"3\"]",".popUpButtons[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.menuItems["5"]/*[[".groups",".popUpButtons[\"3\"]",".menus.menuItems[\"5\"]",".menuItems[\"5\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.popUpButtons["5"]/*[[".groups.popUpButtons[\"5\"]",".popUpButtons[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
		swiftuiModifiedcontentSosSwiftContentviewSwiftuiFlexframelayout1Appwindow1Window/*@START_MENU_TOKEN@*/.menuItems["8"]/*[[".groups",".popUpButtons[\"5\"]",".menus.menuItems[\"8\"]",".menuItems[\"8\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
				
	}
}

