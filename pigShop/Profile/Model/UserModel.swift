//
//  UserModel.swift
//  pigShop
//
//  Created by Joyce Ma on 15/3/2022.
//

import Foundation

struct User {
    let id: Int?
    let username: String?
    let password: String?
    let email: String?
    let phoneNo: String?
}

class UserModel {
    
    static let shared = UserModel()
    var aryUser: [User] = []
    var currentUser: User?
    var id: Int = 1
    
    init() {
        self.addUser(username: "admin", password: "admin", email: "admin@pigpigShop.com", phoneNo: "98761234")
    }
    
    //MARK: - Get Item
    
    func isLogined() -> Bool? {
        return self.currentUser != nil
    }
    
    func getUser() -> User? {
        return self.currentUser
    }
    
    func getAllUser() -> [User] {
        return self.aryUser
    }
    
    //MARK: - Edit Item
    
    func addUser(username: String?, password: String?, email: String?, phoneNo: String?) {
        let newUser = User(id: self.id, username: username, password: password, email: email, phoneNo: phoneNo)
        self.aryUser.append(newUser)
        self.id += 1
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
    
}
