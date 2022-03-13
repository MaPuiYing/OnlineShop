//
//  ItemModel.swift
//  pigShop
//
//  Created by Joyce Ma on 13/3/2022.
//

import Foundation

enum ItemCategory: String, CaseIterable, Decodable {
    case new = "New"
    case hot = "Hot"
    case clothes = "Clothes"
    case dress = "Dress"
    case shoe = "Shoe"
    case food = "Food"
    case item = "Item"
    case others = "Others"
}

struct Item: Decodable {
    let id: Int?
    let imageURL: String?
    let title: String?
    let description: String?
    let price: Double?
    let oldPrice: Double?
    let category: ItemCategory?
    let isDiscount: Bool?
    let isFavorite: Bool?
}

struct ItemJson: Decodable {
    let item: [Item]?
}

struct FavoriteModel {
    var id: Int?
    var isFavorite: Bool?
}

class ItemModel {
    static let shared = ItemModel()
    
    var aryItem: [Item] = []
    var aryFavorite: [FavoriteModel] = []
    
    init() {
        self.aryItem = self.getAllItem()
        for item in self.aryItem {
            self.aryFavorite.append(FavoriteModel(id: item.id ?? 0, isFavorite: false))
        }
    }
    
    //MARK: - Get Item
    
    func getAllItem() -> [Item] {
        if let path = Bundle.main.path(forResource: "item", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let result = try JSONDecoder().decode(ItemJson.self, from: data)
                return result.item ?? []

            } catch {
                // handle error
            }
        }
        return []
    }
    
    func getDiscountItem() -> [Item] {
        let item = self.aryItem.filter({
            $0.isDiscount == true
        })
        return item
    }
    
    //MARK: - Get Object
    
    func getFavioriteItem() -> [Item] {
        let favoriteItems = self.aryFavorite.filter({$0.isFavorite == true})
        let item = self.aryItem.filter({
            for favoriteItem in favoriteItems {
                if $0.id == favoriteItem.id {return true}
            }
            return false
        })
        
        return item
    }
    
    func getCategoryItem(_ category: ItemCategory?) -> [Item] {
        let item = self.aryItem.filter({
            $0.category == category
        })
        return item
    }
    
    func getFaviorite(_ id: Int?) -> Bool {
        if let index = self.aryFavorite.firstIndex(where: {$0.id == id}) {
            return self.aryFavorite[index].isFavorite ?? false
        }
        return false
    }
    
    //MARK: - Set Object
    
    func setFaviorite(_ id: Int?, value: Bool) {
        if let index = self.aryFavorite.firstIndex(where: {$0.id == id}) {
            self.aryFavorite[index].isFavorite = value
        }
    }
}
