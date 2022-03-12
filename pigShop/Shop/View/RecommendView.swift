//
//  RecommendView.swift
//  pigShop
//
//  Created by Joyce Ma on 11/3/2022.
//

import UIKit

class RecommendView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
        
    init() {
        super.init(frame: CGRect.zero)
        fromNib()
    }
    
    @IBOutlet weak var clvRecommend: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imvLast: UIImageView!
    @IBOutlet weak var imvNext: UIImageView!
    
    var timer : Timer?
    var aryImage: [String] = []
    var action: ((Int)->Void)?
    
    func setupView() {
        self.stopTimer()
        
        self.addGesture()
        
        self.clvRecommend.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recommendCell")
        self.clvRecommend.contentOffset.x = CGFloat(self.aryImage.count) * self.clvRecommend.bounds.width
        self.clvRecommend.reloadData()
        self.pageControl.numberOfPages = self.aryImage.count
        self.pageControl.hidesForSinglePage = true
        
        self.startTimer()
    }
    
    //MARK: - Timer setup
    
    func startTimer() {
        let timer = Timer.init(timeInterval: 2, target: self, selector: #selector(autoNextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
     
        self.timer = timer
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func autoNextPage() {
        let width = self.clvRecommend.bounds.width
        
        // if last cell
        if self.clvRecommend.contentOffset.x == CGFloat(3 * self.aryImage.count - 1) * width {
            let offsetX = CGFloat(self.aryImage.count - 1) * width
            self.clvRecommend.contentOffset.x = offsetX
        }else {
            let offsetX = self.clvRecommend.contentOffset.x + width
            self.clvRecommend.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }

    //MARK: - Button Action
    
    func addGesture() {
        self.imvLast.isUserInteractionEnabled = true
        self.imvNext.isUserInteractionEnabled = true
        
        let lastGesture = UITapGestureRecognizer(target: self, action: #selector(imvLastAction))
        self.imvLast.addGestureRecognizer(lastGesture)
        
        let nextGesture = UITapGestureRecognizer(target: self, action: #selector(imvNextAction))
        self.imvNext.addGestureRecognizer(nextGesture)
    }
    
    @objc func imvLastAction() {
        self.stopTimer()
        
        let width = self.clvRecommend.bounds.width
        if self.clvRecommend.contentOffset.x == 0 {
            let offsetX = CGFloat(2 * self.aryImage.count - 1) * width
            self.clvRecommend.contentOffset.x = offsetX
            self.startTimer()
        } else {
            self.clvRecommend.contentOffset.x -= width
            self.startTimer()
        }
    }
    
    @objc func imvNextAction() {
        self.stopTimer()
        
        let width = self.clvRecommend.bounds.width
        if self.clvRecommend.contentOffset.x == CGFloat(3 * self.aryImage.count - 1) * width {
            self.clvRecommend.contentOffset.x = CGFloat(self.aryImage.count - 1) * width
            self.startTimer()
        } else {
            self.clvRecommend.contentOffset.x += width
            self.startTimer()
        }
    }
}

//MARK: - Scroll View Delegate

extension RecommendView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = self.clvRecommend.bounds.width
        
        if self.clvRecommend.contentOffset.x == 0 {
            self.clvRecommend.contentOffset.x = CGFloat(2 * self.aryImage.count - 1) * width
        }
        
        // if last cell
        if self.clvRecommend.contentOffset.x == CGFloat(3 * self.aryImage.count - 1) * width {
            self.clvRecommend.contentOffset.x = CGFloat(self.aryImage.count - 1) * width
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
     
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.startTimer()
    }
}

//MARK: - UICollectionView delegate & dataSource

extension RecommendView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.aryImage.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as? RecommendCollectionViewCell else {return UICollectionViewCell()}
        let i = indexPath.row % self.aryImage.count
        cell.imageView.sd_setImage(with: URL(string: self.aryImage[i]), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.action?(indexPath.row % 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row % self.aryImage.count
    }
}

//MARK: - UICollectionView layout

extension RecommendView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: self.clvRecommend.frame.height)
    }
}
