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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        setupTable()
        // Do any additional setup after loading the view.
    }
    
    func setupTable() {
        // Register
        table.register(UINib(nibName: "SettingListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        
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
            return UITableViewCell()
            
        case .edit(let items):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? SettingListTableViewCell else {return UITableViewCell()}
            
            switch items[indexPath.row] {
            case .editAccInfo:
                cell.lbTitle.text = "Edit Account"
            case .forgotPassword:
                cell.lbTitle.text = "Forgot Password"
            }
            return cell
            
        case .question(let items):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? SettingListTableViewCell else {return UITableViewCell()}
            
            switch items[indexPath.row] {
            case .aboutUs:
                cell.lbTitle.text = "About Us"
            case .policy:
                cell.lbTitle.text = "Policy"
            case .logout:
                cell.lbTitle.text = "Logout"
            }
            return cell
        }
    }
    
    //Header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .tabbarBackground
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = tableSections[section]
        switch section {
        case .account:
            return 0
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
