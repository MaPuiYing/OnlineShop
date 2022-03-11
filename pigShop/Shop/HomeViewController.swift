//
//  HomeViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet weak var vwRecommend: RecommendView!
    @IBOutlet weak var clvCategory: UICollectionView!
    @IBOutlet weak var lcCategoryHeight: NSLayoutConstraint!
    
    var aryRecommendImage: [String] {
        var image: [String] = []
        image.append("https://media.karousell.com/media/photos/products/2021/3/20/lulu_lulupig__1616207256_0e9b6ccb_progressive.jpg")
        image.append("https://www.price.com.hk/space/ec_product/shop/192000/192863_kd2nuj_0.jpg")
        image.append("https://media.karousell.com/media/photos/products/2020/9/22/lulupig_lulu____1600744315_4bd23683_progressive.jpg")
        return image
    }
    
    var aryFilter: [String] = ["New", "Hot", "Clothes", "Dress", "Shoe", "Food", "Item", "Others"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Pig Pig Shop"
        self.collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwRecommend.aryImage = aryRecommendImage
        self.vwRecommend.action = { selectRow in
            self.recommendSelectedAction(selectRow)
        }
        self.vwRecommend.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.vwRecommend.stopTimer()
    }
    
    func collectionViewSetup() {
        self.clvCategory.register(UINib(nibName: "CategorySelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        self.clvCategory.reloadData()
    }
    
    //MARK: - Button Action
    
    func recommendSelectedAction(_ selectRow: Int) {
        NSLog("recommend select: \(selectRow)")
    }
}

//MARK: - UICollectionView delegate & dataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clvCategory {
            return self.aryFilter.count
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
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.clvCategory {
            NSLog("category select: \(indexPath.row)")
        }
    }
}

//MARK: - UICollectionView layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.clvCategory {
            let columns = 4, rows = 2, columnSpace = 30, rowSpace = 15
            let columnSpacing = columnSpace * (columns-1)
            let rowSpacing = rowSpace * (rows-1)
            
            let width = (Int(collectionView.frame.width) - columnSpacing) / columns
            let height = width + 17 + 4 // label size 17 + stackView spacing 4
            self.lcCategoryHeight.constant = CGFloat(height*2 + rowSpacing)
            
            return CGSize(width: width, height: height)
        }
        return .zero
    }
}
