//
//  ChatRoomTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 23/05/1443 AH.
//

import UIKit

class ChatRoomTableVC: UITableViewController {

    //MARK:- IBActions
    
    
    @IBAction func comoseButPressed(_ sender: Any) {
        let usersView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersView")as!
        UsersTableVC
        navigationController?.pushViewController(usersView, animated: true)
        
    }
    
    
    
    //MARK:- Vars
    var allChatRooms:[ChatRoom] = []
    var filteredChatRooms:[ChatRoom] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        downlaodChatRooms()
        
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Searcch Users"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filteredChatRooms.count :
        allChatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
        
        
        
//
//        let chatRoom = ChatRoom(id: "123", chatRoomId: "123", senderId: "123", senderName: "Azhar", receiverId: "123", receiverName: "Aljrboa", date: Date(), memberId: [""], lastMessage: "Hello zozh , how are you? ", unreadCounter: 1, avaterLink: "")
//
        cell.configureCell(chatRoom: searchController.isActive ? filteredChatRooms[indexPath.row] :  allChatRooms[indexPath.row])
    return cell
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
    
    //MARK:- TableView Delegation function (Delete)
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let chatRoom = searchController.isActive ? filteredChatRooms[indexPath.row] : allChatRooms[indexPath.row]
            
            FChatRoomListener.shared.deleteChatRoom(chatRoom)
        
            searchController.isActive ?  self.filteredChatRooms.remove(at: indexPath.row) : allChatRooms.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        
        }
    }
    
    
    
    
    private func downlaodChatRooms(){
        
        FChatRoomListener.shared.downloadChatRooms { (allFBChatRooms) in
            
            self.allChatRooms = allFBChatRooms
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}


extension ChatRoomTableVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredChatRooms = allChatRooms.filter({ (chatRoom) -> Bool in
            return chatRoom.receiverName.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    
}
