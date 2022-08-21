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
}

class OrderModel {
    static let shared = OrderModel()
    var aryOrder: [Order] = []
    
    var id: Int = 1
    
    init() {
        self.demoOrder()
    }
    
    func demoOrder() {
        let item = Item(id: 2, imageURL: "https://media.karousell.com/media/photos/products/2021/3/20/lulu_lulupig__1616207256_0e9b6ccb_progressive.jpg", title: "The light that can let you see the decent view at night", description: "You can turn on the light at night and you will find how beautiful the view is. No hesitation and buy it right now.", price: 400, oldPrice: 500, category: .hot, isDiscount: true, isFavorite: false)
        let cart = Cart(id: nil, item: item, count: 1, isChecked: false)
        
        let newOrder = Order(id: self.id, userId: 1, firstName: "wd", lastName: "seefsaef", address: "uihrwlycagsrfgseyflashfewcdawfea", city: "Alberta", paymentMethod: .creditCard, allItem: [cart], totalPrice: 400, status: .shipped)
        self.aryOrder.append(newOrder)
        self.id += 1
        
        let newOrder2 = Order(id: self.id, userId: 1, firstName: "efea", lastName: "seefsaaef", address: "efashufhaseu\nefishuaof\nefsefsag", city: "Alberta", paymentMethod: .creditCard, allItem: [cart], totalPrice: 400, status: .arrived)
        self.aryOrder.append(newOrder2)
        self.id += 1
    }
    
    //Add
    func addOrder(userId: Int, firstName: String, lastName: String, address: String, city: String, paymentMethod: PaymentMethod, allItem: [Cart], totalPrice: Double) {
        let newOrder = Order(id: self.id, userId: userId, firstName: firstName, lastName: lastName, address: address, city: city, paymentMethod: paymentMethod, allItem: allItem, totalPrice: totalPrice, status: .pendingDelivery)
        self.aryOrder.append(newOrder)
        self.id += 1
    }
    
    //Get
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
    
    //Update
    func updateOrderStatus(orderId: Int, newStatus: OrderStatus) {
        if let row = self.aryOrder.firstIndex(where: {$0.id == orderId}) {
            var newOrder = self.aryOrder[row]
            newOrder.status = newStatus
            self.aryOrder[row] = newOrder
        }
    }
}
