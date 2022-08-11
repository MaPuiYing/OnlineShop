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
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var tvPlaceHolder: UILabel!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabbar()
    }
    
    func initSetup() {
        self.vwBackground.layer.cornerRadius = 10
        self.setupContent()

        self.showEditView(false)
    }
    
    func setupContent() {
        self.user = UserModel.shared.currentUser
        self.tfFirstName.text = self.user?.firstName
        self.tfLastName.text = self.user?.lastName
        
        
        self.tvAddress.text = self.user?.address
        self.tvAddress.textContainer.lineFragmentPadding = 0
        self.tvPlaceHolder.isHidden = !self.tvAddress.text.isEmpty
        
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
            let address = self.tvAddress.text

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
    
    func showEditView(_ isShow: Bool) {
        self.btnCity.setImage(isShow ? UIImage(systemName: "chevron.down") : nil, for: .normal)
        self.tfFirstName.isEnabled = isShow
        self.tfLastName.isEnabled = isShow
        self.tvAddress.isEditable = isShow
        self.btnCity.isEnabled = isShow
            
        if isShow {
            self.tfFirstName.becomeFirstResponder()
        }
    }
    
    func isEdited() -> Bool {
        let firstName = self.user?.firstName ?? ""
        let lastName = self.user?.lastName ?? ""
        let address = self.user?.address ?? ""
        let city = self.user?.city ?? ""
        
        return (self.tfFirstName.text != firstName) || (self.tfLastName.text != lastName) || (self.tvAddress.text != address) || (self.btnCity.currentTitle != city)
    }
    
    func closeEditAction() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.showEditView(false)
        })
        self.customBackButton()
        self.navigationItem.rightBarButtonItem = self.editBtnItem
    }
}

//MARK: - UITextViewDelegate

extension TransactionInfoViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 70
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.tvPlaceHolder.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.tvPlaceHolder.isHidden = !textView.text.isEmpty
    }
}
