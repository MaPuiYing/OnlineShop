//
//  UITextField++.swift
//  pigShop
//
//  Created by Joyce Ma on 31/3/2022.
//

import Foundation
import UIKit

extension UITextField {
    func addBorder(color: UIColor = .borderColor, width: CGFloat = 1, radius: CGFloat = 8) {
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
    }
    
    func removeBorder() {
        self.layer.borderWidth = 0
    }
}
