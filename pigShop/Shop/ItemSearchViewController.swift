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
    @IBOutlet weak var lblEmpty: UILabel!
    
    let itemModel = ItemModel.shared
    var items: [Item] = []
    var filteredItems: [Item] = []
    
    var refreshControl = CustomRefreshControl()
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        self.customBackButton()
        
        self.initSetup()
        self.tableViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Refresh Setting
        self.refreshControl.scrollView = self.table
        self.refreshControl.finishAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.refreshPage()
                self?.refreshControl.endRefreshing()
            }
        }
        self.refreshPage()
    }
    
    //MARK: - Init set up
    
    func initSetup() {
        self.lblEmpty.textColor = .textLightGrey
        self.lblEmpty.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        self.lblEmpty.text = "Sorry, it is empty."
    }
    
    func tableViewSetup() {
        self.table.register(UINib(nibName: "ItemSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        
        self.searchBar.frame = CGRect(x: 0, y: 0, width: self.table.frame.width, height: 70)
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.tintColor = .darkRed
        self.searchBar.placeholder = "Search the item name"
        self.searchBar.sizeToFit()
        self.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        self.table.tableHeaderView = self.searchBar
    }
    
    func navigationBarSetup() {
        guard self.items.count > 0 else {return}
            
        let filter = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),style: .plain, target: self, action: #selector(filterBtnPressed))
        filter.tintColor = .textDarkGrey
            
        self.navigationItem.rightBarButtonItem = filter
    }
    
    func refreshPage() {
        self.items = itemModel.getAllItem()
        self.table.reloadData()
        
        self.navigationBarSetup()
        
        let searchText = searchBar.text ?? ""
        if searchText.isEmpty {
            self.filteredItems = self.items
        } else {
            self.filteredItems = self.items.filter({
                $0.title?.localizedCaseInsensitiveContains(searchText) == true
            })
        }
        self.vwEmpty.isHidden = (self.items.count > 0)
    }
    
    //MARK: - Button action
    
    func goToDetailPage(_ row: Int) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
            vc.itemDetail = self.filteredItems[row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func filterBtnPressed() {
        NSLog("filter")
    }
}

//MARK: - UISearchBar Delegate

extension ItemSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredItems = self.items
        } else {
            self.filteredItems = self.items.filter({
                $0.title?.localizedCaseInsensitiveContains(searchText) == true
            })
        }
        self.table.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        
        if searchText.isEmpty {
            self.filteredItems = self.items
        } else {
            self.filteredItems = self.items.filter({
                $0.title?.localizedCaseInsensitiveContains(searchText) == true
            })
        }
        self.table.reloadData()
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
