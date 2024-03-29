//
//  UserViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 16/3/2022.
//

import UIKit
import RSKImageCropper

class UserViewController: UIViewController {
    
    @IBOutlet weak var imvIcon: ImageButton!
    @IBOutlet weak var imvCamera: ImageButton!
    
    @IBOutlet weak var tfUserID: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var vwLineUsername: UIView!
    @IBOutlet weak var vwLineEmail: UIView!
    @IBOutlet weak var vwLinePhone: UIView!
    
    let userModel = UserModel.shared
    var user = UserModel.shared.currentUser
    var imagePicker = UIImagePickerController()
    var newIcon: Data? = nil
    
    var editBtnItem = UIBarButtonItem()
    var saveBtnItem = UIBarButtonItem()
    var cancelBtnItem = UIBarButtonItem()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User"
        self.customBackButton()
        self.navigationBarSetup()
        self.initSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabbar()
    }
    
    func initSetup() {
        self.showEditView(false)
        self.setupContent()
        
        self.imvCamera.method = {[weak self] in self?.cameraBtnPressed()}
    }
    
    func setupContent() {
        self.user = UserModel.shared.currentUser
        
        self.tfUserID.text = "\(self.user?.id ?? 0)"
        self.tfUsername.text = self.user?.username
        self.tfEmail.text = self.user?.email
        self.tfPhone.text = self.user?.phoneNo
        
        if let userIcon = self.user?.icon {
            self.imvIcon.image = UIImage(data: userIcon)
            self.newIcon = userIcon
        } else {
            self.imvIcon.image = UIImage(systemName: "person.circle.fill")
            self.newIcon = nil
        }
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
            let username = self.tfUsername.text ?? ""
            let email = self.tfEmail.text ?? ""
            let phone = self.tfPhone.text ?? ""
            
            if username.isEmpty == true || email.isEmpty == true || phone.isEmpty == true {
                self.showAlertMessage("Please fill in all the blank.")
            } else if (username.count < 8) || (username.count > 20) {
                self.showAlertMessage("Your username should be within 8 to 20 words.")
            } else if self.checkUsernamePattern(username) == false {
                self.showAlertMessage("Your username allow letters, underscores and numbers only.")
            } else if self.checkEmailPattern(email) == false {
                self.showAlertMessage("It is not a vaild email.")
            } else if (phone.count != 8) || (self.checkPhonePattern(phone) == false) {
                self.showAlertMessage("Phone number allows 8 digits only.")
            } else {
                self.showAlert(title: "Are you sure to save your editing?", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "OK", rightBtnAction: { [weak self] in
                    self?.userModel.updateUserInfo(username: username, email: email, phone: phone, icon: self?.newIcon)
                    self?.initSetup()
                    self?.closeEditAction()
                })
            }
        } else {
            self.closeEditAction()
        }
    }
    
    func cameraBtnPressed() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false

            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - Method
    
    func showEditView(_ isShow: Bool) {
        self.vwLineUsername.isHidden = !isShow
        self.vwLineEmail.isHidden = !isShow
        self.vwLinePhone.isHidden = !isShow
        self.imvCamera.isHidden = !isShow
        
        self.tfUserID.isEnabled = false
        self.tfUsername.isEnabled = isShow
        self.tfEmail.isEnabled = isShow
        self.tfPhone.isEnabled = isShow
        
        if isShow {
            self.tfUsername.becomeFirstResponder()
        }
    }
    
    func isEdited() -> Bool {
        return (self.tfUsername.text != self.user?.username) || (self.tfEmail.text != self.user?.email) || (self.tfPhone.text != self.user?.phoneNo) || (self.newIcon != self.user?.icon)
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

extension UserViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.tfUsername:
            self.vwLineUsername.backgroundColor = .mainOrange
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
        case self.tfEmail:
            self.vwLineEmail.backgroundColor = .borderColor
        case self.tfPhone:
            self.vwLinePhone.backgroundColor = .borderColor
        default:
            break
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate

extension UserViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        picker.dismiss(animated: true, completion: {
            var imageCropVC : RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
            imageCropVC.delegate = self
            imageCropVC.applyMaskToCroppedImage = true
            imageCropVC.avoidEmptySpaceAroundImage = true
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        })
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png") else {
            return
        }

        let pngData = croppedImage.pngData();
        do {
            try pngData?.write(to: imageURL);
            self.newIcon = pngData
        } catch {}

        self.imvIcon.image = croppedImage
        
        self.navigationController?.popViewController(animated: true)
    }
}
