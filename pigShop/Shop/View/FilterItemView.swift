//
//  FilterItemView.swift
//  pigShop
//
//  Created by Pui Ying Ma on 24/8/2022.
//

import UIKit
import MultiSlider

class FilterItemView: UIView {
    
    @IBOutlet weak var sliderPrice: MultiSlider!
    var doneFunc: (()->Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.fromNib()
    }
        
    init() {
        super.init(frame: CGRect.zero)
        self.fromNib()
    }
    
    func setupView() {
        self.sliderPrice.value = [0,1000]
        self.sliderPrice.snapStepSize = 10
        self.sliderPrice.distanceBetweenThumbs = 200
        
        self.sliderPrice.valueLabelPosition = .top
        self.sliderPrice.isValueLabelRelative = true
        self.sliderPrice.valueLabelFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.sliderPrice.valueLabelTextForThumb = { thumbIndex, thumbValue in
            let value = Int(thumbValue)
            return "HKD$\(value)"
        }
        
        self.sliderPrice.valueLabelColor = .mainOrange
        self.sliderPrice.tintColor = .mainOrange
        self.sliderPrice.trackWidth = 6
    }
    
    @IBAction func resetBtnPressed() {
        self.sliderPrice.value = [0,1000]
    }
    
    @IBAction func doneBtnPressed() {
        self.doneFunc?()
    }
}
