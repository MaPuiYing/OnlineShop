//
//  CartViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var vwEmpty: UIView!
    @IBOutlet weak var lblEmpty: UILabel!

    var isEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Cart"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isEmpty {
            emptySetup()
        } else {
            vwEmpty.isHidden = true
        }
    }
    
    func emptySetup() {
        vwEmpty.isHidden = false
        
        lblEmpty.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lblEmpty.textColor = .textDarkGrey
        lblEmpty.text = "Welcome to add items to your cart."
    }
}
