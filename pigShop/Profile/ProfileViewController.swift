//
//  ProfileViewController.swift
//  pigShop
//
//  Created by Joyce Ma on 10/3/2022.
//

import UIKit

enum ProfileSections {
    case user
    case edit([EditSection])
    case question([QuestionSection])
    case logout
    
    enum EditSection: CaseIterable {
        case editAccInfo
        case forgotPassword
    }
    enum QuestionSection: CaseIterable {
        case policy
        case aboutUs
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
        table.separatorStyle = .none
        // Register
        table.register(UINib(nibName: "SettingListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        table.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        
        // Append
        tableSections.append(ProfileSections.user)
        tableSections.append(ProfileSections.edit(ProfileSections.EditSection.allCases))
        tableSections.append(ProfileSections.question(ProfileSections.QuestionSection.allCases))
        if isLogin {
            tableSections.append(ProfileSections.logout)
        }
        
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
        case .user:
            return 1
        case .edit(let items):
            return items.count
        case .question(let items):
            return items.count
        case .logout:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = tableSections[indexPath.section]
        switch section {
        case .user:
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
                cell.vwSeparator.isHidden = false
                cell.lblTitle.text = "Edit Account"
            case .forgotPassword:
                cell.vwSeparator.isHidden = true
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
            }
            return cell
            
        case .logout:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? SettingListTableViewCell else {return UITableViewCell()}
            cell.imvArrow.isHidden = true
            cell.lblTitle.text = "Logout"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Header
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .tabbarBackground
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = tableSections[section]
        switch section {
        case .user, .logout:
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
        case .user, .logout:
            return nil
        case .edit:
            return "Edit"
        case .question:
            return "Question"
        }
    }
}
