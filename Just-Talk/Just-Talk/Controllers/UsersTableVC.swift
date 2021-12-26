//
//  UsersTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 22/05/1443 AH.
//

import UIKit

class UsersTableVC: UITableViewController {

    //MARK:- Vars
    var allUsers :[User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allUsers = [User.currentUser!]

//        createdummyusers()
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!
        UsersTableViewCell
        cell.configureCell(user: User.currentUser!)
        return cell
    }


}
