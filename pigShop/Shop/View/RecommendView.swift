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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imvLast: ImageButton!
    @IBOutlet weak var imvNext: ImageButton!
    
    var timer : Timer?
    var aryImage: [String] = []
    var action: ((Int)->Void)?
    
    func setupView() {
        self.stopTimer()
        self.imvLast.method = {[weak self] in self?.imvLastAction()}
        self.imvNext.method = {[weak self] in self?.imvNextAction()}
        
        self.collectionView.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recommendCell")
        self.collectionView.contentOffset.x = CGFloat(self.aryImage.count) * self.collectionView.bounds.width
        self.collectionView.reloadData()
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
        let width = self.collectionView.bounds.width
        
        // if last cell
        if self.collectionView.contentOffset.x == CGFloat(3 * self.aryImage.count - 1) * width {
            let offsetX = CGFloat(self.aryImage.count - 1) * width
            self.collectionView.contentOffset.x = offsetX
        }else {
            let offsetX = self.collectionView.contentOffset.x + width
            self.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }

    //MARK: - Button Action
    
    func imvLastAction() {
        self.stopTimer()
        
        let width = self.collectionView.bounds.width
        if self.collectionView.contentOffset.x == 0 {
            let offsetX = CGFloat(2 * self.aryImage.count - 1) * width
            self.collectionView.contentOffset.x = offsetX
            self.startTimer()
        } else {
            self.collectionView.contentOffset.x -= width
            self.startTimer()
        }
    }
    
    func imvNextAction() {
        self.stopTimer()
        
        let width = self.collectionView.bounds.width
        if self.collectionView.contentOffset.x == CGFloat(3 * self.aryImage.count - 1) * width {
            self.collectionView.contentOffset.x = CGFloat(self.aryImage.count - 1) * width
            self.startTimer()
        } else {
            self.collectionView.contentOffset.x += width
            self.startTimer()
        }
    }
}

//MARK: - Scroll View Delegate

extension RecommendView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = self.collectionView.bounds.width
        
        if self.collectionView.contentOffset.x == 0 {
            self.collectionView.contentOffset.x = CGFloat(2 * self.aryImage.count - 1) * width
        }
        
        // if last cell
        if self.collectionView.contentOffset.x == CGFloat(3 * self.aryImage.count - 1) * width {
            self.collectionView.contentOffset.x = CGFloat(self.aryImage.count - 1) * width
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
        return CGSize(width: UIScreen.main.bounds.width, height: self.collectionView.frame.height)
    }
}
