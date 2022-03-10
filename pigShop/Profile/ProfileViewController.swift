//
//  ProfileViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

enum ProfileSections {
    case account
    case edit([EditSection])
    case question([QuestionSection])
    
    enum EditSection: CaseIterable {
        case editAccInfo
        case forgotPassword
    }
    enum QuestionSection: CaseIterable {
        case policy
        case aboutUs
        case logout
    }
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    var tableSections: [ProfileSections] = []
    var isLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        setupTable()
        // Do any additional setup after loading the view.
    }
    
    func setupTable() {
        // Register
        table.register(UINib(nibName: "SettingListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        table.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        
        // Append
        tableSections.append(ProfileSections.account)
        tableSections.append(ProfileSections.edit(ProfileSections.EditSection.allCases))
        tableSections.append(ProfileSections.question(ProfileSections.QuestionSection.allCases))
        
        table.reloadData()
    }
}

//MARK: - TableView delegate & dataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = tableSections[section]
        switch section {
        case .account:
            return 1
        case .edit(let items):
            return items.count
        case .question(let items):
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = tableSections[indexPath.section]
        switch section {
        case .account:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as? AccountTableViewCell else {return UITableViewCell()}
            
            if isLogin {
                cell.vwUser.isHidden = false
                cell.vwGuest.isHidden = true
                
                cell.lblUserName.text = "[User Name]"
            } else {
                cell.selectionStyle = .none
                
                cell.vwGuest.isHidden = false
                cell.vwUser.isHidden = true
            }
            return cell
        case .edit(let items):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? SettingListTableViewCell else {return UITableViewCell()}
            
            switch items[indexPath.row] {
            case .editAccInfo:
                cell.lblTitle.text = "Edit Account"
            case .forgotPassword:
                cell.lblTitle.text = "Forgot Password"
            }
            return cell
            
        case .question(let items):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? SettingListTableViewCell else {return UITableViewCell()}
            
            switch items[indexPath.row] {
            case .aboutUs:
                cell.lblTitle.text = "About Us"
            case .policy:
                cell.lblTitle.text = "Policy"
            case .logout:
                cell.lblTitle.text = "Logout"
                cell.imvArrow.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    //Header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .tabbarBackground
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = tableSections[section]
        switch section {
        case .account:
            return .leastNonzeroMagnitude
        case .edit:
            return 50
        case .question:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = tableSections[section]
        switch section {
        case .account:
            return ""
        case .edit:
            return "Edit"
        case .question:
            return "Question"
        }
    }
}
