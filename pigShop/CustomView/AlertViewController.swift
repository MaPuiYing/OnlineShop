//
//  AlertViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 14/3/2022.
//

import UIKit

struct AlertContent {
    let title: String?
    let hideLeftButton: Bool?
    let leftTitle: String?
    let rightTitle: String?
    let leftBtnAction: (()->Void)?
    let rightBtnAction: (()->Void)?
}

class AlertViewController: UIViewController {
    
    @IBOutlet weak var vwAlert: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    var alertContent: AlertContent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        self.initSetup()
        
        self.vwAlert.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.vwAlert.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func initSetup() {
        self.vwAlert.layer.cornerRadius = 16
        
        self.btnLeft.tintColor = .lightGray
        self.btnLeft.layer.masksToBounds = true
        self.btnLeft.layer.cornerRadius = self.btnLeft.bounds.height/2
        self.btnRight.tintColor = .btnOrange
        self.btnRight.layer.masksToBounds = true
        self.btnRight.layer.cornerRadius = self.btnLeft.bounds.height/2
        
        self.lblTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        let model = self.alertContent
        self.lblTitle.text = model?.title
        self.btnLeft.isHidden = model?.hideLeftButton ?? true
        self.btnLeft.setTitle(model?.leftTitle, for: .normal)
        self.btnRight.setTitle(model?.rightTitle, for: .normal)
    }
    
    @IBAction func leftButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.vwAlert.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: {_ in
            self.dismiss(animated: true, completion: nil)
            self.alertContent?.leftBtnAction?()
        })
    }
    
    @IBAction func rightButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.vwAlert.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: {_ in
            self.dismiss(animated: true, completion: nil)
            self.alertContent?.rightBtnAction?()
        })
    }
}
