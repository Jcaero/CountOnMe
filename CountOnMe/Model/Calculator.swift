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
    private let operatorAvailable: Set = ["+", "-", "*"]

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
    
    func resetExpression(){
        expression = "0"
    }

    //calcule with elements of expression
    // put result at the end of expression
    private func calcul() {
        // Create local copy of operations
        var operationsToReduce = elements
        var result: Int
        var index: Int
        
        // calculate until expression have result
        while operationsToReduce.count > 1 {
        
        // ientifie primary operator
            if let primaryindex = operationsToReduce.firstIndex(where: {$0 == "*" || $0 == "/" }) {
                index = primaryindex
            } else {
                index = 1
            }
            
            let left = Int(operationsToReduce[index-1])!
            let operand = operationsToReduce[index]
            let right = Int(operationsToReduce[index+1])!
        
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "*": result = left * right
            case "/": result = left / right
            default: fatalError("Unknown operator !")
            }
        
            operationsToReduce.insert(String(result), at: index-1)
            
            for _ in 0...2 {
            operationsToReduce.remove(at: index)
            }
        }
        expression += " = " + operationsToReduce[0]
    }
}
