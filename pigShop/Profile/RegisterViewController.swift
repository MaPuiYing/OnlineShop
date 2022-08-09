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
    
    @IBOutlet weak var vwWarning: UIView!
    @IBOutlet weak var lblWarning: UILabel!
    
    let userModel = UserModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.btnClose.method = {[weak self] in self?.dismiss(animated: true, completion: nil) }
        self.initSetup()
    }
    
    func initSetup() {
        self.lblTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        self.lblTitle.textColor = .black
        self.lblTitle.text = "Create new account"
        
        self.vwUsername.layer.cornerRadius = 28
        self.vwPassword.layer.cornerRadius = 28
        self.vwConfirmPW.layer.cornerRadius = 28
        self.vwEmail.layer.cornerRadius = 28
        self.vwPhone.layer.cornerRadius = 28
        self.warningShadow(userName: false, password: false, confirmPW: false, email: false, phone: false)
        
        self.btnRegister.layer.masksToBounds = true
        self.btnRegister.layer.cornerRadius = 28
        self.btnRegister.setTitle("Register", for: .normal)
        
        self.vwWarning.isHidden = true
        self.lblWarning.font = UIFont.systemFont(ofSize: 14)
        self.lblWarning.textColor = .red
    }
    
    //MARK: - Method
    
    func warningShadow(userName: Bool?, password: Bool?, confirmPW: Bool?, email: Bool?, phone: Bool?) {
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
    
    func showWarningMessage(_ message: String) {
        self.vwWarning.isHidden = false
        self.lblWarning.text = message
    }
        
    //MARK: - Button Action
    
    @IBAction func registerBtnPressed() {
        let username = self.tfUsername.text ?? ""
        let password = self.tfPassword.text ?? ""
        let confirmPW = self.tfConfirmPW.text ?? ""
        let email = self.tfEmail.text ?? ""
        let phone = self.tfPhone.text ?? ""
        
        if username.isEmpty == true || password.isEmpty == true || confirmPW.isEmpty == true || email.isEmpty == true || phone.isEmpty == true {
            //Empty handle
            self.showWarningMessage("Please fill in all the blank.")
            self.warningShadow(userName: username.isEmpty, password: password.isEmpty, confirmPW: confirmPW.isEmpty, email: email.isEmpty == true, phone: phone.isEmpty)
            
        } else if (username.count < 8) || (username.count > 20){
            //Username count
            self.showWarningMessage("Your username should be within 8 to 20 words.")
            self.warningShadow(userName: true, password: false, confirmPW: false, email: false, phone: false)
        
        } else if self.checkUsernamePattern(username) == false {
            //Wrong username pattern
            self.showWarningMessage("Your username allow letters, underscores and numbers only.")
            self.warningShadow(userName: true, password: false, confirmPW: false, email: false, phone: false)
        
        } else if (password.count < 9) || (password.count > 15){
            //Password count
            self.showWarningMessage("Your password should be within 9 to 15 words.")
            self.warningShadow(userName: false, password: true, confirmPW: true, email: false, phone: false)
        
        } else if self.checkPasswordPattern(password) == false {
            //Wrong password pattern
            self.showWarningMessage("Your password allow letters and numbers only.")
            self.warningShadow(userName: false, password: true, confirmPW: true, email: false, phone: false)
        
        } else if self.tfPassword.text != confirmPW{
            //Wrong password confirm
            self.showWarningMessage("Your confirm password is different with your password.")
            self.warningShadow(userName: false, password: true, confirmPW: true, email: false, phone: false)
            
        } else if self.checkEmailPattern(email) == false {
            //Wrong email pattern
            self.showWarningMessage("It is not a vaild email.")
            self.warningShadow(userName: false, password: false, confirmPW: false, email: true, phone: false)
            
        } else if (phone.count != 8) || (self.checkPhonePattern(phone) == false) {
            //Wrong phone pattern
            self.showWarningMessage("Phone number allows 8 digits only.")
            self.warningShadow(userName: false, password: false, confirmPW: false, email: false, phone: true)
        } else {
            //Success
            self.vwWarning.isHidden = true
            self.warningShadow(userName: false, password: false, confirmPW: false, email: false, phone: false)
            self.userModel.addUser(username: username, password: password, email: email, phoneNo: phone)
            self.showAlert(title: "Register an account successfully.", hideLeftButton: true, rightTitle: "OK", rightBtnAction: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }

}
