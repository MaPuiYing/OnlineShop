//
//  CategorySelectionCollectionViewCell.swift
//  pigShop
//
//  Created by Joyce Ma on 11/3/2022.
//

import UIKit

class CategorySelectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwCircle: UIView!
    @IBOutlet weak var imvIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupView() {
        self.layoutIfNeeded()
        self.vwCircle.layer.cornerRadius = self.vwCircle.bounds.height/2
        self.lblTitle.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setBackground(_ color: UIColor) {
        self.vwCircle.backgroundColor = color
    }
}
