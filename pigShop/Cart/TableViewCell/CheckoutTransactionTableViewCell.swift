//
//  CheckoutTransactionTableViewCell.swift
//  pigShop
//
//  Created by Pui Ying Ma on 8/8/2022.
//

import UIKit

class CheckoutTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var tvPlaceHolder: UILabel!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var swhDefault: UISwitch!
    
    let userModel = UserModel.shared
    var user = UserModel.shared.currentUser
    var updateTableHeight: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initSetup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initSetup() {
        self.tfFirstName.text = self.user?.firstName
        self.tfLastName.text = self.user?.lastName
        self.tvAddress.text = self.user?.address
        
        self.tvAddress.isEditable = true
        self.tvAddress.textContainer.lineFragmentPadding = 0
        self.tvPlaceHolder.isHidden = !self.tvAddress.text.isEmpty
        
        self.setupMenu()
    }
    
    func setupMenu() {
        self.btnCity.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        
        var btnActions: [UIAction] = []
        for items in self.userModel.cityString {
            let action = UIAction(title: items, state: (self.user?.city == items) ? .on : .off, handler: {_ in })
            btnActions.append(action)
        }
        self.btnCity.menu = UIMenu(options: .singleSelection, children: btnActions)
    }
}

//MARK: - UITextViewDelegate

extension CheckoutTransactionTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 70
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.tvPlaceHolder.isHidden = !textView.text.isEmpty
        
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
        if size.height != newSize.height {
            self.updateTableHeight?()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.tvPlaceHolder.isHidden = !textView.text.isEmpty
    }
}
