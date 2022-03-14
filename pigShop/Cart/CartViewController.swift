//
//  CartViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var vwEmpty: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    
    @IBOutlet weak var lblColumnTotal: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnCheckout: UIButton!

    let cartModel = CartModel.shared
    var aryCart: [Cart] = []
    var totalPrice: Double = 0 {
        didSet {
            self.lblTotal.text = self.totalPrice.stringValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Cart"
        self.initSetup()
        self.tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.aryCart = cartModel.aryCart
        self.updateTotalPrice()
        self.emptySetup()
    }
    
    //MARK: - Init set up
    
    func initSetup() {
        self.lblColumnTotal.font = UIFont.systemFont(ofSize: 13)
        self.lblColumnTotal.text = "Total"
        self.lblColumnTotal.textColor = .textLightGrey
        self.lblTotal.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        self.btnCheckout.setTitle("Checkout", for: .normal)
        self.btnCheckout.tintColor = .btnOrange
        self.btnCheckout.layer.masksToBounds = true
        self.btnCheckout.layer.cornerRadius = self.btnCheckout.bounds.height/2
    }
    
    func tableViewSetup() {
        self.table.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
    }
    
    func emptySetup() {
        if self.aryCart.isEmpty {
            self.vwEmpty.isHidden = false
            
            self.lblEmpty.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            self.lblEmpty.textColor = .textDarkGrey
            self.lblEmpty.text = "Welcome to add items to your cart."
        } else {
            self.vwEmpty.isHidden = true
            self.table.reloadData()
        }
    }
    
    //MARK: - Method
    
    func updateTotalPrice() {
        self.aryCart = self.cartModel.getCart()
        
        var total: Double = 0
        for cart in self.aryCart {
            total += (cart.item?.price ?? 0) * Double(cart.count ?? 1)
        }
        
        self.totalPrice = total
    }
}

//MARK: - UITableView Delegate & Data Source

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartItemTableViewCell else {return UITableViewCell()}
        let model = self.aryCart[indexPath.row]
        let item = model.item
        
        cell.imvBanner.sd_setImage(with: URL(string: item?.imageURL ?? ""), completed: nil)
        cell.lblTitle.text = item?.title
        cell.lblPrice.text = item?.price?.stringValue
        if item?.isDiscount == true {
            cell.setupOriginalPrice(item?.oldPrice?.stringValue)
        }
        cell.currentCount = model.count ?? 1
        
        cell.vwMinus.method = {
            if cell.currentCount != 1 {
                cell.currentCount -= 1
                self.cartModel.updateCount(id: model.id ?? 0, count: cell.currentCount)
                self.updateTotalPrice()
            }
        }
        cell.vwPlus.method = {
            if cell.currentCount != 9 {
                cell.currentCount += 1
                self.cartModel.updateCount(id: model.id ?? 0, count: cell.currentCount)
                self.updateTotalPrice()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.cartModel.deleteCart(id: self.aryCart[indexPath.row].id ?? indexPath.row)
            self.updateTotalPrice()
            self.emptySetup()
        }
    }
}
