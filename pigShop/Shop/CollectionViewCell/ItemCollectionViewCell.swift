//
//  ItemCollectionViewCell.swift
//  pigShop
//
//  Created by Joyce Ma on 11/3/2022.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imvBanner: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblOldPrice.isHidden = true
    }
    
    func initSetup() {
        self.setupView()
    }
    
    func setupView() {
        self.vwContent.layer.cornerRadius = 8
        self.vwContent.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.vwContent.layer.borderWidth = 1
        self.vwContent.layer.borderColor = UIColor.borderColor.cgColor
        
        self.lblOldPrice.isHidden = true
    }
    
    func setupOriginalPrice(_ price: String?) {
        self.lblOldPrice.isHidden = false
        let attributedString = NSMutableAttributedString(string: price ?? "")
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        self.lblOldPrice.attributedText = attributedString
    }

}
