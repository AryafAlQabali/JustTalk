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
    @IBAction func logoutButPressed(_ sender: Any) {
    print("logout")
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

