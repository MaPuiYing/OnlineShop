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
        
        self.tabBarController?.present(alertView, animated: true, completion: nil)
    }
}