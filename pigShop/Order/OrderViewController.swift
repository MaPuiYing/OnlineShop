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
    
    var userModel = UserModel.shared
    var orderModel = OrderModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Order"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userModel = UserModel.shared
        self.orderModel = OrderModel.shared
        
        if self.userModel.isLogined() == false {
            self.loginViewSetup()
        } else {
            if let userId = self.userModel.getUser()?.id, let order = self.orderModel.getUserOrder(userId), order.count != 0 {
                vwLogin.isHidden = true
                vwEmpty.isHidden = true
            } else {
                self.emptyViewSetup()
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
