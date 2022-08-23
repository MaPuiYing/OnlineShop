//
//  HomeViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var vwRecommend: RecommendView!
    @IBOutlet weak var clvCategory: UICollectionView!
    @IBOutlet weak var clvItem: UICollectionView!
    @IBOutlet weak var lcCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var lcItemHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lbNew: UILabel!
    @IBOutlet weak var lbSales: UILabel!
    @IBOutlet weak var vwBorder: UIView!
    
    let itemModel = ItemModel.shared
    var specialItems: [Item] = []
    
    var refreshControl = CustomRefreshControl()
    
    var aryRecommendImage: [String] {
        var image: [String] = []
        image.append("https://media.karousell.com/media/photos/products/2021/3/20/lulu_lulupig__1616207256_0e9b6ccb_progressive.jpg")
        image.append("https://www.price.com.hk/space/ec_product/shop/192000/192863_kd2nuj_0.jpg")
        image.append("https://media.karousell.com/media/photos/products/2020/9/22/lulupig_lulu____1600744315_4bd23683_progressive.jpg")
        return image
    }
    var aryCategory = ItemCategory.allCases
    
    var itemSize: CGSize = .zero
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pig Pig Shop"
        
        self.initSetup()
        self.navigationBarSetup()
        self.collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showTabbar()
        
        //Refresh Setting
        self.refreshControl.scrollView = self.scrollView
        self.refreshControl.pullingAction = { [weak self] in
            self?.vwRecommend.stopTimer()
        }
        self.refreshControl.finishAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.refreshPage()
            }
        }
        
        //Set up
        self.refreshPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vwRecommend.stopTimer()
    }
    
    //MARK: - init Set up
    
    func refreshPage() {
        self.recommendViewSetup()
        self.specialItems = self.itemModel.getDiscountItem()
        self.clvItem.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func initSetup() {
        let space = "    "
        self.lbNew.text = space + "Special Items" + space
        self.lbSales.text = space + "PLEASE TAKING THE CHANCE" + space
        
        self.vwBorder.layer.cornerRadius = 10
        self.vwBorder.layer.borderColor = UIColor.borderSecondary.cgColor
        self.vwBorder.layer.borderWidth = 1
    }
    
    func navigationBarSetup() {
        let bookmarks = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarksBtnPressed))
        bookmarks.tintColor = .textDarkGrey
        bookmarks.imageInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnPressed))
        search.tintColor = .textDarkGrey
        search.imageInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        self.navigationItem.rightBarButtonItems = [search, bookmarks]
    }
    
    func collectionViewSetup() {
        self.clvCategory.register(UINib(nibName: "CategorySelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        self.clvItem.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemCell")
        self.clvCategory.reloadData()
        self.clvItem.reloadData()
    }
    
    func recommendViewSetup() {
        self.vwRecommend.aryImage = self.aryRecommendImage
        self.vwRecommend.action = { selectRow in
            self.recommendSelectedAction(selectRow)
        }
        self.vwRecommend.setupView()
    }
    
    //MARK: - Button Action
    
    @objc func bookmarksBtnPressed() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryItemViewController") as? CategoryItemViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func searchBtnPressed() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemSearchViewController") as? ItemSearchViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func recommendSelectedAction(_ selectRow: Int) {
        NSLog("recommend select: \(selectRow)")
    }
}

//MARK: - UICollectionView delegate & dataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clvCategory {
            return self.aryCategory.count
        } else if collectionView == self.clvItem {
            return self.specialItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.clvCategory {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategorySelectionCollectionViewCell else {return UICollectionViewCell()}
            cell.setupView()
            
            if indexPath.row == 0 {
                cell.setBackground(.btnOrange)
            } else if indexPath.row == 1 {
                cell.setBackground(.btnPink)
            }
            
            let category = self.aryCategory[indexPath.row]
            cell.lblTitle.text = category.rawValue
            cell.imvIcon.image = UIImage(named: "home_\(category)")
            return cell
        } else if collectionView == self.clvItem {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell else {return UICollectionViewCell()}
            let model = self.specialItems[indexPath.row]
            cell.lbTitle.text = model.title
            cell.lblPrice.text = model.price?.stringValue
            cell.imvBanner.sd_setImage(with: URL(string: model.imageURL ?? ""), completed: nil)
            cell.setupOriginalPrice(model.oldPrice?.stringValue)
            
            cell.isBookmarks = itemModel.getFaviorite(model.id)
            cell.imvBookmarks.method = {[weak self] in
                cell.isBookmarks = !cell.isBookmarks
                self?.itemModel.setFaviorite(model.id, value: cell.isBookmarks)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.clvCategory {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryItemViewController") as? CategoryItemViewController {
                vc.category = self.aryCategory[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if collectionView == self.clvItem {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
                vc.itemDetail = self.specialItems[indexPath.row]
                vc.isAllowEdit = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

//MARK: - UICollectionView layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.clvCategory {
            let width = Util.calculateItemWidth(columns: 4, columnSpace: 25, frameWidth: collectionView.frame.width)
            let height = width + 17 + 4 // label size 17 + stackView spacing 4
            self.lcCategoryHeight.constant = Util.calculateCollectionHeight(height: height, rows: 2, rowSpace: 15)
            
            return CGSize(width: width, height: height)
        } else if collectionView == self.clvItem {
            let width = Util.calculateItemWidth(columns: 2, columnSpace: 10, frameWidth: collectionView.frame.width)
            let height = (width*1.2) + 34 + 35 + 6 // title 34 + price 35 + stackView spacing 6
            
            let doubleRows = Double(self.specialItems.count) / 2
            let rows: CGFloat = CGFloat(lround(doubleRows))
            let collectionHeight = Util.calculateCollectionHeight(height: height, rows: rows, rowSpace: 15)
            self.lcItemHeight.constant = collectionHeight
            return CGSize(width: width, height: height)
        }
        return .zero
    }
}
