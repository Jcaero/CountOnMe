//
//  Calculator.swift
//  CountOnMe
//
//  Created by pierrick viret on 30/04/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate {
    func showAlert(title: String, description: String)
    func updateDisplay(_ formula: String)
}

class Calculator {

    // Delegate
    private let calculatorDelegate: CalculatorDelegate
    init(delegate: CalculatorDelegate) {
        self.calculatorDelegate = delegate
        expression = ""
    }

    // Expression
    private var expression: String
    private var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }

    // delaration of available opérator
    private let operatorAvailable: Set = ["+", "-"]

    // check if expression have enough element to bild a calcule
    // @return true if have neough
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    // @return true if last element is not a operator
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }

    // return true if expression have alreay result
    private var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }

    // return true if last element is 0
    private var lastElementIsZero: Bool{
        return elements.last == "0"
    }

    func numberHasBeenTapped(_ selection: String) {
        // clear expression if already have result
        if expressionHaveResult { expression = "" }

        // delete zero if it zero before number
        if lastElementIsZero {
            expression.removeLast(1)
        }

        // add number to expression and update display
        expression += selection
        calculatorDelegate.updateDisplay(expression)
    }

    func operateurHasBeenTapped(_ selection: String){
        // if expression have result, show alerte
        guard !elements.contains("=") else {
            calculatorDelegate.showAlert(title: "Zéro!",
                                         description: "Démarrez un nouveau calcul !");
            return
        }

        // if last elements is a operator, show alerte
        guard canAddOperator else {
            calculatorDelegate.showAlert(title: "Zéro!",
                                        description: "Démarrez un nouveau calcul !");
            return
        }

        // Put space around operator and add in mathematical formula
        let operatorToAdd = " " + selection + " "
        expression.append(operatorToAdd)
        
        calculatorDelegate.updateDisplay(expression)
    }

    func egalHasBeenTapped() {
        // expression have more than 3 elements and finish with number
        let valideExpression = expressionHaveEnoughElement && canAddOperator
        guard valideExpression else {
            calculatorDelegate.showAlert(title: "Zéro!",
                                         description: "Entrez une expression correcte !")
            return
        }

        // expression have not result yet
        guard !expressionHaveResult else {
            calculatorDelegate.showAlert(title: "Zéro!",
                                         description: "Démarrez un nouveau calcul !")
            return
        }

        calcul()
        calculatorDelegate.updateDisplay(expression)
    }

    //calcule with elements of expression
    // put result at the end of expression
    private func calcul() {
        // Create local copy of operations
        var operationsToReduce = elements

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!

            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        expression += " = " + operationsToReduce[0]
    }
}
