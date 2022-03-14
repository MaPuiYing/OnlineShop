//
//  CartItemTableViewCell.swift
//  pigShop
//
//  Created by Joyce Ma on 14/3/2022.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imvCheckBox: ImageButton!
    @IBOutlet weak var imvBanner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var vwPlus: ViewButton!
    @IBOutlet weak var vwMinus: ViewButton!
    @IBOutlet weak var lblCount: UILabel!
    
    var isChecked: Bool = true {
        didSet {
            if self.isChecked {
                self.imvCheckBox.tintColor = .mainOrange
                self.imvCheckBox.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                self.imvCheckBox.tintColor = .borderSecondary
                self.imvCheckBox.image = UIImage(systemName: "circle")
            }
        }
    }
    var currentCount = 1 {
        didSet {
            self.lblCount.text = "\(self.currentCount)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initSetup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblOldPrice.isHidden = true
    }
    
    func initSetup() {
        self.imvBanner.layer.cornerRadius = 10
        self.lblTitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        self.lblOldPrice.isHidden = true
        self.lblOldPrice.font = UIFont.systemFont(ofSize: 12)
        self.lblOldPrice.textColor = .textLightGrey
        self.lblPrice.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lblPrice.textColor = .textRed
        
        self.lblCount.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lblCount.textColor = .textDarkGrey
        
        self.imvCheckBox.method = {self.isChecked = !self.isChecked}
    }
    
    func setupOriginalPrice(_ price: String?) {
        self.lblOldPrice.isHidden = false
        let attributedString = NSMutableAttributedString(string: price ?? "")
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        self.lblOldPrice.attributedText = attributedString
    }
}
