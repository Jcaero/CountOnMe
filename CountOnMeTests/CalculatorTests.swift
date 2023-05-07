//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by pierrick viret on 30/04/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest

@testable import CountOnMe
class CalculatorTests: XCTestCase {
    private var calculate: Calculator!

    // data output of Calculator
    private var display: String?
    private var alerteTitle: String?
    private var alerteDesciption: String?
    private var acButton: String?

    override func setUp() {
        super.setUp()
        calculate = Calculator(delegate: self)
    }

    override func tearDownWithError() throws {
        calculate.clearExpression("AC")
    }

    // test for AddNumberTap
    func testExpressionIsOne_WhenTapFive_ResultIsFifteen() {
        calculate.numberHasBeenTapped("1")

        calculate.numberHasBeenTapped("5")

        XCTAssertEqual(display, "15")
    }

    func testExpressionIsZero_WhenTapFive_ResultIsFive() {
        calculate.clearExpression("AC")

        calculate.numberHasBeenTapped("5")

        XCTAssertEqual(display, "5")
    }

    func testExpressionFinishWithZero_WhenTapFive_ZeroIsRemplaceByFive() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("0")

        calculate.numberHasBeenTapped("5")

        XCTAssertEqual(display, "1 + 5")
    }

    func testExpressionFinishWithNumber_WhenTapZero_ZeroIsAddAfter() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("5")

        calculate.numberHasBeenTapped("0")

        XCTAssertEqual(display, "1 + 50")
    }

    func testExpressionHaveResult_WhenTapFive_CleanAndRemplaceByFive() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("3")
        calculate.egalHasBeenTapped()

        calculate.numberHasBeenTapped("5")

        XCTAssertEqual(display, "5")
    }

    // Test for operatorTap
    func testExpressionTwo_WhenTapPlus_ExpressionTwoPlus() {
        calculate.numberHasBeenTapped("2")

        calculate.operatorHasBeenTapped("+")

        XCTAssertEqual(display, "2 + ")
    }

    func testExpressionHaveResult_WhenTapPlus_GiveAlerteFinAndExpressionNotChange() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("3")
        calculate.egalHasBeenTapped()

        calculate.operatorHasBeenTapped("+")

        XCTAssertEqual(display, "1 + 3 = 4")
        XCTAssertEqual(alerteDesciption, "Démarrez un nouveau calcul !")
    }

    func testLastElmentIsAnOperator_WhenTapLess_GiveAlerteOperatorAndExpressionNotChange() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")

        calculate.operatorHasBeenTapped("-")

        XCTAssertEqual(display, "1 + ")
        XCTAssertEqual(alerteDesciption, "Entrez une expression correcte !")
    }

    // Test for égal
    func testExpressionTwo_WhenTapEgal_GiveAlerteSyntaxeAndExpressionNotChange() {
        calculate.numberHasBeenTapped("2")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "2")
        XCTAssertEqual(alerteDesciption, "Entrez une expression correcte !")
    }

    func testExpressionHaveMoreThan3ElementsAndFinishWithOperator_WhenTapEgal_GiveAlerteSyntaxeAndExpressionNotChange() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("3")
        calculate.operatorHasBeenTapped("+")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "1 + 3 + ")
        XCTAssertEqual(alerteDesciption, "Entrez une expression correcte !")
    }

    func testCalculeIsFinish_WhenTapEgal_GiveAlerteFinAndExpressionNotChange() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("3")
        calculate.egalHasBeenTapped()

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "1 + 3 = 4")
        XCTAssertEqual(alerteDesciption, "Démarrez un nouveau calcul !")
    }

    // test calcul value
    func testExpressionIsTwoPlusTen_WhenTapEgal_ExpressionTwelve() {
        calculate.numberHasBeenTapped("2")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("1")
        calculate.numberHasBeenTapped("0")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "2 + 10 = 12")
    }

    func testExpressionIsTwoLessTen_WhenTapEgal_ExpressionLessEight() {
        calculate.numberHasBeenTapped("2")
        calculate.operatorHasBeenTapped("-")
        calculate.numberHasBeenTapped("1")
        calculate.numberHasBeenTapped("0")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "2 - 10 = -8")
    }

    // test for *
    func testExpressionIsTwoMutiplieTen_WhenTapEgal_ExpressionTwenty() {
        calculate.numberHasBeenTapped("2")
        calculate.operatorHasBeenTapped("×")
        calculate.numberHasBeenTapped("1")
        calculate.numberHasBeenTapped("0")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "2 × 10 = 20")
    }

    func testExpressionIsTwoPlusFiveMultiplieFive_WhenTapEgal_ExpressionTwentySeven() {
        calculate.numberHasBeenTapped("2")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("×")
        calculate.numberHasBeenTapped("5")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "2 + 5 × 5 = 27")
    }

    // test for Divide
    func testExpressionIsTenDivideTwo_WhenTapEgal_ExpressionFive() {
        calculate.numberHasBeenTapped("1")
        calculate.numberHasBeenTapped("0")
        calculate.operatorHasBeenTapped("÷")
        calculate.numberHasBeenTapped("2")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "10 ÷ 2 = 5")
    }

    func testExpressionIsOneDivide_WhenTapZero_ExpressionNotChangeAndShowAlerte() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("÷")

        calculate.numberHasBeenTapped("0")

        XCTAssertEqual(display, "1 ÷ ")
        XCTAssertEqual(alerteDesciption, "Vous ne pouvez pas diviser par 0")
    }

    func testExpressionIsFiveDivideTwo_WhenTapEgal_ExpressionResultIsTwoPointFive() {
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("÷")
        calculate.numberHasBeenTapped("2")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "5 ÷ 2 = 2.5")
    }

    func testExpressionIsFourDivideByThree_WhenTapEgal_ExpressionIsOnePointThree() {
        calculate.numberHasBeenTapped("4")
        calculate.operatorHasBeenTapped("÷")
        calculate.numberHasBeenTapped("3")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "4 ÷ 3 = 1.33")
    }

    // test for point
    func testExpressionIsElevenPointTwoPlusOnePointFive_WhenTapEgal_ExpressionIsTwelvePointSeven() {
        calculate.numberHasBeenTapped("1")
        calculate.numberHasBeenTapped("1")
        calculate.pointHasBeenTapped()
        calculate.numberHasBeenTapped("2")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("1")
        calculate.pointHasBeenTapped()
        calculate.numberHasBeenTapped("5")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "11.2 + 1.5 = 12.7")
    }

    func testExpressionIsElevenPointTwo_WhenTapPoint_ExpressionNotChangeAndShowAlerte() {
        calculate.numberHasBeenTapped("1")
        calculate.numberHasBeenTapped("1")
        calculate.pointHasBeenTapped()
        calculate.numberHasBeenTapped("2")

        calculate.pointHasBeenTapped()

        XCTAssertEqual(display, "11.2")
        XCTAssertEqual(alerteDesciption, "Vous ne pouvez mettre qu'une virgule")
    }

    func testExpressionFinishWithOperator_WhenTapPoint_ExpressionNotChangeAndShowAlerte() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.pointHasBeenTapped()

        XCTAssertEqual(display, "1 + ")
        XCTAssertEqual(alerteDesciption, "Entrez une expression correcte !")
    }

    // test for reset AC or C
    func testExpressionIsfivePlusFive_WhenResetCTapped_ExpressionIsFivePlus() {
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("5")

        calculate.clearExpression("C")

        XCTAssertEqual(display, "5 + ")
    }

    func testExpressionIsfivePlus_WhenResetCTapped_ExpressionIsFive() {
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("+")

        calculate.clearExpression("C")

        XCTAssertEqual(display, "5")
    }

    func testExpressionIsfivePlus_WhenResetACTapped_ExpressionIsFive() {
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("+")

        calculate.clearExpression("AC")

        XCTAssertEqual(display, "0")
    }

    func testExpressionIsFiveZero_WhenChangeSigneTap_ExpressionIsLessFive() {
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("0")

        calculate.changeSignTapped()

        XCTAssertEqual(display, "-50")
    }

    func testExpressionIsLessFiveZero_WhenChangeSigneTap_ExpressionIsLessFive() {
        calculate.numberHasBeenTapped("-50")

        calculate.changeSignTapped()

        XCTAssertEqual(display, "50")
    }

    func testExpressionIsFivePlus_WhenChangeSigneTap_ExpressionNotChange() {
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("+")

        calculate.changeSignTapped()

        XCTAssertEqual(display, "5 + ")
    }

    func testExpressionIsFivePlusZero_WhenChangeSigneTap_ExpressionNotChange() {
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("0")

        calculate.changeSignTapped()

        XCTAssertEqual(display, "5 + 0")
    }

    func testExpressionIsFivePlusTwo_WhenChangeSigneTap_ExpressionIsFivePlusLessTwo() {
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("2")

        calculate.changeSignTapped()

        XCTAssertEqual(display, "5 + -2")
    }
}

extension CalculatorTests: CalculatorDelegate {

    func updateClearButton(_ button: String) {
        acButton = button
    }

    func showAlert(title: String, description: String) {
        alerteTitle = title
        alerteDesciption = description
    }

    func updateDisplay(_ expression: String) {
        display = expression
    }
}
