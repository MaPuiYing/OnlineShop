//
//  PhotoViewController.swift
//  pigShop
//
//  Created by Pui Ying Ma on 25/8/2022.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var btnClose: ImageButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnClose.method = {[weak self] in self?.dismiss(animated: true, completion: nil)}
        self.imageView.sd_setImage(with: URL(string: self.imageURL))
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }
}

//MARK: - UIScrollViewDelegate

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
