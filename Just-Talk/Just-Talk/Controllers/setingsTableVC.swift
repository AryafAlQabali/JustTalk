//
//  setingsTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 19/05/1443 AH.
//

import UIKit

class setingsTableVC: UITableViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBOutlet weak var usernameOutlet: UILabel!
    
    
    
    
    
    
    
    
    
    //MARK:- Lifecycle of table view

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
      
       

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }

    
    
    
    
    //MARK:- IBActions
    @IBAction func tellFriendButPressed(_ sender: UIButton) {
        print("tell a friend")
    }
    @IBAction func termsButPressed(_ sender: UIButton) {
        print("terms and conditions")
    }
    
    @IBAction func logoutButPressed(_ sender: UIButton) {

        FUserListener.shared.logoutCurrentUser { (error) in
            
            if error == nil {
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView")
                
                
                DispatchQueue.main.async {

                    loginView.modalPresentationStyle = .fullScreen
                    
                    self.present(loginView, animated: true, completion: nil)
                }
                
            }


        }
    }
    
    
    //MARK:- Table Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableView")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0: 10.0
    
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            
            performSegue(withIdentifier: "SettingsToEditProfileSgue", sender: self)
        }
    }
    
    
    
    //MARK:- Update UI
    
    private func showUserInfo(){
        if let user = User.currentUser{
            usernameOutlet.text = user.username
            
            
            if user.avatarLink != "" {

                
                //TODO Download and set avater image
            }
        }
    }

    
    
    
}

