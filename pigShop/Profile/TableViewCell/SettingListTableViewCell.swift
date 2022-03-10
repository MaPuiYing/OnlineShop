//
//  SettingListTableViewCell.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

class SettingListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!

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
        lbTitle.font = UIFont.systemFont(ofSize: 15)
        lbTitle.textColor = .textGrey
    }
    
}
