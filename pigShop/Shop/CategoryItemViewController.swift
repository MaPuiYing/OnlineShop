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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var vwKnowMore: ViewButton!
    @IBOutlet weak var lblKnowMore: UILabel!
    
    @IBOutlet weak var vwEmpty: UIView!
    @IBOutlet weak var lblEmpty: UILabel!

    var refreshControl = CustomRefreshControl()
    var cellCount = 0
    var category: ItemCategory = .new
    var items: [Item] = []
    var filteredItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.category.rawValue
        self.customBackButton()
        
        self.initSetup()
        self.collectionViewSetup()
        
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Refresh Setting
        self.refreshControl.scrollView = self.scrollView
        self.refreshControl.finishAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let mySelf = self else {return}
                mySelf.setupData()
                
                mySelf.cellCount = 0
                mySelf.updateCellCount()
                mySelf.refreshControl.endRefreshing()
            }
        }
        
        self.cellCount = 0
        self.updateCellCount()
    }
    
    //MARK: - init Set up
    
    func initSetup() {
        self.view.layoutIfNeeded()
        self.vwKnowMore.backgroundColor = .btnOrange
        self.vwKnowMore.layer.cornerRadius = self.vwKnowMore.bounds.height/2
        self.vwKnowMore.method = {self.updateCellCount()}

        self.lblKnowMore.textColor = .white
        self.lblKnowMore.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.lblKnowMore.text = "Know More"
        
        self.lblEmpty.textColor = .textLightGrey
        self.lblEmpty.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        self.lblEmpty.text = "Sorry, it is empty."
    }
    
    func setupData() {
        self.items = ItemModel.shared.getCategoryItem(category)
        self.filteredItems = self.items
        self.collectionView.reloadData()
        self.vwEmpty.isHidden = (self.items.count > 0)
        self.navigationBarSetup()
    }
    
    func navigationBarSetup() {
        guard self.items.count > 0 else {return}
        
        let filter = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),style: .plain, target: self, action: #selector(filterBtnPressed))
        filter.tintColor = .textDarkGrey
        
        self.navigationItem.rightBarButtonItem = filter
    }
    
    func collectionViewSetup() {
        self.collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "itemCell")
    }
    
    //MARK: - Button Action
    
    @objc func filterBtnPressed() {
        NSLog("filter button pressed")
    }
    
    func updateCellCount() {
        let remainCount = self.filteredItems.count - self.cellCount
        self.cellCount += (remainCount<=10) ? remainCount : 10
        self.vwKnowMore.isHidden = (self.cellCount == self.filteredItems.count)
        self.collectionView.reloadData()
    }
}

//MARK: - UISearchBar Delegate

extension CategoryItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredItems = self.items
        } else {
            self.filteredItems = self.items.filter({
                $0.title?.localizedCaseInsensitiveContains(searchText) == true
            })
        }
        
        self.updateCellCount()
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        
        if searchText == "" {
            self.filteredItems = self.items
        } else {
            self.filteredItems = self.items.filter({
                $0.title?.localizedCaseInsensitiveContains(searchText) == true
            })
        }
        
        self.updateCellCount()
        self.collectionView.reloadData()
    }
}

//MARK: - UICollectionView Delegate

extension CategoryItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell else {return UICollectionViewCell()}
        let model = self.filteredItems[indexPath.row]
        cell.lblTitle.text = model.title
        cell.lblPrice.text = model.price?.stringValue
        if model.isDiscount == true {
            cell.setupOriginalPrice(model.oldPrice?.stringValue)
        }
        cell.imvBanner.sd_setImage(with: URL(string: model.imageURL ?? ""), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
            vc.itemDetail = self.filteredItems[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CategoryItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Util.calculateItemWidth(columns: 2, columnSpace: 10, frameWidth: collectionView.frame.width)
        let height = (width*1.2) + 34 + 35 + 6 // title 34 + price 35 + stackView spacing 6
        
        let doubleRows = Double(self.cellCount) / 2
        let rows: CGFloat = CGFloat(lround(doubleRows))
        let collectionHeight = Util.calculateCollectionHeight(height: height, rows: rows, rowSpace: 15)
        self.lcItemHeight.constant = collectionHeight
        
        return CGSize(width: width, height: height)
    }
}
