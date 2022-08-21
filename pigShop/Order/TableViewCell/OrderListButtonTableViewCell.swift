//
//  OrderListButtonTableViewCell.swift
//  pigShop
//
//  Created by Pui Ying Ma on 15/8/2022.
//

import UIKit

class OrderListButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var btnLogistics: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var showDetail: (()->Void)?
    var showConfirm: (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func logisticsBtnPressed() {
        
    }
    
    @IBAction func detailBtnPressed() {
        self.showDetail?()
    }
    
    @IBAction func confirmBtnPressed() {
        self.showConfirm?()
    }

}
