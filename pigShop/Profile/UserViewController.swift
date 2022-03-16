//
//  UserViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 16/3/2022.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var imvIcon: ImageButton!
    @IBOutlet weak var imvCamera: ImageButton!
    
    @IBOutlet weak var tfUserID: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var vwOldPassword: UIView!
    @IBOutlet weak var vwNewPassword: UIView!
    
    @IBOutlet weak var vwLineUsername: UIView!
    @IBOutlet weak var vwLineOldPassword: UIView!
    @IBOutlet weak var vwLineNewPassword: UIView!
    @IBOutlet weak var vwLineConfirmPassword: UIView!
    @IBOutlet weak var vwLineEmail: UIView!
    @IBOutlet weak var vwLinePhone: UIView!
    
    let user = UserModel.shared.currentUser
    var editBtnItem = UIBarButtonItem()
    var saveBtnItem = UIBarButtonItem()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User"
        self.customBackButton()
        self.navigationBarSetup()
        self.initSetup()
    }
    
    func initSetup() {
        self.showEditView(false)
        self.tfUserID.text = "\(user?.id ?? 0)"
        self.tfUsername.text = user?.username
        self.tfEmail.text = user?.email
        self.tfPhone.text = user?.phoneNo
    }
    
    func navigationBarSetup() {
        self.editBtnItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(self.editBtnPressed))
        self.saveBtnItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveBtnPressed))
        
        self.navigationItem.rightBarButtonItem = self.editBtnItem
    }
    
    //MARK: - Button Action
    @objc func editBtnPressed() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.showEditView(true)
        })
        self.navigationItem.rightBarButtonItem = self.saveBtnItem
    }
    
    @objc func saveBtnPressed() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.showEditView(false)
        })
        self.navigationItem.rightBarButtonItem = self.editBtnItem
    }
    
    //MARK: - Method
    func showEditView(_ isShow: Bool) {
        self.vwOldPassword.isHidden = !isShow
        self.vwNewPassword.isHidden = !isShow
                
        self.vwLineUsername.isHidden = !isShow
        self.vwLineOldPassword.isHidden = !isShow
        self.vwLineNewPassword.isHidden = !isShow
        self.vwLineConfirmPassword.isHidden = !isShow
        self.vwLineEmail.isHidden = !isShow
        self.vwLinePhone.isHidden = !isShow
        
        self.tfUserID.isEnabled = false
        self.tfUsername.isEnabled = isShow
        self.tfOldPassword.isEnabled = isShow
        self.tfNewPassword.isEnabled = isShow
        self.tfConfirmPassword.isEnabled = isShow
        self.tfEmail.isEnabled = isShow
        self.tfPhone.isEnabled = isShow
        
        if isShow {
            self.tfUsername.becomeFirstResponder()
        }
    }
}

extension UserViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.tfUsername:
            self.vwLineUsername.backgroundColor = .mainOrange
        case self.tfOldPassword:
            self.vwLineOldPassword.backgroundColor = .mainOrange
        case self.tfNewPassword:
            self.vwLineNewPassword.backgroundColor = .mainOrange
        case self.tfConfirmPassword:
            self.vwLineConfirmPassword.backgroundColor = .mainOrange
        case self.tfEmail:
            self.vwLineEmail.backgroundColor = .mainOrange
        case self.tfPhone:
            self.vwLinePhone.backgroundColor = .mainOrange
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.tfUsername:
            self.vwLineUsername.backgroundColor = .borderColor
        case self.tfOldPassword:
            self.vwLineOldPassword.backgroundColor = .borderColor
        case self.tfNewPassword:
            self.vwLineNewPassword.backgroundColor = .borderColor
        case self.tfConfirmPassword:
            self.vwLineConfirmPassword.backgroundColor = .borderColor
        case self.tfEmail:
            self.vwLineEmail.backgroundColor = .borderColor
        case self.tfPhone:
            self.vwLinePhone.backgroundColor = .borderColor
        default:
            break
        }
    }
}
