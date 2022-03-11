//
//  Util.swift
//  pigShop
//
//  Created by Joyce Ma on 11/3/2022.
//

import Foundation
import UIKit

class Util {
    
    //MARK: - Collection View Handling
    static func calculateItemWidth(columns: CGFloat, columnSpace: CGFloat, frameWidth: CGFloat) -> CGFloat {
        let columnSpacing = columnSpace * (columns-1)
        let width = (frameWidth - columnSpacing) / columns
        return width
    }
    
    static func calculateCollectionHeight(height: CGFloat, rows: CGFloat, rowSpace: CGFloat) -> CGFloat {
        let rowSpacing = rowSpace * (rows-1)
        let clvHeight = height*rows + rowSpacing
        return clvHeight
    }
}

