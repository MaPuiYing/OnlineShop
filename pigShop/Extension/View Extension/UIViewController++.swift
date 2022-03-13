//
//  UIViewController++.swift
//  pigShop
//
//  Created by Joyce Ma on 12/3/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func customBackButton() {
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),style: .plain, target: self, action: #selector(back))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
