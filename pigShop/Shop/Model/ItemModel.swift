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
}

struct ItemJson: Decodable {
    let item: [Item]?
}

class ItemModel {
    static let shared = ItemModel()
    var aryItem: [Item] = []
    
    init() {
        self.aryItem = self.getAllItem()
    }
    
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
    
    func getCategoryItem(_ category: ItemCategory) -> [Item] {
        let item = self.aryItem.filter({
            $0.category == category
        })
        return item
    }
}
