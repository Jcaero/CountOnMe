//
//  Calculator.swift
//  CountOnMe
//
//  Created by pierrick viret on 30/04/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate {
    func showAlert(_ title: String, description: String)
    func updateDispay(_ expression: String)
}

class Calculator {
    
    init(){
        expression = ""
    }
    
    var calculatorDelegate: CalculatorDelegate!

    private var expression: String
    
    private var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }
    
    // delaration of available opérator
    private let operatorAvailable: Set = ["+", "-"]
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        if elements.count >= 1 {
            return !operatorAvailable.contains(elements.last!)
        }else {
            return false
        }
    }
    // check if expression have enough element to bild a calcule
    // @return true if have neough
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    // @return true if last element is not a operator
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    // return true if expression have alreay result
    var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }
    
    // return true if last element is 0
    var lastElementIsZero: Bool{
        return elements.last == "0"
    }
    
    // check if it possible and add selected number
    func numberHasBeenTapped(_ selection: String) {
        
        // clear expression if already have result
        if expressionHaveResult { expression = "" }
        
        // delete zero if it zero before number
        if lastElementIsZero {
            expression = giveExpressionWith(elements.dropLast())
        }
        
        // add number to expression and update display
        expression += selection
        calculatorDelegate.updateDispay(expression)
    }
    
    func operateurHasBeenTapped(_ selection: String){
        if canAddOperator {
            append(" + ")
        } else {
            showAlert("Zéro!", description: "Un operateur est déja mis !")
        }
    }
    
    func egalHasBeenTapped(_ selection: String){
        guard expressionIsCorrect else {
            showAlert("Zéro!", description: "Entrez une expression correcte !")
        }
        
        guard expressionHaveEnoughElement else {
            showAlert("Zéro!", description: "Démarrez un nouveau calcul !")
        }
    }
    
    func calcul(){
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
    }
        
    func giveExpressionWith(_ elements : [String]) -> String {
        guard elements != [] else { return ""}
        var result = String()

        for element in elements {
            // put space around operator
            if operatorAvailable.contains(element) {
                result += " " + element + " "
            } else {
                result += element
            }
        }
        return result
        
        }
}
