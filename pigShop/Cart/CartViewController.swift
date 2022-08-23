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
    
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnCheckout: UIButton!

    let cartModel = CartModel.shared
    var userModel = UserModel.shared
    
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
        self.userModel = UserModel.shared
        self.aryCart = cartModel.aryCart
        self.updateCartContent()
        self.emptySetup()
    }
    
    //MARK: - Init set up
    
    func initSetup() {
        self.vwBottom.addShadow(location: .top, color: .black.withAlphaComponent(0.3))
        
        self.btnCheckout.setTitle("Checkout", for: .normal)
        self.btnCheckout.tintColor = .btnOrange
        self.btnCheckout.layer.masksToBounds = true
        self.btnCheckout.layer.cornerRadius = self.btnCheckout.bounds.height/2
    }
    
    func tableViewSetup() {
        self.table.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        self.table.contentInset.top = 6
        self.table.contentInset.bottom = 20
    }
    
    func emptySetup() {
        if self.aryCart.isEmpty {
            self.vwEmpty.isHidden = false
        } else {
            self.vwEmpty.isHidden = true
            self.table.reloadData()
        }
    }
    
    //MARK: - Button Action
    @IBAction func checkoutBtnPressed() {
        if self.userModel.isLogined() == false {
            self.showAlert(title: "Please login your account.", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "Login Now", rightBtnAction: { [weak self] in
                if let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    vc.modalPresentationStyle = .fullScreen
                    self?.tabBarController?.present(vc, animated: true, completion: nil)
                }
            })
        } else {
            self.showAlert(title: "Are you sure to buy the item(s)?", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "Confirm", rightBtnAction: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController {
                    vc.aryCart = self?.aryCart.filter({$0.isChecked == true}) ?? []
                    vc.totalPrice = self?.totalPrice ?? 0
                    vc.isOrderFromCart = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
    }
    
    //MARK: - Method
    
    func updateCartContent() {
        self.aryCart = self.cartModel.getCart()
        
        var total: Double = 0
        for cart in self.aryCart {
            if cart.isChecked == true {
                total += (cart.item?.price ?? 0) * Double(cart.count ?? 1)
            }
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
        cell.isChecked = model.isChecked ?? true
        
        //Method
        
        cell.imvCheckBox.method = { [weak self] in
            cell.isChecked = !cell.isChecked
            self?.cartModel.updateChecked(id: model.id ?? 0, isChecked: cell.isChecked)
            self?.updateCartContent()
            
        }
        cell.vwMinus.method = { [weak self] in
            if cell.currentCount != 1 {
                cell.currentCount -= 1
                self?.cartModel.updateCount(id: model.id ?? 0, count: cell.currentCount)
                self?.updateCartContent()
            }
        }
        cell.vwPlus.method = { [weak self] in
            if cell.currentCount != 9 {
                cell.currentCount += 1
                self?.cartModel.updateCount(id: model.id ?? 0, count: cell.currentCount)
                self?.updateCartContent()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.cartModel.deleteCart(id: self.aryCart[indexPath.row].id ?? indexPath.row)
            self.updateCartContent()
            self.emptySetup()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Shop", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
            vc.itemDetail = self.aryCart[indexPath.row].item
            vc.isAllowEdit = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
