//
//  ItemDetailViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 13/3/2022.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var imvBanner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imvBookmarks: ImageButton!
    
    @IBOutlet weak var lblColumnPrice: UILabel!
    @IBOutlet weak var lblColumnDescription: UILabel!
    @IBOutlet weak var lblColumnCount: UILabel!

    
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var vwStepper: UIView!
    @IBOutlet weak var vwPlus: ViewButton!
    @IBOutlet weak var vwMinus: ViewButton!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnBuy: UIButton!

    var itemDetail: Item?
    
    var isBookmarks = false {
        didSet {
            if self.isBookmarks == true {
                self.imvBookmarks.image = UIImage(systemName: "heart.fill")
            } else {
                self.imvBookmarks.image = UIImage(systemName: "heart")
            }
        }
    }
    var currentCount = 1 {
        didSet {
            self.lblCount.text = "\(self.currentCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Item Title"
        self.customBackButton()
        self.initSetup()
        self.setupContent()
    }
    
    //MARK: - Set up method
    
    func initSetup() {
        self.imvBookmarks.method = {self.selectedBookmarks()}
        self.vwPlus.method = {self.plusBtnPressed()}
        self.vwMinus.method = {self.minusBtnPressed()}
        
        self.setupView()
        self.setupContent()
    }
    
    func setupView() {
        self.lblTitle.textColor = .black
        self.lblTitle.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        self.lblOldPrice.isHidden = true
        self.lblOldPrice.font = UIFont.systemFont(ofSize: 12)
        self.lblOldPrice.textColor = .textLightGrey
        
        self.lblColumnPrice.textColor = .textRed
        self.lblColumnPrice.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        self.lblColumnPrice.text = "Price: "
        self.lblColumnDescription.textColor = .textDarkGrey
        self.lblColumnDescription.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.lblColumnDescription.text = "Description: "
        self.lblColumnCount.textColor = .textDarkGrey
        self.lblColumnCount.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.lblColumnCount.text = "Count: "
        
        self.lblPrice.textColor = .textRed
        self.lblPrice.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        self.lblDescription.textColor = .textDarkGrey
        self.lblDescription.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.lblCount.textColor = .textDarkGrey
        self.lblCount.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        self.vwStepper.layer.cornerRadius = 6
        self.vwStepper.layer.borderWidth = 0.5
        self.vwStepper.layer.borderColor = UIColor.borderColor.cgColor
        
        self.btnCart.tintColor = .white
        self.btnCart.setTitleColor(.btnOrange, for: .normal)
        self.btnCart.setTitle("Add to cart", for: .normal)
        self.btnCart.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.btnCart.layer.borderWidth = 1
        self.btnCart.layer.borderColor = UIColor.btnOrange.cgColor
        self.btnCart.layer.cornerRadius = 6
        
        self.btnBuy.tintColor = .btnOrange
        self.btnBuy.setTitleColor(.white, for: .normal)
        self.btnBuy.setTitle("Buy for it", for: .normal)
        self.btnBuy.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    func setupContent() {
        guard let item = self.itemDetail else {return}
        self.imvBanner.sd_setImage(with: URL(string: item.imageURL ?? ""), completed: nil)
        self.lblTitle.text = item.title
        if item.isDiscount == true {
            self.setupOriginalPrice(item.oldPrice?.stringValue)
        }
        self.lblPrice.text = item.price?.stringValue
        self.lblDescription.text = item.description
        self.lblCount.text = "\(self.currentCount)"
    }
    
    func setupOriginalPrice(_ price: String?) {
        self.lblOldPrice.isHidden = false
        let attributedString = NSMutableAttributedString(string: price ?? "")
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        self.lblOldPrice.attributedText = attributedString
    }
    
    //MARK: - Button Action
    func plusBtnPressed() {
        if self.currentCount != 10 {
            self.currentCount += 1
        }
    }
    
    func minusBtnPressed() {
        if self.currentCount != 1 {
            self.currentCount -= 1
        }
    }
    
    func selectedBookmarks() {
        self.isBookmarks = !self.isBookmarks
    }

}
