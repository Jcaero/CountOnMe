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
    private let operatorAvailable: Set = ["+", "-", "*", "/"]

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
    private var lastElementIsZero: Bool {
        return elements.last == "0"
    }
    
    // return true if element have priary operator inside
    private var elementsHavePrimaryOperator: Bool {
        return elements.contains("*")
    }
    
    // return true if last element is divide operator
    private var lastElementIsDivideOperator: Bool {
        return elements.last == "/"
    }

    func numberHasBeenTapped(_ selection: String) {
        
        // check if selection is Zero and last operator is divide
        guard !(lastElementIsDivideOperator && selection == "0") else {
            calculatorDelegate.showAlert(title: "Erreur",
                                         description: "Vous ne pouvez pas diviser par 0");
            return
        }
        
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

    func operatorHasBeenTapped(_ selection: String){
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
    
    // clear last element or all alement depend of selection:
    // C clear last
    // AC clear all
    func resetExpression(_ selection: String){
        if selection == "C" {
            
            guard let lastElement = elements.last else {return}
            
            var start: String.Index
            if operatorAvailable.contains(lastElement) {
                start = expression.index(expression.endIndex, offsetBy: -3)
            } else {
                start = expression.index(expression.endIndex, offsetBy: -(lastElement.count))
            }
            
            let stop = expression.index(expression.endIndex, offsetBy: -1)
            
            expression.removeSubrange(start...stop)
            
        } else {
            expression = "0"
        }
        calculatorDelegate.updateDisplay(expression)
    }

    //calcule with elements of expression
    // put result at the end of expression
    private func calcul() {
        // Create local copy of operations
        var operationsToReduce = elements
        var result: Double
        var index: Int
        
        // calculate until expression have result
        while operationsToReduce.count > 1 {
        
        // ientifie primary operator
            if let primaryindex = operationsToReduce.firstIndex(where: {$0 == "*" || $0 == "/" }) {
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
            case "*": result = left * right
            case "/": result = left / right
            default: fatalError("Unknown operator !")
            }
            
            // round result with 3 after point
            result = round(result * 1000) / 1000.0
            
            // check if number not finish with .0 or remove it
            var stringResult = String(result)
            
            if stringResult.last == "0" {
                stringResult.removeLast()
                stringResult.removeLast()
            }
            
            // put answer in expression
            operationsToReduce.insert(stringResult, at: index-1)
            
            // remove number and operator used from expression
            operationsToReduce.removeSubrange(index...index+2)
        }
        expression += " = " + operationsToReduce[0]
    }
    
    func pointHasBeenTapped() {
        if let lastElements = elements.last {
            // check if last number have already a point
            guard !lastElements.contains(".") else
                {calculatorDelegate.showAlert(title: "Virgule",
                                              description: "Vous ne pouvez mettre qu'une virgule");
                    return
                }
            
            // last element is not a operator
            guard !operatorAvailable.contains(lastElements) else {
                calculatorDelegate.showAlert(title: "Erreur",
                                              description: "Entrez une expression correcte !");
                    return
            }
        }
        expression.append(".")
    }
}
