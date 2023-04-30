//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var calculate = Calculator()

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDispay("")
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        

    }
    
    @IBAction func tappedOpperatorButton(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculate.
    }

}

extension ViewController : CalculatorDelegate {
    
    func showAlert(_ title: String, description: String) {
        let alertVC = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
    
    func updateDispay(_ expression: String) {
        textView.text = expression
    }
    
}

