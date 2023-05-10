//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var acButton: UIButton!
    @IBOutlet weak var textLbl: UILabel!
    
    private var calculate: Calculator!

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay("0")
        calculate = Calculator(delegate: self)
        setupLabel()
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculate.numberHasBeenTapped(numberText)
    }

    @IBAction func tappedOpperatorButton(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }
        calculate.operatorHasBeenTapped(operatorText)
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculate.egalHasBeenTapped()
    }

    @IBAction func tappedACButton(_ sender: UIButton) {
        guard let clearText = sender.title(for: .normal) else {
            return
        }
        calculate.clearExpression(clearText)
    }

    @IBAction func tappedChangeSign(_ sender: UIButton) {
        calculate.changeSignTapped()
    }

    @IBAction func tappedPointButton(_ sender: UIButton) {
        calculate.pointHasBeenTapped()
    }
    
    // change label propiety when display is to small
    private func setupLabel() {
        // height and width of the device screen
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        // change minimum front size if screen is under 5.5"
        if (height < 700 && width < 400) {
            textLbl.adjustsFontSizeToFitWidth = true
            textLbl.minimumScaleFactor = 0.5
        }
    }
}

extension ViewController: CalculatorDelegate {
    func updateClearButton(_ button: String) {
        acButton.setTitle(button, for: .normal)
    }

    func showAlert(title: String, description: String) {
        let alertVC = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }

    func updateDisplay(_ expression: String) {
        textLbl.text = expression
    }
}
