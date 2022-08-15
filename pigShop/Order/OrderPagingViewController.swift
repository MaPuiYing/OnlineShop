//
//  OrderPagingViewController.swift
//  pigShop
//
//  Created by Pui Ying Ma on 10/8/2022.
//

import UIKit
import JXSegmentedView

class OrderPagingViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var orderStatus: OrderStatus = .pendingDelivery
    
    var orderModel = OrderModel.shared
    var userModel = UserModel.shared
    
    var aryOrder: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reset the item
        self.orderModel = OrderModel.shared
        self.userModel = UserModel.shared
        self.aryOrder = (orderModel.getUserOrder(self.userModel.getUser()?.id ?? 0) ?? []).filter({
            $0.status == orderStatus
        })
        
        self.table.reloadData()
    }
}

extension OrderPagingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.aryOrder.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = self.aryOrder[section].allItem?.count ?? 0
        return itemCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let count = self.aryOrder[indexPath.section].allItem?.count, indexPath.row < count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem") as? CheckoutItemTableViewCell else {return UITableViewCell()}
            let cart = self.aryOrder[indexPath.section].allItem?[indexPath.row]
            let item = cart?.item
            
            cell.imvBanner.sd_setImage(with: URL(string: item?.imageURL ?? ""))
            cell.lblTitle.text = item?.title
            cell.lblPrice.text = item?.price?.stringValue
            cell.lblCount.text = "x \(cart?.count ?? 1)"
            
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellBtn") as? OrderListButtonTableViewCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let count = self.aryOrder[indexPath.section].allItem?.count, indexPath.row < count {
            if let vc = UIStoryboard(name: "Shop", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
                let cart = self.aryOrder[indexPath.section].allItem?[indexPath.row]
                vc.itemDetail = cart?.item
                vc.isAllowEdit = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //Header
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    //Header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .tableBackground
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let orderId = self.aryOrder[section].id {
            return "Order id: \(orderId)"
        }
        return ""
    }
}

//MARK: - JXSegmentedListContainerViewListDelegate

extension OrderPagingViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
