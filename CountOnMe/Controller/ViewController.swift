//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let silverColor = UIColor(red: 0.35, green: 0.30, blue: 0.27, alpha: 1.0)
    let goldLefColor = UIColor(red: 0.82, green: 0.70, blue: 0.5, alpha: 1)
    
    let numbersButtonsTitles = ["0", "1", "2","3", "4", "5","6", "7", "8", "9"]
    let operateursButtonsTitles = ["+", "-", "×","÷"]
    var buttonsListe = [String:UIButton]()
    
    let stackViewMain = UIStackView()
    let stackViewVertical1 = UIStackView()
    let stackViewVertical2 = UIStackView()
    let stackViewVertical3 = UIStackView()
    let stackViewOperator = UIStackView()
    
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
            createButton(title, style: .silver, selector: #selector(tappedNumberButton(_:)))
        }
        
        // declaration of operateurs
        for title in operateursButtonsTitles {
            createButton(title, style: .goldLeaf, selector: #selector(tappedOpperatorButton(_:)))
        }
        
        createButton(".", style: .silver, selector:  #selector(tappedPointButton(_:)))
        createButton("+/-", style: .goldLeaf, selector:  #selector(tappedChangeSign(_:)))
        createButton("=", style: .goldLeaf, selector:  #selector(tappedEqualButton(_:)))
        createButton("AC", style: .goldLeaf, selector:  #selector(tappedACButton(_:)))
    }
    
    private func createButton(_ title: String, style : buttonStyle, selector : Selector) {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        switch style {
        case .silver:
            setColorButton(button, background: silverColor, titre: .white)
        case .goldLeaf:
            setColorButton(button, background: goldLefColor, titre: silverColor)
        }
        
        button.addTarget(self, action: selector , for: .touchUpInside)
        buttonsListe[title] = button
        
    }

    private func setColorButton(_ boutton: UIButton, background: UIColor, titre: UIColor) {
        boutton.backgroundColor = background
        boutton.setTitleColor(titre, for: .normal)
    }
    
    private func setupButtonsLayout() {
        setupStackView(stackViewMain, axis: .horizontal, spacing: 10, alignement: .fill, distribution: .fillEqually)
        setupStackView(stackViewVertical1, axis: .vertical, spacing: 10, alignement: .fill, distribution: .fillEqually)
        setupStackView(stackViewVertical2, axis: .vertical, spacing: 10, alignement: .fill, distribution: .fillEqually)
        setupStackView(stackViewVertical3, axis: .vertical, spacing: 10, alignement: .fill, distribution: .fillEqually)
        setupStackView(stackViewOperator, axis: .vertical, spacing: 10, alignement: .fill, distribution: .fillEqually)
        
        // setup main stackview
        addButtonInStackView(stackViewVertical1, array: ["AC", "1", "4", "7"])
        addButtonInStackView(stackViewVertical2, array: ["+/-", "2", "5", "8"])
        addButtonInStackView(stackViewVertical3, array: ["÷", "3", "6", "9"])
        
        stackViewMain.addArrangedSubview(stackViewVertical1)
        stackViewMain.addArrangedSubview(stackViewVertical2)
        stackViewMain.addArrangedSubview(stackViewVertical3)

        view.addSubview(stackViewMain)
        NSLayoutConstraint.activate([
            stackViewMain.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            buttonsListe["AC"]!.widthAnchor.constraint(equalTo: buttonsListe["AC"]!.heightAnchor, multiplier: 1.0)
        ])
        
        // stackview operator
        addButtonInStackView(stackViewOperator, array: ["×", "-", "+"])
    
        view.addSubview(stackViewOperator)
        NSLayoutConstraint.activate([
            buttonsListe["+"]!.widthAnchor.constraint(equalTo: buttonsListe["+"]!.heightAnchor, multiplier: 1.0),
            buttonsListe["+"]!.widthAnchor.constraint(equalTo: buttonsListe["AC"]!.widthAnchor),
            buttonsListe["×"]!.centerYAnchor.constraint(equalTo: buttonsListe["AC"]!.centerYAnchor),
            stackViewOperator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10),
            stackViewOperator.leftAnchor.constraint(equalTo: stackViewMain.rightAnchor, constant: 10),
        ])
        
        // Point boutton
        view.addSubview( buttonsListe["."]!)
        NSLayoutConstraint.activate([
            buttonsListe["."]!.widthAnchor.constraint(equalTo: buttonsListe["."]!.heightAnchor, multiplier: 1.0),
            buttonsListe["."]!.widthAnchor.constraint(equalTo: buttonsListe["9"]!.widthAnchor),
            buttonsListe["."]!.centerXAnchor.constraint(equalTo: buttonsListe["9"]!.centerXAnchor),
            buttonsListe["."]!.topAnchor.constraint(equalTo: stackViewMain.bottomAnchor, constant: 10),
            buttonsListe["."]!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        // zero button
        view.addSubview( buttonsListe["0"]!)
        NSLayoutConstraint.activate([
            buttonsListe["0"]!.leftAnchor.constraint(equalTo: buttonsListe["7"]!.leftAnchor),
            buttonsListe["0"]!.rightAnchor.constraint(equalTo: buttonsListe["."]!.leftAnchor, constant: -10),
            buttonsListe["0"]!.topAnchor.constraint(equalTo: stackViewMain.bottomAnchor, constant: 10),
            buttonsListe["0"]!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        // egal button
        view.addSubview( buttonsListe["="]!)
        NSLayoutConstraint.activate([
            buttonsListe["="]!.leftAnchor.constraint(equalTo:buttonsListe["."]!.rightAnchor , constant: 10),
            buttonsListe["="]!.widthAnchor.constraint(equalTo: buttonsListe["."]!.widthAnchor),
            buttonsListe["="]!.topAnchor.constraint(equalTo: stackViewOperator.bottomAnchor, constant: 10),
            buttonsListe["="]!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
       
        /*
        if button.frame.height > button.frame.width {
            button.layer.cornerRadius = button.frame.width * 0.1
        } else {
            button.layer.cornerRadius = button.frame.height * 0.1
        }*/
      
    }
    
    private func setupStackView( _ stackView: UIStackView, axis : NSLayoutConstraint.Axis, spacing: CGFloat, alignement: UIStackView.Alignment, distribution: UIStackView.Distribution ) {
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignement
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addButtonInStackView(_ stackView: UIStackView, array : [String]) {
        for buttonName in array {
            if let button = buttonsListe[buttonName]{
                stackView.addArrangedSubview(button)
            }
        }
    }
    
}

extension ViewController: CalculatorDelegate {
    func updateClearButton(_ button: String) {
        buttonsListe["AC"]!.setTitle(button, for: .normal)
    }

    func showAlert(title: String, description: String) {
        let alertVC = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }

    func updateDisplay(_ expression: String) {
      //  textLbl.text = expression
    }
}
