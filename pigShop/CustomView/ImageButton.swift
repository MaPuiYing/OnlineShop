//
//  ImageButton.swift
//  pigShop
//
//  Created by Joyce Ma on 12/3/2022.
//

import Foundation
import UIKit

class ImageButton: UIImageView {
    var method: (()->Void)? {
        didSet {
            self.initSetup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func initSetup() {
        self.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageButtonPressed))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func imageButtonPressed() {
        self.method?()
    }
}
