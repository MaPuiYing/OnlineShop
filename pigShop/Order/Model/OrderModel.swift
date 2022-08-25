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
    case arrived
    case history
    
    func getText() -> String {
        switch self {
        case .pendingDelivery:
            return "Waiting For Delivery"
        case .shipped:
            return "Shipped"
        case .arrived:
            return "Arrived"
        case .history:
            return "History"
        }
    }
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
    var dateTime: String?
}

class OrderModel {
    static let shared = OrderModel()
    var aryOrder: [Order] = []
    
    var id: Int = 1
    
    init() {
        self.demoOrder()
    }
    
    func demoOrder() {
        let cart = Cart(id: nil, itemID: 2, count: 1, isChecked: false)
        
        let newOrder = Order(id: self.id, userId: 1, firstName: "wd", lastName: "seefsaef", address: "uihrwlycagsrfgseyflashfewcdawfea", city: "Alberta", paymentMethod: .creditCard, allItem: [cart], totalPrice: 400, status: .shipped, dateTime: Util.getCurrentDate())
        self.aryOrder.append(newOrder)
        self.id += 1
        
        let newOrder2 = Order(id: self.id, userId: 1, firstName: "efea", lastName: "seefsaaef", address: "efashufhaseu\nefishuaof\nefsefsag", city: "Alberta", paymentMethod: .creditCard, allItem: [cart], totalPrice: 400, status: .arrived, dateTime: Util.getCurrentDate())
        self.aryOrder.append(newOrder2)
        self.id += 1
    }
    
    //MARK: - Add Order
    
    func addOrder(userId: Int, firstName: String, lastName: String, address: String, city: String, paymentMethod: PaymentMethod, allItem: [Cart], totalPrice: Double) {
        let newOrder = Order(id: self.id, userId: userId, firstName: firstName, lastName: lastName, address: address, city: city, paymentMethod: paymentMethod, allItem: allItem, totalPrice: totalPrice, status: .pendingDelivery, dateTime: Util.getCurrentDate())
        self.aryOrder.append(newOrder)
        self.id += 1
    }
    
    //MARK: - Get Order
    
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
    
    //MARK: - Update Order
    
    func updateOrderStatus(orderId: Int, newStatus: OrderStatus) {
        if let row = self.aryOrder.firstIndex(where: {$0.id == orderId}) {
            var newOrder = self.aryOrder[row]
            newOrder.status = newStatus
            self.aryOrder[row] = newOrder
        }
    }
}
