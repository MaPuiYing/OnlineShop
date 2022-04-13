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
    let itemModel = ItemModel.shared
    let cartModel = CartModel.shared
    let userModel = UserModel.shared
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabbar()
    }
    
    //MARK: - Set up method
    
    func initSetup() {
        self.imvBookmarks.method = {self.selectedBookmarks()}
        self.isBookmarks = itemModel.getFaviorite(self.itemDetail?.id)
        
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
        self.btnBuy.setTitle("Buy it now", for: .normal)
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
        if self.currentCount != 9 {
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
        self.itemModel.setFaviorite(self.itemDetail?.id, value: self.isBookmarks)
    }
    
    @IBAction func addToCartBtnPressed() {
        if (self.cartModel.getCart().count == 10) && (self.cartModel.isDuplicate(item: self.itemDetail)) {
            self.showAlert(title: "Failed to add the item.\nYour cart is full now.", hideLeftButton: true, rightTitle: "OK")
        } else {
            self.cartModel.addCart(item: self.itemDetail, count: self.currentCount, success: { [weak self] in
                //Success
                self?.showAlert(title: "Add the item successfully.", hideLeftButton: true, rightTitle: "OK", rightBtnAction: { [weak self] in
                    guard let theSelf = self else {return}
                    theSelf.navigationController?.popViewController(animated: true)
                })
            }, failure: { [weak self] in
                //Failure
                self?.showAlert(title: "You are limited to store 9 amount for each item. Add it successfully.", hideLeftButton: true, rightTitle: "OK", rightBtnAction: { [weak self] in
                    guard let theSelf = self else {return}
                    theSelf.navigationController?.popViewController(animated: true)
                })
            }
        )}
    }
    
    @IBAction func buyItNowBtnPressed() {
        if self.userModel.isLogined() == false {
            self.showAlert(title: "Please login your account.", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "Login Now", rightBtnAction: { [weak self] in
                if let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    vc.modalPresentationStyle = .fullScreen
                    self?.tabBarController?.present(vc, animated: true, completion: nil)
                }
            })
        } else {
            self.showAlert(title: "Are you sure to buy the item?", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "Confirm", rightBtnAction: { [weak self] in
                if let vc = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
    }

}
