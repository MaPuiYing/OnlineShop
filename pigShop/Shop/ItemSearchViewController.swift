//
//  ItemSearchViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 13/3/2022.
//

import UIKit

class ItemSearchViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var vwEmpty: UIView!
    @IBOutlet weak var vwFilter: FilterItemView!
    @IBOutlet weak var lcFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var dimView: UIView!
    
    let itemModel = ItemModel.shared
    var items: [Item] = []
    var filteredItems: [Item] = []
    var minPrice = Double()
    var maxPrice = Double()
    
    var refreshControl = CustomRefreshControl()
    let searchBar = UISearchBar()
    let minPriceConstant = 1.0
    let maxPriceConstant = 1000.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        
        self.customBackButton()
        self.tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabbar()
        self.initSetup()
    }
    
    //MARK: - Init set up
    
    func initSetup() {
        self.minPrice = self.minPriceConstant
        self.maxPrice = self.maxPriceConstant
        
        //Refresh Setting
        self.refreshControl.scrollView = self.table
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
    
    func tableViewSetup() {
        self.table.register(UINib(nibName: "ItemSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.tintColor = .darkRed
        self.searchBar.placeholder = "Search the item name"
        self.searchBar.sizeToFit()
        self.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        self.navigationItem.titleView = searchBar
    }
    
    func navigationBarSetup() {
        guard self.items.count > 0 else {return}
            
        let filter = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),style: .plain, target: self, action: #selector(self.filterBtnPressed))
        filter.tintColor = .textDarkGrey
            
        self.navigationItem.rightBarButtonItem = filter
    }
    
    func refreshPage() {
        self.items = self.itemModel.getAllItem()
        self.navigationBarSetup()
        
        let searchText = searchBar.text ?? ""
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
        
        self.vwEmpty.isHidden = (self.items.count > 0)
        
        self.table.reloadData()
    }
    
    //MARK: - Button action
    
    func goToDetailPage(_ row: Int) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
            vc.itemDetail = self.filteredItems[row]
            vc.isAllowEdit = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func filterBtnPressed() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.lcFilterHeight.constant = 200
            self.dimView.isHidden = false
            self.view.layoutIfNeeded()
            
            self.table.isUserInteractionEnabled = false
            
        }, completion: nil)
    }
    
    func selectedFilter() {
        let filteredPrice: [CGFloat] = self.vwFilter.sliderPrice.value
        self.minPrice = filteredPrice.first ?? self.minPriceConstant
        self.maxPrice = filteredPrice.last ?? self.maxPriceConstant
        self.refreshPage()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.lcFilterHeight.constant = 0
            self.dimView.isHidden = true
            self.view.layoutIfNeeded()
            
            self.table.isUserInteractionEnabled = true
        }, completion: nil)
    }
}

//MARK: - UISearchBar Delegate

extension ItemSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.refreshPage()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.refreshPage()
    }
}

//MARK: - UITableView DataSource

extension ItemSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredItems.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? ItemSearchTableViewCell else {return UITableViewCell()}
        let model = self.filteredItems[indexPath.row]
        cell.imvBanner.sd_setImage(with: URL(string: model.imageURL ?? ""), completed: nil)
        cell.lblTitle.text = model.title
        cell.lblPrice.text = model.price?.stringValue
        if model.isDiscount == true {
            cell.setupOriginalPrice(model.oldPrice?.stringValue)
        }
        
        cell.isBookmarks = itemModel.getFaviorite(model.id)
        cell.imvBookmarks.method = {[weak self] in
            cell.isBookmarks = !cell.isBookmarks
            self?.itemModel.setFaviorite(model.id, value: cell.isBookmarks)
        }
        cell.action = {
            self.goToDetailPage(indexPath.row)
        }
        
        return cell
    }
}
