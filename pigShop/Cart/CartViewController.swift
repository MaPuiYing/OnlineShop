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
        // Do any additional setup after loading the view.
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
        lblEmpty.textColor = .textGrey
        lblEmpty.text = "Welcome to add items to your cart."
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}