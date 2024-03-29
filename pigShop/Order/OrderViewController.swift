//
//  OrderViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit
import JXSegmentedView

class OrderViewController: UIViewController {
    
    @IBOutlet weak var vwLogin: UIView!
    @IBOutlet weak var vwEmpty: UIView!
    
    var userModel = UserModel.shared
    var orderModel = OrderModel.shared
    let imageHeaderSegment = TitleSegment()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Order"
//        self.navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vwLogin.isHidden = true
        self.vwEmpty.isHidden = true
        
        self.userModel = UserModel.shared
        self.orderModel = OrderModel.shared

        if self.userModel.isLogined() == false {
            self.loginViewSetup()
            self.removeOrderView()
        } else {
            if let userId = self.userModel.getUser()?.id, let order = self.orderModel.getUserOrder(userId), order.count != 0 {
                self.vwLogin.isHidden = true
                self.vwEmpty.isHidden = true
                self.orderViewSetup()
            } else {
                self.emptyViewSetup()
                self.removeOrderView()
            }
        }
    }
    
    func orderViewSetup() {
        self.imageHeaderSegment.titleString = ["Waiting For Delivery", "Shipped", "Arrived"]
        self.imageHeaderSegment.getOrderContent = {index in
            self.getOrderContent(index)
        }
        
        self.imageHeaderSegment.kNavBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        self.imageHeaderSegment.tabBarBottomHeight = self.tabBarController?.tabBar.frame.height ?? 0
        
        let segmentView = self.imageHeaderSegment.segmentedView
        let listContainerView = self.imageHeaderSegment.listContainerView
        segmentView.tag = 100
        listContainerView.tag = 101
        
        self.view.addSubview(segmentView)
        self.view.addSubview(listContainerView)
    }
    
    func removeOrderView() {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.view.viewWithTag(101) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func getOrderContent(_ index: Int) -> JXSegmentedListContainerViewListDelegate {
        if let vc = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderPagingViewController") as? OrderPagingViewController {
            vc.orderStatus = OrderStatus(rawValue: index) ?? .pendingDelivery
            return vc
        }
        
        return OrderPagingViewController()
    }
    
    func loginViewSetup() {
        self.vwLogin.isHidden = false
        self.vwEmpty.isHidden = true
    }
    
    func emptyViewSetup() {
        self.vwEmpty.isHidden = false
        self.vwLogin.isHidden = true
    }
}

