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
        
        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func setupCollectionView() {
        clvRecommend.register(UINib(nibName: "RecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recommendCell")
    }
}

//MARK: - UICollectionView delegate & data source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        aryRecommendImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as? RecommendCollectionViewCell else {return UICollectionViewCell()}
        cell.imageView.sd_setImage(with: URL(string: aryRecommendImage[indexPath.row]), completed: nil)
        return cell
    }
}

//MARK: - UICollrectionView layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: clvRecommend.frame.height)
    }
}
