//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let silverColor = UIColor(red: 89, green: 77, blue: 70, alpha: 1)
    let goldLefColor = UIColor(red: 209, green: 178, blue: 128, alpha: 1)
    
    let acButton = UIButton(type: .system)
    let pointButton = UIButton(type: .system)
    let signButton = UIButton(type: .system)
    let egalButton = UIButton(type: .system)
    
    let numbersButtonsTitles = ["0", "1", "2","3", "4", "5","6", "7", "8", "9"]
    var numbersButtons: [UIButton] = []
    
    let operateursButtonsTitles = ["+", "-", "×","÷"]
    var operateursButtons: [UIButton] = []
    
    @IBOutlet weak var textLbl: UILabel!
    
    private var calculate: Calculator!

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay("0")
        calculate = Calculator(delegate: self)
        
        setupBoutons()
        setupButtonsLayout()
    }

    // View actions
    @objc func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.currentTitle else {
            return
        }
        calculate.numberHasBeenTapped(numberText)
    }

    @objc func tappedOpperatorButton(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }
        calculate.operatorHasBeenTapped(operatorText)
    }

    @objc func tappedEqualButton(_ sender: UIButton) {
        calculate.egalHasBeenTapped()
    }

    @objc func tappedACButton(_ sender: UIButton) {
        guard let clearText = sender.title(for: .normal) else {
            return
        }
        calculate.clearExpression(clearText)
    }

    @objc func tappedChangeSign(_ sender: UIButton) {
        calculate.changeSignTapped()
    }

    @objc func tappedPointButton(_ sender: UIButton) {
        calculate.pointHasBeenTapped()
    }
    
    // creation of bouttons
    private func setupBoutons() {
        
        // déclaration of bouttons nombre
        for title in numbersButtonsTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            setColorButton(button, background: silverColor, titre: .white)
            button.addTarget(self, action: #selector(tappedNumberButton(_:)), for: .touchUpInside)
            numbersButtons.append(button)
        }
        
        // declaration of operateurs
        for title in operateursButtonsTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            setColorButton(button, background: goldLefColor, titre: silverColor)
            button.addTarget(self, action: #selector(tappedOpperatorButton(_:)), for: .touchUpInside)
            operateursButtons.append(button)
        }
        
        pointButton.setTitle(".", for: .normal)
        pointButton.addTarget(self, action: #selector(tappedPointButton(_:)), for: .touchUpInside)
        setColorButton(pointButton, background: silverColor, titre: .white)
        
        signButton.setTitle("+/-", for: .normal)
        signButton.addTarget(self, action: #selector(tappedChangeSign(_:)), for: .touchUpInside)
        setColorButton(signButton, background: goldLefColor, titre: silverColor)
        
        egalButton.setTitle("=", for: .normal)
        egalButton.addTarget(self, action: #selector(tappedEqualButton(_:)), for: .touchUpInside)
        setColorButton(egalButton, background: goldLefColor, titre: silverColor)
        
        acButton.setTitle("AC", for: .normal)
        acButton.addTarget(self, action: #selector(tappedACButton(_:)), for: .touchUpInside)
        setColorButton(acButton, background: goldLefColor, titre: silverColor)
    }
    
    private func setColorButton(_ boutton: UIButton, background: UIColor, titre: UIColor){
        boutton.backgroundColor = background
        boutton.setTitleColor(titre, for: .normal)
    }
    
    private func setupButtonsLayout() {
        
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
