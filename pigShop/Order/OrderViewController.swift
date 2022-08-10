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
    @IBOutlet weak var lblLogin: UILabel!
    
    @IBOutlet weak var vwEmpty: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    
    var userModel = UserModel.shared
    var orderModel = OrderModel.shared
        
    //Title
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.titles = ["Waiting For Delivery", "Shipped", "Confirm Received"]
        ds.titleNormalColor = .textLightGrey
        ds.titleSelectedColor = .mainOrange
        ds.titleNormalFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        ds.titleSelectedFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        ds.isTitleColorGradientEnabled = true
        return ds
    }()
    
    //Indicator line
    lazy var sliderView: JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorColor = .mainOrange
        view.indicatorHeight = 2
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Order"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vwLogin.isHidden = true
        self.vwEmpty.isHidden = true
        self.orderViewSetup()
        
//        self.userModel = UserModel.shared
//        self.orderModel = OrderModel.shared
//
//        if self.userModel.isLogined() == false {
//            self.loginViewSetup()
//        } else {
//            if let userId = self.userModel.getUser()?.id, let order = self.orderModel.getUserOrder(userId), order.count != 0 {
//                self.vwLogin.isHidden = true
//                self.vwEmpty.isHidden = true
//                self.orderViewSetup()
//            } else {
//                self.emptyViewSetup()
//            }
//        }
    }
    
    func orderViewSetup() {
        let kNavBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0

        //Container View
        let containerView = JXSegmentedListContainerView(dataSource: self)
        containerView.frame = CGRect(x: 0, y: kNavBarHeight + self.topSafeAreaHeight + 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - kNavBarHeight - 50 - self.topSafeAreaHeight - self.bottomSafeAreaHeight)
        self.view.addSubview(containerView)

        //Segment View
        let segmentView = JXSegmentedView(frame: CGRect(x: 0, y: kNavBarHeight + self.topSafeAreaHeight, width: UIScreen.main.bounds.width, height: 40))
        segmentView.dataSource = self.segmentedDataSource
        segmentView.listContainer = containerView
        segmentView.indicators = [self.sliderView]
        segmentView.delegate = self
        segmentView.backgroundColor = .tabbarBackground
        self.view.addSubview(segmentView)
    }
    
    func loginViewSetup() {
        vwLogin.isHidden = false
        vwEmpty.isHidden = true
        
        lblLogin.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lblLogin.textColor = .textDarkGrey
        lblLogin.text = "You cannot read it since you have not yet logged in your account."
    }
    
    func emptyViewSetup() {
        vwEmpty.isHidden = false
        vwLogin.isHidden = true
        
        lblEmpty.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        lblEmpty.textColor = .textLightGrey
        lblEmpty.text = "Your order list is empty."
    }
}

//MARK: - JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource

extension OrderViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return self.segmentedDataSource.titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return OrderPagingViewController()
    }
}
