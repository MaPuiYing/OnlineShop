//
//  OrderDetailViewController.swift
//  pigShop
//
//  Created by Pui Ying Ma on 17/8/2022.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var btnClose: ImageButton!
    @IBOutlet weak var clvItem: UICollectionView!
    @IBOutlet weak var lcItemHeight: NSLayoutConstraint!
    @IBOutlet weak var vwTotalPrice: UIView!
    @IBOutlet weak var vwShippingInfo: UIView!
    
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.initSetup()
    }
    
    func initSetup() {
        self.btnClose.method = {[weak self] in self?.dismiss(animated: true, completion: nil) }
        self.collectionViewSetup()
        
        self.clvItem.layer.cornerRadius = 8
        self.vwTotalPrice.layer.cornerRadius = 8
        self.vwShippingInfo.layer.cornerRadius = 8
        
        self.setupContent()
    }
    
    func setupContent() {
        self.lblOrderNo.text = "\(self.order?.id ?? 0)"
        self.lblStatus.text = self.order?.status?.getText()
        self.lblTotalPrice.text = self.order?.totalPrice?.stringValue
        if let firstName = self.order?.firstName, let lastName = self.order?.lastName {
            self.lblName.text = "\(firstName), \(lastName)"
        }
        self.lblAddress.text = self.order?.address
        self.lblCity.text = self.order?.city
    }
    
    func collectionViewSetup() {
        self.clvItem.register(UINib(nibName: "OrderItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemCell")
        self.clvItem.reloadData()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension OrderDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.order?.allItem?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? OrderItemCollectionViewCell else {return UICollectionViewCell()}
        if let cart = self.order?.allItem?[indexPath.row], let item = cart.item {
            cell.imvBanner.sd_setImage(with: URL(string: item.imageURL ?? ""))
            cell.lblTitle.text = item.title
            cell.lblPrice.text = item.price?.stringValue
            cell.lblCount.text = "x \(cart.count ?? 1)"
        }
        return cell
    }
    
    
}

//MARK: - UICollectionView layout

extension OrderDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = CGFloat(self.order?.allItem?.count ?? 0)
        let collectionHeight = Util.calculateCollectionHeight(height: 120, rows: row, rowSpace: 0)
        self.lcItemHeight.constant = collectionHeight
        return CGSize(width: self.clvItem.frame.width - 30, height: 120)
    }
}
