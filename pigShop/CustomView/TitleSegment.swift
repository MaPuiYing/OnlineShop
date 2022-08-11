//
//  ImageHeaderSegment.swift
//  pigShop
//
//  Created by Pui Ying Ma on 10/8/2022.
//

import Foundation
import UIKit
import JXSegmentedView

class TitleSegment: UIViewController {
    var titleString: [String] = []
    var kNavBarHeight: CGFloat = 0
    var tabBarBottomHeight: CGFloat = 0
    
    var getOrderContent: ((Int)->JXSegmentedListContainerViewListDelegate)?
    
    //Title
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.titles = self.titleString
        ds.titleNormalColor = .textLightGrey
        ds.titleSelectedColor = .mainOrange
        ds.titleNormalFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        ds.titleSelectedFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        ds.isTitleColorGradientEnabled = true
        return ds
    }()
    
    //Indicator line
    lazy var sliderView: JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorColor = .mainOrange
        view.indicatorHeight = 2
        return view
    }()
    
    //Container view
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        let frameY = self.kNavBarHeight + self.topSafeAreaHeight + 40
        view.frame = CGRect(x: 0, y: frameY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - frameY - self.tabBarBottomHeight)
        return view
    }()
    
    //Segment View
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView(frame: CGRect(x: 0, y: self.kNavBarHeight + self.topSafeAreaHeight, width: UIScreen.main.bounds.width, height: 40))
        view.dataSource = self.segmentedDataSource
        view.listContainer = self.listContainerView
        view.indicators = [self.sliderView]
        view.backgroundColor = .tabbarBackground
        view.delegate = self
        return view
    }()
}

//MARK: - JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource

extension TitleSegment: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return self.titleString.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.getOrderContent?(index) ?? OrderPagingViewController()
    }
}
