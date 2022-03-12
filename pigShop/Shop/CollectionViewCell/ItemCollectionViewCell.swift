//
//  ItemCollectionViewCell.swift
//  pigShop
//
//  Created by Joyce Ma on 11/3/2022.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imvBanner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imvBookmarks: ImageButton!
    
    @IBOutlet weak var vwContent: UIView!
    
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
        initSetup()
        // Initialization code
    }
    
    func initSetup() {
        self.setupView()
        self.imvBookmarks.method = {self.selectedBookmarks()}
    }
    
    func setupView() {
        self.vwContent.layer.cornerRadius = 8
        self.vwContent.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.vwContent.layer.borderWidth = 1
        self.vwContent.layer.borderColor = UIColor.borderColor.cgColor
        
        self.lblTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        self.lblOldPrice.isHidden = true
        self.lblOldPrice.font = UIFont.systemFont(ofSize: 12)
        self.lblOldPrice.textColor = .textLightGrey
        
        self.lblPrice.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.lblPrice.textColor = .textRed
    }
    
    func setupOriginalPrice(_ price: String) {
        self.lblOldPrice.isHidden = false
        let attributedString = NSMutableAttributedString(string: price)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        self.lblOldPrice.attributedText = attributedString
    }
    
    func selectedBookmarks() {
        self.isBookmarks = !self.isBookmarks
    }

}
