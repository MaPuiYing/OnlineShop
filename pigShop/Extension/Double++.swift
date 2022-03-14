//
//  Double++.swift
//  pigShop
//
//  Created by Joyce Ma on 13/3/2022.
//

import Foundation

extension Double {
    var stringValue: String {
        let doubleStr = String(format: "%.2f", self)
        return String(format: "HKD$%@", doubleStr)
    }
}
