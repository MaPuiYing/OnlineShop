//
//  CategoryItemViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 12/3/2022.
//

import UIKit

class CategoryItemViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lcItemHeight: NSLayoutConstraint!

    var refreshControl = CustomRefreshControl()
    
    var aryTitle: [String] = ["I am the pig pig girl", "Pig is toxic", "Daily pig in a pig pig world", "Pig pig is good girl thanks", "Pig love pink", "Why am pig pig girl so pretty cant you answer me", "I am the pig pig girl", "Pig is toxic", "Daily pig in a pig pig world", "Pig pig is good girl thanks", "Pig love pink", "Why am pig pig girl so pretty cant you answer me", "I am the pig pig girl", "Pig is toxic", "Daily pig in a pig pig world", "Pig pig is good girl thanks", "Pig love pink"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Category"
        self.customBackButton()
        
        self.navigationBarSetup()
        self.collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Refresh Setting
        self.refreshControl.scrollView = self.scrollView
        self.refreshControl.finishAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    //MARK: - init Set up
    
    func collectionViewSetup() {
        self.collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemCell")
        self.collectionView.reloadData()
    }
    
    func navigationBarSetup() {
        let filter = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),style: .plain, target: self, action: #selector(filterBtnPressed))
        filter.tintColor = .textDarkGrey
        
        self.navigationItem.rightBarButtonItem = filter
    }
    
    //MARK: - Button Action
    
    @objc func filterBtnPressed() {
        NSLog("filter button pressed")
    }
}

extension CategoryItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.aryTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell else {return UICollectionViewCell()}
        cell.lblTitle.text = self.aryTitle[indexPath.row]
        cell.lblPrice.text = "HKD$560"
        cell.imvBanner.sd_setImage(with: URL(string: "https://media.karousell.com/media/photos/products/2020/9/22/lulupig_lulu____1600744315_4bd23683_progressive.jpg"), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("item select: \(indexPath.row)")
    }
}

extension CategoryItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Util.calculateItemWidth(columns: 2, columnSpace: 10, frameWidth: collectionView.frame.width)
        let height = (width*1.2) + 34 + 35 + 6 // title 34 + price 35 + stackView spacing 6
        
        let doubleRows = Double(self.aryTitle.count) / 2
        let rows: CGFloat = CGFloat(lround(doubleRows))
        let collectionHeight = Util.calculateCollectionHeight(height: height, rows: rows, rowSpace: 15)
        self.lcItemHeight.constant = collectionHeight
        
        return CGSize(width: width, height: height)
    }
}
