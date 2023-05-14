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
        // Quand je démarre sans calcul j'ai AC, je tape un chiffre, j'ai C
        calculate.numberHasBeenTapped("5")
        XCTAssertEqual(display, "5")
        XCTAssertEqual(acButton, "C")
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
    
    func testExpressionHaveResult_WhenTapPlus_ClearExpressionAndPutResultBeforeOperator() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("3")
        calculate.egalHasBeenTapped()

        calculate.operatorHasBeenTapped("+")

        XCTAssertEqual(display, "4 + ")
    }

    func testLastElmentIsAnOperator_WhenTapLess_GiveAlerteOperatorAndExpressionNotChange() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")

        calculate.operatorHasBeenTapped("-")

        XCTAssertEqual(display, "1 + ")
        XCTAssertEqual(alerteDesciption, "Entrez une expression correcte !")
    }
    
    func testWhenTapOperatorUnknown_ExpressionNotChangeAndShowAlerte() {
        calculate.numberHasBeenTapped("1")
        
        calculate.operatorHasBeenTapped("/")
        
        XCTAssertEqual(display, "1")
        XCTAssertEqual(alerteDesciption, "opérateur non reconnu par la calculatrice")
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

    func testExpressionIsOneDivideByThree_WhenTapEgal_ExpressionIsOnePointThree() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("÷")
        calculate.numberHasBeenTapped("3")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "1 ÷ 3 = 0.33333333")
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

    func testExpressionFinishWithOperator_WhenTapPoint_AddZeroBeforePoint() {
        calculate.numberHasBeenTapped("1")
        calculate.operatorHasBeenTapped("+")
        calculate.pointHasBeenTapped()

        XCTAssertEqual(display, "1 + 0.")
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
    
    // test maximum number length
    func testExpressionHaveTenNumbers_WhenTapNumber_ExpressionNotChange() {
        calculate.numberHasBeenTapped("5555555555")


        calculate.numberHasBeenTapped("5")

        XCTAssertEqual(display, "5555555555")
        XCTAssertEqual(alerteDesciption, "vous ne pouvez pas dépasser 10 chiffres")
        
    }
    
    // test convert in String
    func testExpressionIsFiveLessFive_WhenTapEgal_ResultIsZero() {
        calculate.numberHasBeenTapped("5")
        calculate.operatorHasBeenTapped("-")
        calculate.numberHasBeenTapped("5")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "5 - 5 = 0")
    }
    
    func testResultHaveElevenNumber_WhenTapEgal_ResultIsScientificMode() {
        calculate.numberHasBeenTapped("555555555")
        calculate.operatorHasBeenTapped("×")
        calculate.numberHasBeenTapped("555555")

        calculate.egalHasBeenTapped()

        XCTAssertEqual(display, "555555555 × 555555 = 3.09e+14")
    }
    
    func testExpressionHaveResultSupTen_WhenTapEgal_ExpressionIsInScientificMode() {
        calculate.numberHasBeenTapped("222222222")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("8888888888")

        calculate.egalHasBeenTapped()
        
        XCTAssertEqual(display, "222222222 + 8888888888 = 9.11e+09")
    }
    
    func testExpressionHaveResultUnderTen_WhenTapEgal_ExpressionHave2Digit() {
        calculate.numberHasBeenTapped("22222222")
        calculate.operatorHasBeenTapped("+")
        calculate.numberHasBeenTapped("8")

        calculate.egalHasBeenTapped()
        
        XCTAssertEqual(display, "22222222 + 8 = 22222230")
    }

    // test expression is to long
    func testExpressionHaveTwentyCharacter_WhenOpperatorHasBeenTapped_ExpressionNotChangeAndShowAlerte() {
        calculate.numberHasBeenTapped("5555555555")
        calculate.operatorHasBeenTapped("×")
        calculate.numberHasBeenTapped("55555555")
        
        calculate.operatorHasBeenTapped("×")
        
        XCTAssertEqual(display, "5555555555 × 55555555")
        XCTAssertEqual(alerteDesciption, "Votre calcul est trop long !")
    }
    
    func testExpressionHaveTwentyFourCharacter_WhenNumberHasBeenTapped_ExpressionNotChangeAndShowAlerte() {
        calculate.numberHasBeenTapped("5555555555")
        calculate.operatorHasBeenTapped("×")
        calculate.numberHasBeenTapped("555555")
        calculate.operatorHasBeenTapped("×")
        calculate.numberHasBeenTapped("55")
        
        calculate.numberHasBeenTapped("5")
        
        XCTAssertEqual(display, "5555555555 × 555555 × 55")
        XCTAssertEqual(alerteDesciption, "Votre calcul est trop long !")
    }
    
    func testExpressionIsLong_WhenEgalHasBeenTapped_ExpressionNotChangeAndShowAlerte() {
        calculate.numberHasBeenTapped("1.80e+298")
        calculate.operatorHasBeenTapped("×")
        calculate.numberHasBeenTapped("9")
       
        calculate.egalHasBeenTapped()
        
        XCTAssertEqual(display, "1.80e+298 × 9")
        XCTAssertEqual(alerteDesciption, "Resultat trop grand!")
    }
    
    func testExpressionIsLong_WhenEgalHasBeenTapped_ExpressionIsScientific() {
        calculate.numberHasBeenTapped("9999999999")
        calculate.operatorHasBeenTapped("×")
        calculate.numberHasBeenTapped("9999999999")
       
        calculate.egalHasBeenTapped()
        
        XCTAssertEqual(display, "9999999999 × 9999999999 = 1.00e+20")
    }
    
    // test ac BUTTON
    func testExpressionIsFive_WhenClearExpression_ExpressionIsZeroAndButtonIsAc() {
    calculate.numberHasBeenTapped("5")
    
    calculate.clearExpression("C")
    
    XCTAssertEqual(display, "0")
    XCTAssertEqual(acButton, "AC")
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
