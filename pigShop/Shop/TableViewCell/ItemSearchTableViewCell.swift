//
//  ItemSearchTableViewCell.swift
//  pigShop
//
//  Created by Joyce Ma on 13/3/2022.
//

import UIKit

class ItemSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imvBanner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imvBookmarks: ImageButton!
    
    var action: (()->Void)?
    var isBookmarks = false {
            didSet {
                if self.isBookmarks == true {
                    self.imvBookmarks.image = UIImage(systemName: "heart.fill")
                } else {
                    self.imvBookmarks.image = UIImage(systemName: "heart")
                }
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
        self.lblOldPrice.isHidden = true
    }
    
    func initSetup() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewAction))
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
        
        self.imvBanner.layer.cornerRadius = 10
        
        self.lblTitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)        
        self.lblOldPrice.isHidden = true
        self.lblOldPrice.font = UIFont.systemFont(ofSize: 12)
        self.lblOldPrice.textColor = .textLightGrey
        self.lblPrice.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lblPrice.textColor = .textRed        
    }
    
    func setupOriginalPrice(_ price: String?) {
        self.lblOldPrice.isHidden = false
        let attributedString = NSMutableAttributedString(string: price ?? "")
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range:NSMakeRange(0, attributedString.length))
        self.lblOldPrice.attributedText = attributedString
    }
    
    @objc func viewAction() {
        self.action?()
    }
    
}
