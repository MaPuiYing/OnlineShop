//
//  CartModel.swift
//  pigShop
//
//  Created by Joyce Ma on 14/3/2022.
//

import Foundation

struct Cart {
    let id: Int?
    let item: Item?
    let count: Int?
}

class CartModel {
    
    static let shared = CartModel()
    var aryCart: [Cart] = []
    var id: Int = 1
    
    //MARK: - Get Item
    
    func getCart() -> [Cart] {
        return self.aryCart
    }
    
    //MARK: - Get Object
    func isDuplicate(item: Item?) -> Bool {
        let isDuplicate = self.aryCart.filter({
            $0.item?.id == item?.id
        }).isEmpty
        return isDuplicate
    }
    
    //MARK: - Edit Object
    func addCart(item: Item?, count: Int) {
        let duplicateId = self.aryCart.filter({
            $0.item?.id == item?.id
        }).first?.id
        
        if let id = duplicateId {
            let index = self.aryCart.firstIndex(where: {$0.id == id}) ?? 0
            let oldCart = self.aryCart[index]
            let newCart = Cart(id: oldCart.id, item: oldCart.item, count: (oldCart.count ?? 1) + count)
            self.aryCart[index] = newCart
        } else {
            self.aryCart.append(Cart(id: self.id, item: item, count: count))
            self.id += 1
        }
    }
    
    func deleteCart(id: Int) {
        let index = self.aryCart.firstIndex(where: {$0.id == id}) ?? 0
        self.aryCart.remove(at: index)
    }
    
    func updateCount(id: Int, count: Int) {
        let index = self.aryCart.firstIndex(where: {$0.id == id}) ?? 0
        let oldCart = self.aryCart[index]
        let newCart = Cart(id: oldCart.id, item: oldCart.item, count: count)
        self.aryCart[index] = newCart
    }
}
