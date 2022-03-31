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
    
    func showAlert(title: String, hideLeftButton: Bool, leftTitle: String = "", rightTitle: String = "", leftBtnAction: @escaping (()->Void) = {}, rightBtnAction: @escaping (()->Void) = {}) {
        let alertView = AlertViewController(nibName: "AlertViewController", bundle: nil)
        alertView.alertContent = AlertContent(title: title, hideLeftButton: hideLeftButton, leftTitle: leftTitle, rightTitle: rightTitle, leftBtnAction: leftBtnAction, rightBtnAction: rightBtnAction)
        alertView.providesPresentationContextTransitionStyle = true
        alertView.definesPresentationContext = true
        alertView.modalPresentationStyle = .overCurrentContext
        alertView.modalTransitionStyle = .crossDissolve
        
        if self.tabBarController == nil {
            self.present(alertView, animated: true, completion: nil)
        } else {
            self.tabBarController?.present(alertView, animated: true, completion: nil)
        }
    }
    
    //MARK: - Validation
        
    func checkUsernamePattern(_ text: String?) -> Bool {
        let pattern = "\\A\\w{8,20}\\z"
        return text?.range(of: pattern, options: .regularExpression) != nil
    }
        
    func checkPasswordPattern(_ text: String?) -> Bool {
        return text?.range(of: "\\A\\w{9,15}\\z", options: .regularExpression) != nil
    }
        
    func checkEmailPattern(_ text: String?) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return text?.range(of: pattern, options: .regularExpression) != nil
    }
        
    func checkPhonePattern(_ text: String?) -> Bool {
        let pattern = "[0-9]{8}"
        return text?.range(of: pattern, options: .regularExpression) != nil
    }
    
    func checkNamePattern(_ text:String?) -> Bool {
        guard let textCount = text?.count, textCount > 1, textCount < 10 else { return false }
        let pattern = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
        return text?.range(of: pattern, options: .regularExpression) != nil
    }
    
    func checkAddressPattern(_ text: String?) -> Bool {
        guard let addressCount = text?.count, addressCount > 10, addressCount < 70 else { return false }
        let pattern = "^[a-zA-Z0-9,/ ]+$"
        return text?.range(of: pattern, options: .regularExpression) != nil
    }
}
