//
//  CornerRadiusButton.swift
//  CountOnMe
//
//  Created by pierrick viret on 09/06/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//
import UIKit

class CornerRoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        if self.frame.height > self.frame.width {
            self.layer.cornerRadius = self.frame.width * 0.1
        } else {
            self.layer.cornerRadius = 5
            //self.layer.cornerRadius = self.frame.height * 0.1
        }
    }
    
    func setColor( background: UIColor, titre: UIColor) {
        self.backgroundColor = background
        self.setTitleColor(titre, for: .normal)
    }
}
