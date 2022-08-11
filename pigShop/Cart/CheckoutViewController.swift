//
//  CheckoutViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 13/4/2022.
//

import UIKit

enum CheckoutSection {
    case title(String)
    case transactionInfo
    case paymentMethod
    case itemReview(Cart)
    case totalPrice
}
class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var tableSection: [CheckoutSection] = []
    var isOrderFromCart = false
    var aryCart: [Cart] = []
    var totalPrice: Double = 0
    
    let userModel = UserModel.shared
    let orderModel = OrderModel.shared
    let cartModel = CartModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Checkout"
        self.customBackButton()
        self.tableSetup()
        // Do any additional setup after loading the view.
    }
    
    func tableSetup() {
        self.tableSection.append(.title("Transaction Information"))
        self.tableSection.append(.transactionInfo)
        self.tableSection.append(.title("Choose Your Payment Method"))
        self.tableSection.append(.paymentMethod)
        self.tableSection.append(.title("Item Review"))
        for item in aryCart {
            self.tableSection.append(.itemReview(item))
        }
        self.tableSection.append(.totalPrice)
        self.table.reloadData()
    }
    
    func continueBtnPressed() {
        var firstName = ""
        var lastName = ""
        var streetAddress = ""
        var city = "Alberta"
        var isNeedDefault = true
        var paymentMethod = -1
        
        //Get transaction method
        let transactionIndex = self.tableSection.firstIndex(where: {
            if case .transactionInfo = $0 {
                return true
            } else {
                return false
            }
        }) ?? 0
        if let cell = self.table.cellForRow(at: IndexPath(row: transactionIndex, section: 0)) as? CheckoutTransactionTableViewCell {
            firstName = cell.tfFirstName.text ?? ""
            lastName = cell.tfLastName.text ?? ""
            streetAddress = cell.tvAddress.text ?? ""
            city = cell.btnCity.currentTitle ?? ""
            isNeedDefault = cell.swhDefault.isOn
        }
        
        //Get Payment Method
        let paymentIndex = self.tableSection.firstIndex(where: {
            if case .paymentMethod = $0 {
                return true
            } else {
                return false
            }
        }) ?? 0
        if let cell = self.table.cellForRow(at: IndexPath(row: paymentIndex, section: 0)) as? CheckoutPaymentTableViewCell {
            paymentMethod = cell.aryCheckmark.firstIndex {
                $0.isHidden == false
            } ?? -1
        }
        
        if self.validateChecking(firstName: firstName, lastName: lastName, streetAddress: streetAddress, city: city, paymentMethod: paymentMethod) {
            if isNeedDefault {
                self.userModel.updateTransactionInfo(firstName: firstName, lastName: lastName, address: streetAddress, city: city)
            }
            self.showAlert(title: "Confirm to order?", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "Confirm", rightBtnAction: {[weak self] in
                guard let theSelf = self else {return}
                theSelf.orderModel.addOrder(userId: theSelf.userModel.getUser()?.id ?? 0, firstName: firstName, lastName: lastName, address: streetAddress, city: city, paymentMethod: PaymentMethod(rawValue: paymentMethod) ?? .googlePay, allItem: theSelf.aryCart, totalPrice: theSelf.totalPrice)
                
                if theSelf.isOrderFromCart {
                    for cart in theSelf.aryCart {
                        theSelf.cartModel.deleteCart(id: cart.id ?? 0)
                    }
                }
                
                theSelf.tabBarController?.tabBar.isHidden = false
                if let controller = theSelf.navigationController?.viewControllers.first {
                    theSelf.navigationController?.popToViewController(controller, animated: true)
                } else {
                    theSelf.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    func validateChecking(firstName: String, lastName: String, streetAddress: String, city: String, paymentMethod: Int) -> Bool {
        if firstName.isEmpty == true || lastName.isEmpty == true || streetAddress.isEmpty == true {
            self.showAlertMessage("Please fill in all the blank")
        } else if paymentMethod == -1 {
            self.showAlertMessage("Please select the payment method")
        } else if !(self.checkNamePattern(firstName)) || !(self.checkNamePattern(lastName)) {
            self.showAlertMessage("Invalid Name")
        } else if !self.checkAddressPattern(streetAddress) {
            self.showAlertMessage("Invalid Address")
        } else {
            return true
        }
        
        return false
    }
}


//MARK: - UITableView Delegate, DataSource
extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableSection[indexPath.row]
        switch row {
        case .title(let titleString):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTitle") as? CheckoutTitleTableViewCell else {return UITableViewCell()}
            cell.lblTitle.text = titleString
            return cell
        case .transactionInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransaction") as? CheckoutTransactionTableViewCell else {return UITableViewCell()}
            return cell
        case .paymentMethod:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPayment") as? CheckoutPaymentTableViewCell else {return UITableViewCell()}
            return cell
        case .itemReview(let cart):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem") as? CheckoutItemTableViewCell else {return UITableViewCell()}
            let item = cart.item
            cell.imvBanner.sd_setImage(with: URL(string: item?.imageURL ?? ""))
            cell.lblTitle.text = item?.title
            if item?.isDiscount == true {
                cell.setupOriginalPrice(item?.oldPrice?.stringValue)
            }
            cell.lblPrice.text = item?.price?.stringValue
            cell.lblCount.text = "x \(cart.count ?? 1)"
            return cell
        case .totalPrice:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPrice") as? CheckoutPriceTableViewCell else {return UITableViewCell()}
            cell.lblPrice.text = self.totalPrice.stringValue
            cell.continueMethod = {[weak self] in
                self?.continueBtnPressed()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
