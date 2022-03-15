//
//  RegisterViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 15/3/2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var btnClose: ImageButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwUsername: UIView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var vwConfirmPW: UIView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPhone: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPW: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var lblWarning: UILabel!
    
    let userModel = UserModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.initSetup()
    }
    
    func initSetup() {
        self.btnClose.method = { self.dismiss(animated: true, completion: nil) }
        self.lblTitle.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        self.lblTitle.textColor = .white
        self.lblTitle.text = "Register"
        
        self.vwUsername.layer.cornerRadius = 28
        self.vwPassword.layer.cornerRadius = 28
        self.vwConfirmPW.layer.cornerRadius = 28
        self.vwEmail.layer.cornerRadius = 28
        self.vwPhone.layer.cornerRadius = 28
        self.warningShadow(userName: false, password: false, confirmPW: false, email: false, phone: false)
        
        self.btnRegister.layer.masksToBounds = true
        self.btnRegister.layer.cornerRadius = 25
        self.btnRegister.setTitle("Register", for: .normal)
        
        self.lblWarning.font = UIFont.systemFont(ofSize: 14)
        self.lblWarning.textColor = .red
        self.lblWarning.isHidden = true
    }
    
    //MARK: - Method
    
    func warningShadow(userName: Bool, password: Bool, confirmPW: Bool, email: Bool, phone: Bool) {
        if userName == false {
            self.vwUsername.addShadow(location: .all)
        } else {
            self.vwUsername.addShadow(location: .all, color: .red, opacity: 0.4)
        }
        if password == false {
            self.vwPassword.addShadow(location: .all)
        } else {
            self.vwPassword.addShadow(location: .all, color: .red, opacity: 0.4)
        }
        if confirmPW == false {
            self.vwConfirmPW.addShadow(location: .all)
        } else {
            self.vwConfirmPW.addShadow(location: .all, color: .red, opacity: 0.4)
        }
        if email == false {
            self.vwEmail.addShadow(location: .all)
        } else {
            self.vwEmail.addShadow(location: .all, color: .red, opacity: 0.4)
        }
        if phone == false {
            self.vwPhone.addShadow(location: .all)
        } else {
            self.vwPhone.addShadow(location: .all, color: .red, opacity: 0.4)
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
        
    //MARK: - Button Action
    
    @IBAction func registerBtnPressed() {
        if self.tfEmail.text?.isEmpty == true || self.tfPassword.text?.isEmpty == true || self.tfConfirmPW.text?.isEmpty == true || self.tfEmail.text?.isEmpty == true || self.tfPhone.text?.isEmpty == true {
            //Empty handle
            self.lblWarning.isHidden = false
            self.lblWarning.text = "Please fill in all the blank."
            
        } else if let usernameCount = self.tfUsername.text?.count, (usernameCount < 8) || (usernameCount > 20){
            //Username count
            self.lblWarning.isHidden = false
            self.lblWarning.text = "Your username should be within 8 to 20 words."
            self.warningShadow(userName: true, password: false, confirmPW: false, email: false, phone: false)
        
        } else if self.checkUsernamePattern(self.tfUsername.text) == false {
            //Wrong username pattern
            self.lblWarning.isHidden = false
            self.lblWarning.text = "Your username allow letters, underscores and numbers only."
            self.warningShadow(userName: true, password: false, confirmPW: false, email: false, phone: false)
        
        } else if let password = self.tfPassword.text?.count, (password < 9) || (password > 15){
            //Password count
            self.lblWarning.isHidden = false
            self.lblWarning.text = "Your password should be within 9 to 15 words."
            self.warningShadow(userName: false, password: true, confirmPW: true, email: false, phone: false)
        
        } else if self.checkPasswordPattern(self.tfPassword.text) == false {
            //Wrong password pattern
            self.lblWarning.isHidden = false
            self.lblWarning.text = "Your password allow letters and numbers only."
            self.warningShadow(userName: false, password: true, confirmPW: true, email: false, phone: false)
        
        } else if self.tfPassword.text != self.tfConfirmPW.text{
            //Wrong password confirm
            self.lblWarning.isHidden = false
            self.lblWarning.text = "Your confirm password is different with your password."
            self.warningShadow(userName: false, password: true, confirmPW: true, email: false, phone: false)
            
        } else if self.checkEmailPattern(self.tfEmail.text) == false {
            //Wrong email pattern
            self.lblWarning.isHidden = false
            self.lblWarning.text = "It is not a vaild email."
            self.warningShadow(userName: false, password: false, confirmPW: false, email: true, phone: false)
            
        } else if (self.tfPhone.text?.count != 8) || (self.checkPhonePattern(self.tfPhone.text) == false) {
            //Wrong phone pattern
            self.lblWarning.isHidden = false
            self.lblWarning.text = "Phone number allows 8 digits only."
            self.warningShadow(userName: false, password: false, confirmPW: false, email: false, phone: true)
        } else {
            //Success
            self.lblWarning.isHidden = true
            self.warningShadow(userName: false, password: false, confirmPW: false, email: false, phone:false)
            self.userModel.addUser(username: self.tfUsername.text, password: self.tfPassword.text, email: self.tfEmail.text, phoneNo: self.tfPhone.text)
            self.showAlert(title: "Register an account successfully.", hideLeftButton: true, rightTitle: "OK", rightBtnAction: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }

}
