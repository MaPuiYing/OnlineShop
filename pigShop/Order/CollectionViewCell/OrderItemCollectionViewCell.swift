//
//  OrderItemCollectionViewCell.swift
//  pigShop
//
//  Created by Pui Ying Ma on 17/8/2022.
//

import UIKit

class OrderItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imvBanner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imvBanner.layer.cornerRadius = 10
    }

}
