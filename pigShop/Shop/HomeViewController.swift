//
//  HomeViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var clvRecommend: UICollectionView!
    
    var aryRecommendImage: [String] {
        var image: [String] = []
        image.append("https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.carousell.com.hk%2Fp%2F%25E6%25AD%25A3%25E7%2589%2588lulu%25E8%25B1%25AC-lulupig-%25E6%258B%258D%25E6%258B%258D%25E7%2587%2588-%25E5%25B0%258F%25E5%25A4%259C%25E7%2587%2588-1076319860%2F&psig=AOvVaw1LhT58zNudVe5v9NwEx94M&ust=1647008409017000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOihy8veu_YCFQAAAAAdAAAAABAN")
        image.append("https://www.google.com/url?sa=i&url=https%3A%2F%2Fshop.price.com.hk%2Fapetoys%2Fproduct%2F192863&psig=AOvVaw1LhT58zNudVe5v9NwEx94M&ust=1647008409017000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOihy8veu_YCFQAAAAAdAAAAABAS")
        image.append("https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.aliexpress.com%2Fitem%2F4001147699810.html&psig=AOvVaw1LhT58zNudVe5v9NwEx94M&ust=1647008409017000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOihy8veu_YCFQAAAAAdAAAAABAd")
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
        return cell
    }
}

//MARK: - UICollrectionView layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: clvRecommend.frame.height)
    }
}
