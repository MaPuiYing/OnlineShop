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
    
    func addCart(item: Item?, count: Int) {
        let duplicateId = self.aryCart.filter({
            $0.item?.id == item?.id
        }).first?.id
        
        if let id = duplicateId {
            let oldCart = self.aryCart[id]
            let newCart = Cart(id: oldCart.id, item: oldCart.item, count: (oldCart.count ?? 1) + count)
            self.aryCart[id] = newCart
        } else {
            self.aryCart.append(Cart(id: self.aryCart.count, item: item, count: count))
        }
    }
    
    func deleteCart(id: Int) {
        self.aryCart.remove(at: id)
    }
    
    func updateCount(id: Int, count: Int) {
        let oldCart = self.aryCart[id]
        let newCart = Cart(id: oldCart.id, item: oldCart.item, count: count)
        self.aryCart[id] = newCart
    }
    
    func getCart() -> [Cart] {
        return self.aryCart
    }
}
