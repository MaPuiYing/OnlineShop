//
//  OrderModel.swift
//  pigShop
//
//  Created by Pui Ying Ma on 9/8/2022.
//

import Foundation

enum PaymentMethod: Int {
    case googlePay
    case paypal
    case creditCard
}

enum OrderStatus: Int {
    case pendingDelivery
    case shipped
    case receivedConfirm
}

struct Order {
    let id: Int?
    var userId: Int?
    var firstName: String?
    var lastName: String?
    var address: String?
    var city: String?
    var paymentMethod: PaymentMethod?
    var allItem: [Cart]?
    var totalPrice: Double?
    var status: OrderStatus?
}

class OrderModel {
    static let shared = OrderModel()
    var aryOrder: [Order] = []
    
    var id: Int = 1
    
    func addOrder(userId: Int, firstName: String, lastName: String, address: String, city: String, paymentMethod: PaymentMethod, allItem: [Cart], totalPrice: Double) {
        let newOrder = Order(id: self.id, userId: userId, firstName: firstName, lastName: lastName, address: address, city: city, paymentMethod: paymentMethod, allItem: allItem, totalPrice: totalPrice, status: .pendingDelivery)
        self.aryOrder.append(newOrder)
        self.id += 1
    }
    
    func getUserOrder(_ userId: Int) -> [Order]? {
        return self.aryOrder.filter({
            $0.userId == userId
        })
    }
    
    func getOrderStatus(_ orderId: Int) -> OrderStatus {
        return OrderStatus(rawValue: (self.aryOrder.filter({
            $0.id == orderId
        }).first?.status)?.rawValue ?? 0) ?? .pendingDelivery
    }
}
