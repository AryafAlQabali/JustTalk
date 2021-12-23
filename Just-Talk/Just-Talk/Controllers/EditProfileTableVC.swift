//
//  EditProfileTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 19/05/1443 AH.
//

import UIKit

class EditProfileTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        showUserInfo()
   
    }
 //MARK:- IBOutlets
    
    @IBOutlet weak var avatarImageViewOutlet: UIImageView!
    
    @IBOutlet weak var usernameTextFieldOutlet: UITextField!
    
    
    
    
    
    
    //MARK:- IBAction
    @IBAction func editButPressed(_ sender: UIButton) {
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0  || section == 1 ? 0.0 :30.0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableView")
        return headerView
    }
    

    
    //MARK:- Table View data source
    
    private func showUserInfo() {
        
        if let user = User.currentUser {
            
            usernameTextFieldOutlet.text = user.username
            
            
            if user.avatarLink != "" {
                 
                //set avater image
        }
    }
}
    
}
