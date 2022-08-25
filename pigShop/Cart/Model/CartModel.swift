//
//  CartModel.swift
//  pigShop
//
//  Created by Joyce Ma on 14/3/2022.
//

import Foundation

struct Cart {
    let id: Int?
    var itemID: Int?
    var count: Int?
    var isChecked: Bool?
}

class CartModel {
    
    static let shared = CartModel()
    var aryCart: [Cart] = []
    var id: Int = 1
    
    //MARK: - Get Cart
    
    func getCart() -> [Cart] {
        return self.aryCart
    }
    
    //MARK: - Get Object
    
    func isDuplicate(item: Item?) -> Bool {
        let isDuplicate = self.aryCart.filter({
            $0.itemID == item?.id
        }).isEmpty
        return isDuplicate
    }
    
    //MARK: - Edit Object
    
    func addCart(itemID: Int?, count: Int, success: @escaping (()->Void), failure: @escaping (()->Void)) {
        let duplicateId = self.aryCart.filter({
            $0.itemID == itemID
        }).first?.id
        
        if let id = duplicateId {
            let index = self.getCartIndex(id)
            let oldCart = self.aryCart[index]
            let newCount = (oldCart.count ?? 1) + count
            if newCount < 10 {
                let newCart = Cart(id: oldCart.id, itemID: oldCart.itemID, count: newCount, isChecked: true)
                self.aryCart[index] = newCart
                success()
            } else {
                let newCart = Cart(id: oldCart.id, itemID: oldCart.itemID, count: 9, isChecked: true)
                self.aryCart[index] = newCart
                failure()
            }
        } else {
            self.aryCart.append(Cart(id: self.id, itemID: itemID, count: count, isChecked: true))
            self.id += 1
            success()
        }
    }
    
    func deleteCart(id: Int) {
        let index = self.getCartIndex(id)
        self.aryCart.remove(at: index)
    }
    
    func updateCount(id: Int, count: Int) {
        let index = self.getCartIndex(id)
        var newCart = self.aryCart[index]
        newCart.count = count
        self.aryCart[index] = newCart
    }
    
    func updateChecked(id: Int, isChecked: Bool) {
        let index = self.getCartIndex(id)
        let oldCart = self.aryCart[index]
        let newCart = Cart(id: oldCart.id, itemID: oldCart.itemID, count: oldCart.count, isChecked: isChecked)
        self.aryCart[index] = newCart
    }
    
    //MARK: - Get Index
    
    func getCartIndex(_ id: Int) -> Int {
        return self.aryCart.firstIndex(where: {$0.id == id}) ?? 0
    }
}
