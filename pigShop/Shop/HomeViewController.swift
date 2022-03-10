//
//  HomeViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var clvRecommend: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imvLast: UIImageView!
    @IBOutlet weak var imvNext: UIImageView!
    
    var timer : Timer?
    var aryRecommendImage: [String] {
        var image: [String] = []
        image.append("https://media.karousell.com/media/photos/products/2021/3/20/lulu_lulupig__1616207256_0e9b6ccb_progressive.jpg")
        image.append("https://www.price.com.hk/space/ec_product/shop/192000/192863_kd2nuj_0.jpg")
        image.append("https://media.karousell.com/media/photos/products/2020/9/22/lulupig_lulu____1600744315_4bd23683_progressive.jpg")
        return image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "PigPig Shop"
        
        self.imvLast.isUserInteractionEnabled = true
        self.imvNext.isUserInteractionEnabled = true
        
        let lastGesture = UITapGestureRecognizer(target: self, action: #selector(imvLastAction))
        self.imvLast.addGestureRecognizer(lastGesture)
        
        let nextGesture = UITapGestureRecognizer(target: self, action: #selector(imvNextAction))
        self.imvNext.addGestureRecognizer(nextGesture)
        
        self.setupCollectionView()
        self.setupPageControl()
        
        self.startTimer()
        // Do any additional setup after loading the view.
    }
    
    func setupPageControl() {
        self.pageControl.numberOfPages = self.aryRecommendImage.count
        self.pageControl.hidesForSinglePage = true
    }
    
    func setupCollectionView() {
        self.clvRecommend.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recommendCell")
    }
    
    func startTimer () {
        let timer = Timer.init(timeInterval: 2, target: self, selector: #selector(autoNextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
     
        self.timer = timer
    }
    
    @objc func imvLastAction() {
        self.timer?.invalidate()
        self.timer = nil
        
        let width = self.clvRecommend.bounds.width
        
        if self.clvRecommend.contentOffset.x == 0 {
            let offsetX = CGFloat(2 * self.aryRecommendImage.count - 1) * width
            self.clvRecommend.contentOffset.x = offsetX
            self.startTimer()
        } else {
            self.clvRecommend.contentOffset.x -= width
            self.startTimer()
        }
    }
    
    @objc func imvNextAction() {
        self.timer?.invalidate()
        self.timer = nil
        
        let width = self.clvRecommend.bounds.width
        
        if self.clvRecommend.contentOffset.x == CGFloat(3 * self.aryRecommendImage.count - 1) * width {
            self.clvRecommend.contentOffset.x = CGFloat(self.aryRecommendImage.count - 1) * width
            self.startTimer()
        } else {
            self.clvRecommend.contentOffset.x += width
            self.startTimer()
        }
    }
     
    @objc func autoNextPage() {
        let width = self.clvRecommend.bounds.width
        
        // if last cell
        if self.clvRecommend.contentOffset.x == CGFloat(3 * self.aryRecommendImage.count - 1) * width {
            let offsetX = CGFloat(self.aryRecommendImage.count - 1) * width
            self.clvRecommend.contentOffset.x = offsetX
        }else {
            let offsetX = self.clvRecommend.contentOffset.x + width
            self.clvRecommend.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}

//MARK: - Scroll View Delegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = self.clvRecommend.bounds.width
        
        if self.clvRecommend.contentOffset.x == 0 {
            self.clvRecommend.contentOffset.x = CGFloat(2 * self.aryRecommendImage.count - 1) * width
        }
        
        // if last cell
        if self.clvRecommend.contentOffset.x == CGFloat(3 * self.aryRecommendImage.count - 1) * width {
            self.clvRecommend.contentOffset.x = CGFloat(self.aryRecommendImage.count - 1) * width
        }
      }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
        self.timer = nil
      }
     
      func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
          self.startTimer()
      }
}

//MARK: - UICollectionView delegate & data source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.aryRecommendImage.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as? RecommendCollectionViewCell else {return UICollectionViewCell()}
        let i = indexPath.row % self.aryRecommendImage.count
        cell.imageView.sd_setImage(with: URL(string: self.aryRecommendImage[i]), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row % self.aryRecommendImage.count
    }
}

//MARK: - UICollrectionView layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: self.clvRecommend.frame.height)
    }
}
