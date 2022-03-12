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
    
    @IBOutlet weak var lblNew: UILabel!
    @IBOutlet weak var lblSales: UILabel!
    @IBOutlet weak var vwBorder: UIView!
    
    var refreshControl = CustomRefreshControl()
    
    var aryRecommendImage: [String] {
        var image: [String] = []
        image.append("https://media.karousell.com/media/photos/products/2021/3/20/lulu_lulupig__1616207256_0e9b6ccb_progressive.jpg")
        image.append("https://www.price.com.hk/space/ec_product/shop/192000/192863_kd2nuj_0.jpg")
        image.append("https://media.karousell.com/media/photos/products/2020/9/22/lulupig_lulu____1600744315_4bd23683_progressive.jpg")
        return image
    }
    
    var aryFilter: [String] = ["New", "Hot", "Clothes", "Dress", "Shoe", "Food", "Item", "Others"]
    var aryTitle: [String] = ["純色修身吊帶背心", "中毒褲ver.棉直筒褲 (彈力,高腰)", "日常無褶皺襯衫 (基本款,襯衫)", "寬鬆版柔軟襯衫", "HIGH&WIDE西裝長褲", "半高腰Q彈休閒褲ver.直筒 (彈力棉5%)"]
    
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
        
        //Refresh Setting
        self.refreshControl.scrollView = self.scrollView
        self.refreshControl.pullingAction = { [weak self] in
            self?.vwRecommend.stopTimer()
        }
        self.refreshControl.finishAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let mySelf = self else {return}
                mySelf.recommendViewSetup()
                mySelf.refreshControl.endRefreshing()
            }
        }
        
        //Set up
        self.recommendViewSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vwRecommend.stopTimer()
    }
    
    //MARK: - Init set up
    
    func initSetup() {
        self.lblNew.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.lblNew.backgroundColor = .white
        self.lblNew.textColor = .textGrey
        
        self.lblSales.font = UIFont.systemFont(ofSize: 10)
        self.lblSales.backgroundColor = .white
        self.lblSales.textColor = .textLightGrey
        
        let space = "    "
        self.lblNew.text = space + "Special Items" + space
        self.lblSales.text = space + "PLEASE TAKING THE CHANCE" + space
        
        self.vwBorder.layer.cornerRadius = 10
        self.vwBorder.layer.borderColor = UIColor.borderSecondary.cgColor
        self.vwBorder.layer.borderWidth = 1
    }
    
    func navigationBarSetup() {
        let bookmarks = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarksBtnPressed))
        bookmarks.tintColor = .textDarkGrey
        bookmarks.imageInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnPressed))
        search.tintColor = .textDarkGrey
        search.imageInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        self.navigationItem.rightBarButtonItems = [bookmarks, search]
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
        
    }
    
    @objc func searchBtnPressed() {
        
    }
    
    func recommendSelectedAction(_ selectRow: Int) {
        NSLog("recommend select: \(selectRow)")
    }
}

//MARK: - UICollectionView delegate & dataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clvCategory {
            return self.aryFilter.count
        } else if collectionView == self.clvItem {
            return self.aryTitle.count
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
            cell.lblTitle.text = self.aryFilter[indexPath.row]
            return cell
        } else if collectionView == self.clvItem {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell else {return UICollectionViewCell()}
            cell.lblTitle.text = self.aryTitle[indexPath.row]
            cell.lblPrice.text = "HKD$1000"
            cell.imvBanner.sd_setImage(with: URL(string: "https://www.price.com.hk/space/ec_product/shop/192000/192863_kd2nuj_0.jpg"), completed: nil)
            cell.setupOriginalPrice("HKD$1193")
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.clvCategory {
            NSLog("category select: \(indexPath.row)")
        } else if collectionView == self.clvItem {
            NSLog("item select: \(indexPath.row)")
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
            
            let doubleRows = Double(self.aryTitle.count) / 2
            let rows: CGFloat = CGFloat(lround(doubleRows))
            let collectionHeight = Util.calculateCollectionHeight(height: height, rows: rows, rowSpace: 15)
            self.lcItemHeight.constant = collectionHeight
            return CGSize(width: width, height: height)
        }
        return .zero
    }
}
