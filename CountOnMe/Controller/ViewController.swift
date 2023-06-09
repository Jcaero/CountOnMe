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
    let goldLeafColor = UIColor(red: 0.82, green: 0.70, blue: 0.5, alpha: 1)
    
    let silverButtonsTitles = ["0", "1", "2","3", "4", "5","6", "7", "8", "9", "."]
    let goldLeafButtonsTitles = ["+", "-", "×","÷","AC","+/-","="]
    var buttonsListe = [String:CornerRoundedButton]()
    
    let stackViewMain = UIStackView()
    let stackViewVertical1 = UIStackView()
    let stackViewVertical2 = UIStackView()
    let stackViewVertical3 = UIStackView()
    let stackViewOperator = UIStackView()
    
    let textLbl = UILabel()
    
    private var calculate: Calculator!

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay("0")
        calculate = Calculator(delegate: self)
        
        setupBoutons()
        setupButtonsLayout()
        
        setupLabel()
        setupLabelLayout()
    }
    

    private func setupBoutons() {
        for title in silverButtonsTitles {
            createButton(title, style: silverColor)
        }
        for title in goldLeafButtonsTitles {
            createButton(title, style: goldLeafColor)
        }
    }
    
    private func createButton(_ title: String, style : UIColor) {
        let button = CornerRoundedButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        
        switch style {
        case silverColor:
            button.setColor( background: silverColor, titre: .white)
        case goldLeafColor:
            button.setColor(background: goldLeafColor, titre: silverColor)
        default:
            print("couleur inconnu")
        }
        
        button.addTarget(self, action: #selector(tappedButton(_:)) , for: .touchUpInside)
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
            buttonsListe["AC"]!.widthAnchor.constraint(equalTo: buttonsListe["AC"]!.heightAnchor)
        ])
        
        // stackview operator
        addButtonInStackView(stackViewOperator, array: ["×", "-", "+"])
    
        view.addSubview(stackViewOperator)
        NSLayoutConstraint.activate([
            buttonsListe["+"]!.widthAnchor.constraint(equalTo: buttonsListe["+"]!.heightAnchor, multiplier: 1.0),
            buttonsListe["+"]!.widthAnchor.constraint(equalTo: buttonsListe["AC"]!.widthAnchor),
            buttonsListe["×"]!.centerYAnchor.constraint(equalTo: buttonsListe["AC"]!.centerYAnchor),
            stackViewOperator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
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
    
    @objc func tappedButton(_ sender: UIButton) {
        guard let titre = sender.currentTitle else {
            return
        }
        
        switch titre {
        case "0", "1", "2","3", "4", "5","6", "7", "8", "9" :
            calculate.numberHasBeenTapped(titre)
        case "+", "-", "×","÷" :
            calculate.operatorHasBeenTapped(titre)
        case "=" :
            calculate.egalHasBeenTapped()
        case "AC", "C" :
            calculate.clearExpression(titre)
        case "+/-":
            calculate.changeSignTapped()
        case ".":
            calculate.pointHasBeenTapped()
        default :
            print ("boutton inconnu")
        }
    }

    private func setupLabel() {
        textLbl.backgroundColor = silverColor
        textLbl.textColor = .white
        textLbl.font = UIFont.systemFont(ofSize: 80)
        textLbl.minimumScaleFactor = 0.5
        textLbl.adjustsFontSizeToFitWidth = true
        textLbl.numberOfLines = 3
        textLbl.textAlignment = .right
    }
    
    private func setupLabelLayout() {
        textLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview( textLbl)
        NSLayoutConstraint.activate([
            textLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textLbl.bottomAnchor.constraint(equalTo: stackViewMain.topAnchor , constant: -10),
            textLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            textLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5)
        ])
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
        textLbl.text = expression
    }
}
