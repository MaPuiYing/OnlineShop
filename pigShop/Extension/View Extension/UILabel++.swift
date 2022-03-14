//
//  UILabel++.swift
//  pigShop
//
//  Created by Joyce Ma on 11/3/2022.
//

import Foundation
import UIKit

extension UILabel {
    func getActualHeight() -> CGFloat {
        guard let text = self.text else {return 0}
        let constraintRect = CGSize(width: self.frame.width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font ?? 0], context: nil)
        let height = boundingBox.height
        
        let maxLines = CGFloat(self.numberOfLines)
        let lines = height/self.font.lineHeight
        if (maxLines != 0) && (lines >= maxLines) {
            return (height / lines) * maxLines
        }
        return height
    }
}
