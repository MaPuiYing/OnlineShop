//
//  AlertViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 14/3/2022.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var vwAlert: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    
    var titleString: String? = ""
    var okAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        self.initSetup()
        // Do any additional setup after loading the view.
    }
    
    func initSetup() {
        self.vwAlert.layer.cornerRadius = 16
        self.btnOK.tintColor = .btnOrange
        self.btnOK.layer.masksToBounds = true
        self.btnOK.layer.cornerRadius = self.btnOK.bounds.height/2
        self.btnOK.setTitle("OK", for: .normal)
        
        self.lblTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.lblTitle.text = self.titleString
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.okAction?()
    }
}
