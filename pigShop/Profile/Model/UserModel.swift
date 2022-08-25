//
//  UserModel.swift
//  pigShop
//
//  Created by Joyce Ma on 15/3/2022.
//

import Foundation

struct User {
    let id: Int?
    var username: String?
    var password: String?
    var email: String?
    var phoneNo: String?
    var firstName: String?
    var lastName: String?
    var address: String?
    var city: String?
    var icon: Data?
}

class UserModel {
    
    static let shared = UserModel()
    var aryUser: [User] = []
    var currentUser: User?
    var id: Int = 1
    
    var cityString: [String] = ["Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador", "Nova Scotia", "Ontario", "Prince Edward Island", "Quebec", "Saskatchewan", "Northwest Territories", "Nunavut", "Yukon"]
    
    init() {
        self.addUser(username: "admin", password: "admin", email: "admin@pigpigShop.com", phoneNo: "98761234")
    }
    
    //MARK: - Get User Info
    
    func isLogined() -> Bool? {
        return self.currentUser != nil
    }
    
    func getUser() -> User? {
        return self.currentUser
    }
    
    func getAllUser() -> [User] {
        return self.aryUser
    }
    
    //MARK: - Edit User
    
    func addUser(username: String?, password: String?, email: String?, phoneNo: String?) {
        let newUser = User(id: self.id, username: username, password: password, email: email, phoneNo: phoneNo, firstName: nil, lastName: nil, address: nil, city: "Alberta")
        self.aryUser.append(newUser)
        self.id += 1
    }
    
    func updateUserInfo(username newUsername: String?, email newEmail: String?, phone newPhone: String?, icon newIcon: Data?) {
        let index = self.getCurrentUserIndex()
        var newUser = self.aryUser[index]
        newUser.username = newUsername
        newUser.email = newEmail
        newUser.phoneNo = newPhone
        newUser.icon = newIcon
        self.aryUser[index] = newUser
        self.currentUser = newUser
    }
    
    func updatePassword(_ newPassword: String?) {
        let index = self.getCurrentUserIndex()
        var newUser = self.aryUser[index]
        newUser.password = newPassword
        self.aryUser[index] = newUser
        self.currentUser = newUser
    }
    
    func updateTransactionInfo(firstName newFirstName: String?, lastName newLastName: String?, address newAddress: String?, city newCity: String?) {
        let index = self.getCurrentUserIndex()
        var newUser = self.aryUser[index]
        newUser.firstName = newFirstName
        newUser.lastName = newLastName
        newUser.address = newAddress
        newUser.city = newCity
        self.aryUser[index] = newUser
        self.currentUser = newUser
    }

    func loginUser(username: String?, password: String?, success: @escaping (()->Void), failure: @escaping (()->Void)) {
        let loginUser = self.aryUser.filter({
            ($0.username == username) && ($0.password == password)
        }).first
        if loginUser != nil {
            self.currentUser = loginUser
            success()
        } else {
            failure()
        }
    }
    
    func logoutUser() {
        self.currentUser = nil
    }
    
    //MARK: - Get Index
    
    func getCurrentUserIndex() -> Int {
        return self.aryUser.firstIndex(where: {
            $0.id == self.currentUser?.id
        }) ?? 0
    }
    
}
