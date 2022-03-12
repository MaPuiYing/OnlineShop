//
//  CustomRefreshControl.swift
//  pigShop
//
//  Created by Joyce Ma on 12/3/2022.
//

import Foundation
import UIKit

class CustomRefreshControl: UIRefreshControl {
    
    var scrollView: UIScrollView? {
        didSet {
            self.scrollViewSetup()
        }
    }
    
    var pullingAction: (()->Void)?
    var finishAction: (()->Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initSetup()
    }

    func initSetup() {
        self.tintColor = .darkRed
    }
    
    func scrollViewSetup() {
        self.scrollView?.delegate = self
        self.scrollView?.refreshControl = self
    }
}

extension CustomRefreshControl: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isRefreshing {
            self.pullingAction?()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.isRefreshing {
            self.finishAction?()
        }
    }
}
