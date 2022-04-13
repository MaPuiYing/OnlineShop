//
//  TransactionInfoViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 21/3/2022.
//

import UIKit

class TransactionInfoViewController: UIViewController {
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    
    @IBOutlet weak var vwLineFirstName: UIView!
    @IBOutlet weak var vwLineLastName: UIView!
    @IBOutlet weak var vwLineAddress: UIView!
    
    @IBOutlet weak var btnCity: UIButton!
        
    let userModel = UserModel.shared
    var user = UserModel.shared.currentUser
        
    var editBtnItem = UIBarButtonItem()
    var saveBtnItem = UIBarButtonItem()
    var cancelBtnItem = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transaction Information"
        self.customBackButton()
        self.navigationBarSetup()
        self.initSetup()
        // Do any additional setup after loading the view.
    }
    
    func initSetup() {
        self.vwBackground.layer.cornerRadius = 10
        self.setupContent()

        self.showEditView(false)
    }
    
    func setupContent() {
        self.user = UserModel.shared.currentUser
        self.tfFirstName.text = user?.firstName
        self.tfLastName.text = user?.lastName
        self.tfAddress.text = user?.address
        
        self.setupMenu()
    }
    
    func setupMenu() {
        var btnActions: [UIAction] = []
        for items in self.userModel.cityString {
            let action = UIAction(title: items, state: (self.user?.city == items) ? .on : .off, handler: {_ in })
            btnActions.append(action)
        }
        self.btnCity.menu = UIMenu(options: .singleSelection, children: btnActions)
    }
    
    func navigationBarSetup() {
        self.editBtnItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(self.editBtnPressed))
        self.cancelBtnItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelBtnPressed))
        self.saveBtnItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveBtnPressed))
        self.saveBtnItem.tintColor = .btnOrange
            
        self.navigationItem.rightBarButtonItem = self.editBtnItem
    }
    
    //MARK: - Button Action
        
    @objc func editBtnPressed() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.showEditView(true)
        })
        self.navigationItem.leftBarButtonItem = self.cancelBtnItem
        self.navigationItem.rightBarButtonItem = self.saveBtnItem
    }
        
    @objc func cancelBtnPressed() {
        if self.isEdited() {
            self.showAlert(title: "Are you sure to cancel your editing?", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "OK", rightBtnAction: { [weak self] in
                self?.setupContent()
                self?.closeEditAction()
            })
        } else {
            self.closeEditAction()
        }
    }
        
    @objc func saveBtnPressed() {
        if self.isEdited() {
            let firstName = self.tfFirstName.text
            let lastName = self.tfLastName.text
            let address = self.tfAddress.text

            if firstName?.isEmpty == false && !(self.checkNamePattern(firstName)) {
                self.showAlertMessage("Invalid First Name")
            } else if lastName?.isEmpty == false && !(self.checkNamePattern(lastName)) {
                self.showAlertMessage("Invalid Last Name")
            } else if address?.isEmpty == false && !self.checkAddressPattern(address) {
                self.showAlertMessage("Invalid Address")
            } else {
                self.showAlert(title: "Are you sure to save your editing?", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "OK", rightBtnAction: { [weak self] in
                    guard let theSelf = self else {return}
                    theSelf.userModel.updateTransactionInfo(firstName: firstName, lastName: lastName, address: address, city: theSelf.btnCity.currentTitle)
                    theSelf.initSetup()
                    theSelf.closeEditAction()
                })
            }
        } else {
            self.closeEditAction()
        }
    }
    
    //MARK: - Method
    
    func showAlertMessage(_ title: String) {
        self.showAlert(title: title, hideLeftButton: true, rightTitle: "OK")
    }
    
    func showEditView(_ isShow: Bool) {
        self.vwLineFirstName.isHidden = !isShow
        self.vwLineLastName.isHidden = !isShow
        self.vwLineAddress.isHidden = !isShow
        self.tfFirstName.isEnabled = isShow
        self.tfLastName.isEnabled = isShow
        self.tfAddress.isEnabled = isShow
        
        self.btnCity.isEnabled = isShow
            
        if isShow {
            self.tfFirstName.becomeFirstResponder()
        }
        
        if (self.user?.firstName ?? "").isEmpty {
            self.tfFirstName.text = isShow ? "" : "Null"
        }
        if (self.user?.lastName ?? "").isEmpty {
            self.tfLastName.text = isShow ? "" : "Null"
        }
        if (self.user?.address ?? "").isEmpty {
            self.tfAddress.text = isShow ? "" : "Null"
        }
    }
    
    func isEdited() -> Bool {
        let firstName = self.user?.firstName ?? ""
        let lastName = self.user?.lastName ?? ""
        let address = self.user?.address ?? ""
        let city = self.user?.city ?? ""
        
        return (self.tfFirstName.text != firstName) || (self.tfLastName.text != lastName) || (self.tfAddress.text != address) || (self.btnCity.currentTitle != city)
    }
    
    func closeEditAction() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.showEditView(false)
        })
        self.customBackButton()
        self.navigationItem.rightBarButtonItem = self.editBtnItem
    }
}

//MARK: - UITextFieldDelegate

extension TransactionInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.tfFirstName:
            self.vwLineFirstName.backgroundColor = .mainOrange
        case self.tfLastName:
            self.vwLineLastName.backgroundColor = .mainOrange
        case self.tfAddress:
            self.vwLineAddress.backgroundColor = .mainOrange
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.tfFirstName:
            self.vwLineFirstName.backgroundColor = .borderColor
        case self.tfLastName:
            self.vwLineLastName.backgroundColor = .borderColor
        case self.tfAddress:
            self.vwLineAddress.backgroundColor = .borderColor
        default:
            break
        }
    }
}
