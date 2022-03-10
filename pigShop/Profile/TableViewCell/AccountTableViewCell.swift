//
//  AccountTableViewCell.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vwUser: UIView!
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var vwGuest: UIView!
    @IBOutlet weak var lblGuestName: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initSetup() {
        lblUserName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lblUserName.textColor = .textGrey
        
        lblGuestName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lblGuestName.textColor = .textGrey
        lblGuestName.text = "Guest"
        
        btnRegister.tintColor = .white
        btnRegister.setTitleColor(.btnOrange, for: .normal)
        btnRegister.setTitle("Register", for: .normal)
        btnRegister.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        btnRegister.layer.borderWidth = 1
        btnRegister.layer.borderColor = UIColor.btnOrange.cgColor
        btnRegister.layer.cornerRadius = 6
        
        btnLogin.tintColor = .btnOrange
        btnLogin.setTitleColor(.white, for: .normal)
        btnLogin.setTitle("Login", for: .normal)
        btnLogin.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
}
