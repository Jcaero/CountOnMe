//
//  CountOnMeUITests.swift
//  CountOnMeUITests
//
//  Created by pierrick viret on 14/05/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

private extension XCUIApplication {
    var fiveButton: XCUIElement {self.buttons["5"]}
    var twoButton: XCUIElement {self.buttons["2"]}
    var zeroButton: XCUIElement {self.buttons["0"]}
    var egalButton: XCUIElement {self.buttons["="]}
    var plusButton: XCUIElement {self.buttons["+"]}
    var ACButton: XCUIElement {self.buttons["AC"]}
    var changeSignButton: XCUIElement {self.buttons["+/-"]}
    var decimalButton: XCUIElement {self.buttons["."]}
    var CButton: XCUIElement {self.buttons["C"]}
}

class CountOnMeUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        app.ACButton.tap()
    }

    func testWhenTapFivePlusTwoEgal_ThenDisplayOperatinOnTheScreen() {
        app.fiveButton.tap()
        app.plusButton.tap()
        app.twoButton.tap()

        XCTAssertTrue(app.staticTexts["5 + 2"].exists)
    }

    func testGivenZeroOnTheScreen_WhenTapZero_ThenDisplayHaveOnlyOneO() {
        app.zeroButton.tap()

        app.zeroButton.tap()

        XCTAssertTrue(app.staticTexts["0"].exists)
    }

    func testResultOperationDisplay_WhenTapNumber_ClearScreenAndDisplayNumber() {
        app.fiveButton.tap()
        app.plusButton.tap()
        app.twoButton.tap()
        app.egalButton.tap()

        app.fiveButton.tap()
        XCTAssertTrue(app.staticTexts["5"].exists)
    }

    func testLestCharacterIsOperator_WhenTapOnOperateur_DisplayNotChangeAndAlerteUser() {
        app.fiveButton.tap()
        app.plusButton.tap()

        app.plusButton.tap()
        XCTAssertTrue(app.staticTexts["5 + "].exists)
        XCTAssertTrue(app.alerts["Erreur!"].exists)
    }

    func testResultDisplay_WhenTapOperator_ShowAlerteToUser() {
        app.fiveButton.tap()
        app.plusButton.tap()
        app.twoButton.tap()
        app.egalButton.tap()
        
        app.plusButton.tap()
        
        XCTAssertTrue(app.staticTexts["7 + "].exists)
    }
    
    func testNumberIsDisplay_WhenTapChangeSign_SignCHange() {
        app.fiveButton.tap()

        app.changeSignButton.tap()
        
        XCTAssertTrue(app.staticTexts["-5"].exists)
    }
    
    func testNumberWithNotDecimal_WhenTapDecimal_NumberHaveDecimal() {
        app.fiveButton.tap()

        app.decimalButton.tap()
        
        XCTAssertTrue(app.staticTexts["5."].exists)
    }
    
    func testOperatorNotAvailableTap_ShowError() {
        app.fiveButton.tap()
        
        
        XCTAssertTrue(app.staticTexts["5"].exists)
    }
    
    func testExpressionFinishWithOperator_WhenEgalTap_ShowAlert() {
        app.fiveButton.tap()
        app.plusButton.tap()

        app.egalButton.tap()
        XCTAssertTrue(app.staticTexts["5 + "].exists)
        XCTAssertTrue(app.alerts["Expression"].exists)
    }
    
    func testExpressionHaveResult_WhenEgalTap_ShowAlerte() {
        app.fiveButton.tap()
        app.plusButton.tap()
        app.fiveButton.tap()
        app.egalButton.tap()

        app.egalButton.tap()
        XCTAssertTrue(app.staticTexts["5 + 5 = 10"].exists)
        XCTAssertTrue(app.alerts["Double Egal"].exists)
    }
    
    func testExpressionHaveNumber_WhenACTap_ClearExpression() {
        app.fiveButton.tap()
        app.plusButton.tap()
        app.fiveButton.tap()

        app.ACButton.tap()
        XCTAssertTrue(app.staticTexts["0"].exists)
 
    }
    
}
