//
//  ShopButton.swift
//  pigShop
//
//  Created by Joyce Ma on 21/4/2022.
//

import Foundation
import UIKit

@IBDesignable class ShopButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBInspectable
    var color: UIColor = .clear {
        didSet {
            self.backgroundColor = self.color
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 40 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
}
