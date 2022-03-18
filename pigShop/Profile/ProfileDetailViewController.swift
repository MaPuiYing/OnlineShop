//
//  ProfileDetailViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 17/3/2022.
//

import UIKit

enum ProfileDetailType {
    case user
}

class ProfileDetailViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    var type: ProfileDetailType = .user

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User"
        self.customBackButton()
        self.setupTable()
        // Do any additional setup after loading the view.
    }
    
    func setupTable() {
        self.table.separatorStyle = .none
        self.table.register(UINib(nibName: "SettingListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }
}

//MARK: - UITableView Delegate & Data Source
extension ProfileDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.type {
        case .user:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.type {
        case .user:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? SettingListTableViewCell else {return UITableViewCell()}
        switch self.type {
        case .user:
            if indexPath.row == 0 {
                cell.lblTitle.text = "User Information"
            } else {
                cell.lblTitle.text = "Change Password"
            }
        }
           
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
        
        switch self.type {
        case .user:
            if indexPath.row == 0 {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
            
            }
        }
    }
    
    // Header
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.type {
        case .user:
            return "User"
        }
    }
}
