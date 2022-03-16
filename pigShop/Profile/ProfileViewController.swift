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
    var userModel = UserModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userModel = UserModel.shared
        self.setupTableSections()
    }
    
    func setupTable() {
        self.table.separatorStyle = .none
        // Register
        self.table.register(UINib(nibName: "SettingListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        self.table.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
    }
    
    func setupTableSections() {
        self.tableSections = []
        
        self.tableSections.append(ProfileSections.user)
        self.tableSections.append(ProfileSections.edit(ProfileSections.EditSection.allCases))
        self.tableSections.append(ProfileSections.question(ProfileSections.QuestionSection.allCases))
        
        if self.userModel.isLogined() == true {
            self.tableSections.append(ProfileSections.logout)
        }
        
        self.table.reloadData()
    }
    
    //MARK: - Button Action
    @objc func registerBtnPressed() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            vc.modalPresentationStyle = .fullScreen
            self.tabBarController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func loginBtnPressed() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            vc.modalPresentationStyle = .fullScreen
            self.tabBarController?.present(vc, animated: true, completion: nil)
        }
    }
}

//MARK: - TableView delegate & dataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.tableSections[section]
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
        let section = self.tableSections[indexPath.section]
        switch section {
        case .user:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as? AccountTableViewCell else {return UITableViewCell()}
            
            if self.userModel.isLogined() == true {
                cell.vwUser.isHidden = false
                cell.vwGuest.isHidden = true
                
                cell.lblUserName.text = userModel.getUser()?.username
            } else {
                cell.selectionStyle = .none
                cell.vwGuest.isHidden = false
                cell.vwUser.isHidden = true
                cell.btnRegister.addTarget(self, action: #selector(self.registerBtnPressed), for: .touchUpInside)
                cell.btnLogin.addTarget(self, action: #selector(self.loginBtnPressed), for: .touchUpInside)
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
        self.table.deselectRow(at: indexPath, animated: true)
        
        let section = self.tableSections[indexPath.section]
        switch section {
        case .user:
            if self.userModel.isLogined() == true {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                break
            }
        case .edit(let items):
            break
        case .question(let items):
            break
        case .logout:
            self.showAlert(title: "Confirm to logout?", hideLeftButton: false, leftTitle: "Cancel", rightTitle: "Confirm", rightBtnAction: {[weak self] in
                self?.userModel.logoutUser()
                self?.setupTableSections()
            })
        }
    }
    
    //MARK: - Header
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .tabbarBackground
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = self.tableSections[section]
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
        let section = self.tableSections[section]
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
