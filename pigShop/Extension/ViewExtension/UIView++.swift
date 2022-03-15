//
//  UIView++.swift
//  pigShop
//
//  Created by Joyce Ma on 11/3/2022.
//

import Foundation
import UIKit

enum VerticalLocation: String {
    case top
    case bottom
    case all
}

extension UIView {
    @discardableResult
    func fromNib<T: UIView>() -> T? {
        guard let contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        
        self.addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        return contentView
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black.withAlphaComponent(0.2), opacity: Float = 0.2, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
            
        switch location {
        case .top:
            self.layer.shadowOffset = CGSize(width: 0, height: -1)
        case .bottom:
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
        case .all:
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
        }
    }
}
