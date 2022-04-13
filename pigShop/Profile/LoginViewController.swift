//
//  LoginViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 15/3/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnClose: ImageButton!
    
    @IBOutlet weak var vwUsername: UIView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var vwRegister: ViewButton!
    
    @IBOutlet weak var vwWarning: UIView!
    @IBOutlet weak var lblWarning: UILabel!
    
    var userModel = UserModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.vwRegister.method = { self.registerBtnPressed() }
        self.btnClose.method = { self.dismiss(animated: true, completion: nil) }
        self.initSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userModel = UserModel.shared
    }
    
    func initSetup() {
        self.vwUsername.layer.cornerRadius = 28
        self.vwPassword.layer.cornerRadius = 28
        self.btnLogin.layer.masksToBounds = true
        self.btnLogin.layer.cornerRadius = 28
        self.btnLogin.setTitle("Login", for: .normal)
        
        self.vwWarning.isHidden = true
    }
    
    //MARK: - Button Action
    
    @IBAction func loginBtnPressed() {
        if self.tfUsername.text?.isEmpty == true || self.tfPassword.text?.isEmpty == true {
            self.vwWarning.isHidden = false
            self.lblWarning.text = "Please fill in all the blank."
        } else {
            self.userModel.loginUser(username: self.tfUsername.text, password: self.tfPassword.text, success: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }, failure: { [weak self] in
                self?.vwWarning.isHidden = false
                self?.lblWarning.text = "Invaild username or password."
            })
        }
    }
    
    func registerBtnPressed() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
