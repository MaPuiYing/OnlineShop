//
//  CheckoutPriceTableViewCell.swift
//  pigShop
//
//  Created by Pui Ying Ma on 9/8/2022.
//

import UIKit

class CheckoutPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    var continueMethod: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func continueBtnPressed() {
        self.continueMethod?()
    }

}
