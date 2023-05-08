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
    func updateDisplay(_ expression: String)
    func updateClearButton(_ button: String)
}

class Calculator {
    // Configuration
    let numberMaxLenght = 10
    let expressionMaxLenght = 24

    // Delegate
    private let calculatorDelegate: CalculatorDelegate
    init(delegate: CalculatorDelegate) {
        self.calculatorDelegate = delegate
        expression = "0"
    }

    // Expression
    private var expression: String
    private var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }

    // delaration of available opérator
    private let operatorAvailable: Set = ["+", "-", "×", "÷"]

    // return true if expression have alreay result
    private var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }

    // return true if last element is 0
    private var lastElementIsZero: Bool {
        return elements.last == "0"
    }

    // return true if last element is divide operator
    private var lastElementIsDivideOperator: Bool {
        return elements.last == "÷"
    }

    func numberHasBeenTapped(_ selection: String) {

        // check if selection is Zero and last operator is divide
        guard !(lastElementIsDivideOperator && selection == "0") else {
            calculatorDelegate.showAlert(title: "Erreur",
                                         description: "Vous ne pouvez pas diviser par 0");
            return
        }
        
        // clear expression if already have result
        if expressionHaveResult { expression = "0" }
        
        guard elements.last!.count < numberMaxLenght else { return }

        // delete zero if it zero before number
        if lastElementIsZero {
            expression.removeLast(1)
        }

        // add number to expression and update display
        expression += selection
        calculatorDelegate.updateDisplay(expression)
        calculatorDelegate.updateClearButton("C")
    }

    // @return true if last element is not a operator
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }

    func operatorHasBeenTapped(_ selection: String) {
        // if expression have result, show alerte
        guard !elements.contains("=") else {
            calculatorDelegate.showAlert(title: "Zéro!",
                                         description: "Démarrez un nouveau calcul !");
            return
        }

        // if last elements is a operator, show alerte
        guard canAddOperator else {
            calculatorDelegate.showAlert(title: "Zéro!",
                                         description: "Entrez une expression correcte !");
            return
        }

        // Put space around operator and add in mathematical formula
        let operatorToAdd = " " + selection + " "
        expression.append(operatorToAdd)

        calculatorDelegate.updateDisplay(expression)
    }

    // check if expression have enough element to bild a calcule
    // @return true if have neough
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
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
        calculatorDelegate.updateClearButton("AC")
    }

    // clear last element or all alement depend of selection:
    // C clear last
    // AC clear all
    func clearExpression(_ selection: String) {
        // check if selection is AC
        guard selection == "C" else {expression = "0";
            calculatorDelegate.updateDisplay(expression);
            return
        }

        // check if one elements existe
        guard let lastElement = elements.last else {return}
        guard elements.count > 1 else {clearExpression("AC"); return}

        // init range for remove String
        var start: String.Index
        if operatorAvailable.contains(lastElement) {
            // remove 3 lest element
            start = expression.index(expression.endIndex, offsetBy: -3)
        } else {
            // remove number
            start = expression.index(expression.endIndex, offsetBy: -(lastElement.count))
        }

        let stop = expression.index(expression.endIndex, offsetBy: -1)

        // remove elements
        expression.removeSubrange(start...stop)
        calculatorDelegate.updateClearButton("AC")

        calculatorDelegate.updateDisplay(expression)

    }

    // calcule with elements of expression
    // put result at the end of expression
    private func calcul() {
        // Create local copy of operations
        var operationsToReduce = elements
        var result: Double
        var index: Int

        // calculate until expression have result
        while operationsToReduce.count > 1 {

            // ientifie primary operator
            if let primaryindex = operationsToReduce.firstIndex(where: {$0 == "×" || $0 == "÷" }) {
                index = primaryindex
            } else {
                index = 1
            }

            let left = Double(operationsToReduce[index-1])!
            let operand = operationsToReduce[index]
            let right = Double(operationsToReduce[index+1])!

            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "×": result = left * right
            case "÷": result = left / right
            default: fatalError("Unknown operator !")
            }

            // put answer in expression
            operationsToReduce.insert(convertInString(result), at: index-1)

            // remove number and operator used from expression
            operationsToReduce.removeSubrange(index...index+2)
        }
        expression += " = " + operationsToReduce[0]
    }

    // put point for number with decimal
    func pointHasBeenTapped() {
        guard let lastElements = elements.last else {return}

        // check if last number have already a point
        guard !lastElements.contains(".") else {
            calculatorDelegate.showAlert(title: "Virgule",
                                         description: "Vous ne pouvez mettre qu'une virgule");
            return
        }

        // last element is not a operator
        guard !operatorAvailable.contains(lastElements) else {
            calculatorDelegate.showAlert(title: "Erreur",
                                         description: "Entrez une expression correcte !");
            return
        }
        expression.append(".")
        calculatorDelegate.updateDisplay(expression)
    }

    // change sign of last number
    func changeSignTapped() {
        // expression have element
        guard let lastElement = elements.last else {return}
        // last element is not operator
        guard !operatorAvailable.contains(lastElement) else {return}
        // last element is not Zero
        guard lastElement != "0" else {return}
        // last element can be transform in Double
        guard var lastNumber = Double(lastElement) else {return}

        // change symbole
        lastNumber.negate()

        // clear last element
        if elements.count == 1 {
            expression = ""
        } else {
            clearExpression("C")
        }

        // replace with new number
        expression.append(convertInString(lastNumber))

        calculatorDelegate.updateDisplay(expression)
    }

    // convert Double in String
    private func convertInString(_ double: Double) -> String {
        var stringDouble: String
        let format: String
        
        guard double != 0 else {return "0"}

        // expression start with 0.
        guard double.description.first != "0" else { return String(format: "%.8f", double) }
        
        // expression have more than ten number before point
        guard Int(double).description.count < 10 else { return String(format: "%.2e", double)}
        
        if Int(double).description.count < 6 {
            format = "%.5f"
        } else {
            format = "%.2f"
        }
        
        stringDouble = String(format: format, double)
        // remove O after .
        while stringDouble.last == "0"{
            stringDouble.removeLast()
        }
        
        if stringDouble.last == "."{
            stringDouble.removeLast()
        }
        return stringDouble
    }
}
