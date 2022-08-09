//
//  CheckoutTransactionTableViewCell.swift
//  pigShop
//
//  Created by Pui Ying Ma on 8/8/2022.
//

import UIKit

class CheckoutTransactionTableViewCell: UITableViewCell {

    @IBOutlet var tfInfo: [UITextField]!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var swhDefault: UISwitch!
    
    let userModel = UserModel.shared
    var user = UserModel.shared.currentUser
    
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
        self.tfInfo[0].text = self.user?.firstName
        self.tfInfo[1].text = self.user?.lastName
        self.tfInfo[2].text = self.user?.address
        
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
