//
//  SettingListTableViewCell.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

class SettingListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imvArrow: UIImageView!
    @IBOutlet weak var vwSeparator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initSetup() {
        lblTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lblTitle.textColor = .textGrey
    }
    
}
