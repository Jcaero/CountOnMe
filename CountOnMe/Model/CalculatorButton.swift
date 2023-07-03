//
//  CalculatorButton.swift
//  CountOnMe
//
//  Created by pierrick viret on 19/06/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import UIKit
#warning ("pourquoi final")
final class CalculatorButton: UIButton {

        override init(frame : CGRect){
            super.init(frame: frame)
        }
        
        init(sign: CalculatorSigns) {
            #warning("frame")
            super.init(frame: .zero)
            self.setTitle(sign.rawValue, for: .normal)
            self.setTitleColor(sign.textColor, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            self.backgroundColor = sign.backgroudColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("CalculatorButton - init(coder:) has not been implemented")
        }
    }

enum CalculatorSigns: String, CaseIterable {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case plus = "+"
    case less = "-"
    case divide = "÷"
    case multiplied = "×"
    case sign = "+/-"
    case egal = "="
    case AC = "AC"
    case point = "."
    
    var backgroudColor: UIColor {
        switch self {
        case .plus, .less, .multiplied, .divide, .AC, .sign, .egal:
            return .goldLeafColor
        default:
            return .silverColor
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .plus, .less, .multiplied, .divide, .AC, .sign, .egal:
            return .silverColor
        default:
            return .white
        }
    }
}

