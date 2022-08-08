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
    
    var aryCart: [Cart] = []
    var totalPrice: Double = 0

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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPrice") as? CheckoutTitleTableViewCell else {return UITableViewCell()}
            cell.lblTitle.text = self.totalPrice.stringValue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
