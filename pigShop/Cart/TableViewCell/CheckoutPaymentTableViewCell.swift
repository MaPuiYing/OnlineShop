//
//  CheckoutPaymentTableViewCell.swift
//  pigShop
//
//  Created by Pui Ying Ma on 8/8/2022.
//

import UIKit

class CheckoutPaymentTableViewCell: UITableViewCell {
    
    @IBOutlet var aryBtn: [ViewButton]!
    @IBOutlet var aryCheckmark: [UIImageView]!

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
        for i in 0..<self.aryBtn.count {
            self.aryBtn[i].method = {[weak self] in
                self?.aryCheckmark.forEach({
                    $0.isHidden = ($0 == self?.aryCheckmark[i]) ? false : true
                })
            }
        }
    }

}
