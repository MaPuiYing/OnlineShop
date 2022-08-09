//
//  OrderModel.swift
//  pigShop
//
//  Created by Pui Ying Ma on 9/8/2022.
//

import Foundation

//enum PaymentMethod {
//    case googlePay
//    case paypal
//    case creditCard
//}

struct Order {
    let id: Int?
    var userId: Int?
    var firstName: String?
    var lastName: String?
    var address: String?
    var city: String?
    var paymentMethod: Int?
    var allItem: [Cart]?
    var totalPrice: Double?
}

class OrderModel {
    static let shared = OrderModel()
    var aryOrder: [Order] = []
    
    var id: Int = 1
    
    func addOrder(userId: Int, firstName: String, lastName: String, address: String, city: String, paymentMethod: Int, allItem: [Cart], totalPrice: Double) {
        let newOrder = Order(id: self.id, userId: userId, firstName: firstName, lastName: lastName, address: address, city: city, paymentMethod: paymentMethod, allItem: allItem, totalPrice: totalPrice)
        self.aryOrder.append(newOrder)
        self.id += 1
    }
    
    func getUserOrder(_ userId: Int) -> [Order]? {
        return self.aryOrder.filter({
            $0.userId == userId
        })
    }
}
