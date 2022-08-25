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
    @IBOutlet weak var btnGetMore: ShopButton!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var vwFilter: FilterItemView!
    @IBOutlet weak var lcFilterHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwEmpty: UIView!
    
    let itemModel = ItemModel.shared

    var refreshControl = CustomRefreshControl()
    var cellCount = 0
    var category: ItemCategory?
    var items: [Item] = []
    var filteredItems: [Item] = []
    
    let minPriceConstant = 1.0
    let maxPriceConstant = 1000.0
    var minPrice = Double()
    var maxPrice = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.category?.rawValue ?? "Bookmark"
        self.customBackButton()
        self.collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabbar()
        self.initSetup()
    }
    
    //MARK: - init Set up
    
    func initSetup() {
        self.minPrice = self.minPriceConstant
        self.maxPrice = self.maxPriceConstant
        
        //Refresh Setting
        self.refreshControl.scrollView = self.scrollView
        self.refreshControl.finishAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.refreshPage()
                self?.refreshControl.endRefreshing()
            }
        }
        self.refreshPage()
        
        //Filter View
        self.vwFilter.setupView()
        self.vwFilter.layer.masksToBounds = true
        self.vwFilter.sliderPrice.minimumValue = self.minPriceConstant
        self.vwFilter.sliderPrice.maximumValue = self.maxPriceConstant
        
        self.vwFilter.doneFunc = {[weak self] in
            self?.selectedFilter()
        }
    }
    
    func refreshPage() {
        self.setupData()
        self.cellCount = 0
        self.updateCellCount()
    }
    
    func setupData() {
        self.items = (self.category != nil) ? self.itemModel.getCategoryItem(category) : self.itemModel.getFavioriteItem()
        
        self.navigationBarSetup()
        
        let searchText = self.searchBar.text ?? ""
        if searchText.isEmpty {
            self.filteredItems = self.items
        } else {
            self.filteredItems = self.items.filter({
                $0.title?.localizedCaseInsensitiveContains(searchText) == true
            })
        }
        self.filteredItems = self.filteredItems.filter({
            $0.price ?? self.minPriceConstant >= self.minPrice && $0.price ?? self.maxPriceConstant <= self.maxPrice
        })
        
        self.collectionView.reloadData()
        self.vwEmpty.isHidden = (self.items.count > 0)
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
    
    @IBAction func updateCellCount() {
        let remainCount = self.filteredItems.count - self.cellCount
        self.cellCount += (remainCount<=10) ? remainCount : 10
        self.btnGetMore.isHidden = (self.cellCount == self.filteredItems.count)
        self.collectionView.reloadData()
    }
    
    @objc func filterBtnPressed() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.lcFilterHeight.constant = 200
            self.dimView.isHidden = false
            self.view.layoutIfNeeded()
            
            self.collectionView.isUserInteractionEnabled = false
            
        }, completion: nil)
    }
    
    func selectedFilter() {
        let filteredPrice: [CGFloat] = self.vwFilter.sliderPrice.value
        let firstPrice = filteredPrice.first
        let lastPrice = filteredPrice.last
        if firstPrice != self.minPrice || lastPrice != self.maxPrice {
            self.minPrice = firstPrice ?? self.minPriceConstant
            self.maxPrice = lastPrice ?? self.maxPriceConstant
            self.refreshPage()
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.lcFilterHeight.constant = 0
            self.dimView.isHidden = true
            self.view.layoutIfNeeded()
            
            self.collectionView.isUserInteractionEnabled = true
        }, completion: nil)
    }
}

//MARK: - UISearchBar Delegate

extension CategoryItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.refreshPage()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.refreshPage()
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
        cell.imvBanner.sd_setImage(with: URL(string: model.imageURL ?? ""), completed: nil)
        cell.lbTitle.text = model.title
        cell.lblPrice.text = model.price?.stringValue
        if model.isDiscount == true {
            cell.setupOriginalPrice(model.oldPrice?.stringValue)
        }
        
        cell.isBookmarks = itemModel.getFaviorite(model.id)
        cell.imvBookmarks.method = {[weak self] in
            cell.isBookmarks = !cell.isBookmarks
            self?.itemModel.setFaviorite(model.id, value: cell.isBookmarks)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
            vc.itemDetail = self.filteredItems[indexPath.row]
            vc.isAllowEdit = true
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
