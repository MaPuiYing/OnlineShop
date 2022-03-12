//
//  OrderViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var vwLogin: UIView!
    @IBOutlet weak var lblLogin: UILabel!
    
    @IBOutlet weak var vwEmpty: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    
    var isLogin = true
    var isEmpty = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Order"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isLogin {
            loginViewSetup()
        } else {
            if isEmpty {
                emptyViewSetup()
            } else {
                vwLogin.isHidden = true
                vwEmpty.isHidden = true
            }
        }
    }
    
    func loginViewSetup() {
        vwLogin.isHidden = false
        vwEmpty.isHidden = true
        
        lblLogin.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lblLogin.textColor = .textDarkGrey
        lblLogin.text = "You cannot read it since you have not yet logged in your account."
    }
    
    func emptyViewSetup() {
        vwEmpty.isHidden = false
        vwLogin.isHidden = true
        
        lblEmpty.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        lblEmpty.textColor = .textLightGrey
        lblEmpty.text = "Your order list is empty."
    }
}
