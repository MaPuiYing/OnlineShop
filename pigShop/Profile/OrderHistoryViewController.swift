//
//  OrderHistoryViewController.swift
//  pigShop
//
//  Created by Pui Ying Ma on 22/8/2022.
//

import UIKit

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var vwEmpty: UIView!
    
    var orderModel = OrderModel.shared
    var userModel = UserModel.shared
    
    var aryOrder: [Order] = []
    var filteredOrder: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Order History"
        self.customBackButton()
        self.table.register(UINib(nibName: "CheckoutItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cellItem")
        self.table.register(UINib(nibName: "OrderListButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "cellBtn")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshContent()
    }
    
    func refreshContent() {
        self.orderModel = OrderModel.shared
        self.userModel = UserModel.shared
        self.aryOrder = (orderModel.getUserOrder(self.userModel.getUser()?.id ?? 0) ?? []).filter({
            $0.status == .history
        })
        
        let searchText = self.searchBar.text ?? ""
        if searchText.isEmpty {
            self.filteredOrder = self.aryOrder
        } else {
            self.filteredOrder = self.aryOrder.filter({
                $0.allItem?.filter({
                    $0.item?.title?.localizedCaseInsensitiveContains(searchText) == true
                }).count ?? 0 > 0
            })
        }
        
        self.vwEmpty.isHidden = !self.aryOrder.isEmpty
        self.table.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredOrder.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = self.filteredOrder[section].allItem?.count ?? 0
        return itemCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let count = self.filteredOrder[indexPath.section].allItem?.count, indexPath.row < count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem") as? CheckoutItemTableViewCell else {return UITableViewCell()}
            let cart = self.filteredOrder[indexPath.section].allItem?[indexPath.row]
            let item = cart?.item
            
            cell.imvBanner.sd_setImage(with: URL(string: item?.imageURL ?? ""))
            cell.lblTitle.text = item?.title
            cell.lblPrice.text = item?.price?.stringValue
            cell.lblCount.text = "x \(cart?.count ?? 1)"
            
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellBtn") as? OrderListButtonTableViewCell else {return UITableViewCell()}
            cell.btnLogistics.isHidden = true
            cell.btnConfirm.isHidden = true
            
            cell.showDetail = {[weak self] in
                if let vc = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
                    vc.modalPresentationStyle = .fullScreen
                    vc.order = self?.filteredOrder[indexPath.row-1]
                    self?.tabBarController?.present(vc, animated: true, completion: nil)
                }
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let count = self.filteredOrder[indexPath.section].allItem?.count, indexPath.row < count {
            if let vc = UIStoryboard(name: "Shop", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
                let cart = self.filteredOrder[indexPath.section].allItem?[indexPath.row]
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
        if let orderId = self.filteredOrder[section].id {
            return "Order id: \(orderId)"
        }
        return ""
    }
}

//MARK: - UISearchBar Delegate

extension OrderHistoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredOrder = self.aryOrder
        } else {
            self.filteredOrder = self.aryOrder.filter({
                $0.allItem?.filter({
                    $0.item?.title?.localizedCaseInsensitiveContains(searchText) == true
                }).count ?? 0 > 0
            })
        }
        
        self.table.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        
        if searchText.isEmpty {
            self.filteredOrder = self.aryOrder
        } else {
            self.filteredOrder = self.aryOrder.filter({
                $0.allItem?.filter({
                    $0.item?.title?.localizedCaseInsensitiveContains(searchText) == true
                }).count ?? 0 > 0
            })
        }
        
        self.table.reloadData()
    }
}
