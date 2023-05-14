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
    
    // Configuration
    let numberMaxLenght = 10
    let expressionMaxLenght = 24

    // delaration of available opérator
    private let operatorAvailable: Set = ["+", "-", "×", "÷"]

    private var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }

    private var lastElementIsZero: Bool {
        return elements.last == "0"
    }

    private var lastElementIsDivideOperator: Bool {
        return elements.last == "÷"
    }

    /**
     * Use to add number in expression
     *
     *@param selection The selected number
    */
    func numberHasBeenTapped(_ selection: String) {

        // check if selection is Zero and operator before is divide
        guard !(lastElementIsDivideOperator && selection == "0") else {
            calculatorDelegate.showAlert(title: "Erreur",
                                         description: "Vous ne pouvez pas diviser par 0");
            return
        }
        
        // check if expression have enough place for number after
        guard expression.count < expressionMaxLenght else {
            calculatorDelegate.showAlert(title: "Expression Max", description: "Votre calcul est trop long !")
            return
        }
        
        if expressionHaveResult { expression = "0" }
        
        // check the max size of number
        guard elements.last!.count < numberMaxLenght else {
            calculatorDelegate.showAlert(title: "Erreur", description: "vous ne pouvez pas dépasser 10 chiffres")
            return
        }

        // delete zero if it zero before number
        if lastElementIsZero {
            expression.removeLast(1)
        }

        // add number to expression and update display
        expression += selection
        calculatorDelegate.updateDisplay(expression)
        calculatorDelegate.updateClearButton("C")
    }

    private var canAddOperator: Bool {
        return !operatorAvailable.contains(elements.last ?? "")
    }

    /**
     * Use to add operator in expression
     *
     *@param selection The selected opérator
    */
    func operatorHasBeenTapped(_ selection: String) {
        //check if it's a valide operator
        guard operatorAvailable.contains(selection) else {
            calculatorDelegate.showAlert(title: "Erreur",
                                         description: "opérateur non reconnu par la calculatrice");
            return
        }
        
        // if expression have result, clear expression and kepp the result
        if elements.contains("=") {
            if let result = elements.last {
                expression = result
            }
        }

        // if last elements is a operator, show alerte
        guard canAddOperator else {
            calculatorDelegate.showAlert(title: "Erreur!",
                                         description: "Entrez une expression correcte !");
            return
        }
        
        // check if expression have enough place for an operator and a number after
        guard expression.count <= (expressionMaxLenght - 4 ) else {
            calculatorDelegate.showAlert(title: "Max",
                                         description: "Votre calcul est trop long !")
            return
        }

        // Put space around operator and add in mathematical formula
        let operatorToAdd = " " + selection + " "
        expression.append(operatorToAdd)

        calculatorDelegate.updateDisplay(expression)
    }

    // check if expression have enough element to build a calcule
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    /**
     * check expression and call calcul()
     *
    */
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

    /**
     * Use clear expression : C clear
     *                 AC Clear All
     *
     *@param selection The selected opérator
    */
    func clearExpression(_ selection: String) {
        // check if selection is AC
        guard selection == "C" else {
            expression = "0";
            calculatorDelegate.updateDisplay(expression);
            return
        }

        guard let lastElement = elements.last else { return }
        
        // if only one number, clear all expression
        guard elements.count > 1 else {
            clearExpression("AC");
            calculatorDelegate.updateClearButton("AC");
            return
        }

 
        var start: String.Index
        
        // if element is a operator, remove operator and space around
        // else remove last number
        // init range to remove
        
        if operatorAvailable.contains(lastElement) {
            start = expression.index(expression.endIndex, offsetBy: -3)
        } else {
            start = expression.index(expression.endIndex, offsetBy: -(lastElement.count))
        }

        let stop = expression.index(expression.endIndex, offsetBy: -1)

        expression.removeSubrange(start...stop)
        
        calculatorDelegate.updateClearButton("AC")
        calculatorDelegate.updateDisplay(expression)
    }

    /**
     * Calculate expression
     * respect basic mathématique rules with priority to multiply and divide
     *
     *put result at the end of expression
    */
    private func calcul() {

        var operationsToReduce = elements
        var result: Double
        var index: Int

        // calculate until expression have result
        while operationsToReduce.count > 1 {
            // identifie primary operator
            if let primaryIndex = operationsToReduce.firstIndex(where: {$0 == "×" || $0 == "÷" }) {
                index = primaryIndex
            } else {
                index = 1
            }

            let left = Double(operationsToReduce[index-1])!
            let operand = operationsToReduce[index]
            let right = Double(operationsToReduce[index+1])!
            
            // check limitation of calculator
            let numberMax = Double("1.79e+298")
            guard left < numberMax! else {
                calculatorDelegate.showAlert(title: "Nombre Max",
                                             description: "Resultat trop grand!")
                return
            }

            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "×": result = left * right
            case "÷": result = left / right
            default: return
            }

            operationsToReduce.insert(convertInString(result), at: index-1)
            // remove number and operator used from expression
            operationsToReduce.removeSubrange(index...index+2)
        }
        // put result in expression
        expression += " = " + operationsToReduce[0]
    }

    /**
     * insert point in expression
    */
    func pointHasBeenTapped() {
        guard let lastElements = elements.last else { return }

        // check if last number have already a point
        guard !lastElements.contains(".") else {
            calculatorDelegate.showAlert(title: "Virgule",
                                         description: "Vous ne pouvez mettre qu'une virgule");
            return
        }

        // check if last element is a operator and put zero before point
        guard !operatorAvailable.contains(lastElements) else {
            expression.append("0.")
            calculatorDelegate.updateDisplay(expression)
            return
        }
        
        expression.append(".")
        calculatorDelegate.updateDisplay(expression)
    }

    /**
     * change signe of lat number
    */
    func changeSignTapped() {

        guard let lastElement = elements.last else { return }

        // last element is not operator
        guard !operatorAvailable.contains(lastElement) else { return }

        // last element is not Zero
        guard lastElement != "0" else { return }

        // last element can be transform in Double
        guard var lastNumber = Double(lastElement) else { return}

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

    /**
     * formate number tu have expression no more longer than 10
     * after, convert in string
     *
     *@param double : number to convert
     *
     *@return Sting Number formatted and convert to String
    */
    private func convertInString(_ double: Double) -> String {
        var stringDouble: String
        let format: String
        
        guard double != 0 else {return "0"}

        // expression is only decimal , show 8 number after point
        guard double.description.first != "0" else { return String(format: "%.8f", double) }
        
        guard double < 9223372036854775808 else { return String(format: "%.2e", double) }
        
        // expression have more than ten number before point, convert in scientifique
        guard Int(double).description.count < 10 else { return String(format: "%.2e", double)}
        
        // keep 5 number after point if expression is no longer than 6
        // else around with 2 numbers after point
        if Int(double).description.count < 6 {
            format = "%.5f"
        } else {
            format = "%.2f"
        }
        
        stringDouble = String(format: format, double)
        
        // remove O at the end of expression
        while stringDouble.last == "0"{
            stringDouble.removeLast()
        }
        
        // remove point if number have no decimal
        if stringDouble.last == "."{
            stringDouble.removeLast()
        }
        
        return stringDouble
    }
}
