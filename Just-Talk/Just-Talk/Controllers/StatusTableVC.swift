//
//  StatusTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 21/05/1443 AH.
//

import UIKit

class StatusTableVC: UITableViewController {

    let statuses = ["Available".localized , "Busy!".localized, "sleeping".localized, "At School".localized, "At Work".localized, "In a Meeting".localized, "Can't Talk".localized]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = statuses[indexPath.row]
        
        let userStatus = User.currentUser?.status
        cell?.accessoryType = userStatus == statuses[indexPath.row] ? .checkmark : .none
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userStatus = tableView.cellForRow(at: indexPath)?.textLabel?.text
        tableView.reloadData()
        
        var user = User.currentUser
        user?.status = userStatus!
        saveUserLocally(user!)
        FUserListener.shared.saveUserToFirestore(user!)
    }
    
    
   
    
    
}
