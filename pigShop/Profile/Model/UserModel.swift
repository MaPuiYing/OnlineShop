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
    
    func getCurrentUserIndex() -> Int {
        return self.aryUser.firstIndex(where: {
            $0.id == self.currentUser?.id
        }) ?? 0
    }
    
    func addUser(username: String?, password: String?, email: String?, phoneNo: String?) {
        let newUser = User(id: self.id, username: username, password: password, email: email, phoneNo: phoneNo)
        self.aryUser.append(newUser)
        self.id += 1
    }
    
    func updateUserInfo(username newUsername: String?, email newEmail: String?, phone newPhone: String?) {
        let index = self.getCurrentUserIndex()
        let oldUser = self.aryUser[index]
        let newUser = User(id: oldUser.id, username: newUsername, password: oldUser.password, email: newEmail, phoneNo: newPhone)
        self.aryUser[index] = newUser
        self.currentUser = newUser
    }
    
    func updatePassword(_ newPassword: String?) {
        let index = self.getCurrentUserIndex()
        let oldUser = self.aryUser[index]
        let newUser = User(id: oldUser.id, username: oldUser.username, password: newPassword, email: oldUser.email, phoneNo: oldUser.phoneNo)
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
    
}
