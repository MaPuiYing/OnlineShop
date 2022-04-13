//
//  ProfilePasswordViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 18/3/2022.
//

import UIKit

class ProfilePasswordViewController: UIViewController {
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!

    var confirmBtnItem = UIBarButtonItem()
    var cancelBtnItem = UIBarButtonItem()
    
    let userModel = UserModel.shared
    let user = UserModel.shared.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customBackButton()
        self.title = "Change Password"
        
        self.navigationBarSetup()
        self.initSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabbar()
    }
    
    func initSetup() {
        self.vwBackground.layer.cornerRadius = 10
        
        self.tfOldPassword.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        self.tfPassword.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        self.tfConfirmPassword.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func navigationBarSetup() {
        self.confirmBtnItem = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(self.confirmBtnPressed))
        self.cancelBtnItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelBtnPressed))
        self.confirmBtnItem.tintColor = .btnOrange
        self.confirmBtnItem.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = self.cancelBtnItem
        self.navigationItem.rightBarButtonItem = self.confirmBtnItem
    }
    
    @objc func textFieldDidChange() {
        if let password = self.tfPassword.text, (password.count > 8) && (password.count < 16) && (self.tfOldPassword.text == self.user?.password) && (self.checkPasswordPattern(password) == true) && (password == self.tfConfirmPassword.text) {
            self.confirmBtnItem.isEnabled = true
        } else {
            self.confirmBtnItem.isEnabled = false
        }
    }
    
    //MARK: - Button Action
    
    @objc func confirmBtnPressed() {
        self.showAlert(title: "Are you sure to save your editing?", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "OK", rightBtnAction: { [weak self] in
            guard let theSelf = self else {return}
            theSelf.userModel.updatePassword(theSelf.tfPassword.text)
            theSelf.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func cancelBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
