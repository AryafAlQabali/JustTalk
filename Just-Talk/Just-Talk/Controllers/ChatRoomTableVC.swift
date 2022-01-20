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
        searchController.searchBar.placeholder = "Search Users".localized
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        
        
    }
    
    //MARK:- UIScrollView Delegate Function
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.refreshControl!.isRefreshing{
            self.downlaodChatRooms()
            self.refreshControl!.endRefreshing()
        }
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
        
        
        

        cell.configureCell(chatRoom: searchController.isActive ? filteredChatRooms[indexPath.row] :  allChatRooms[indexPath.row])
    return cell
    }


    
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomObjeect =  searchController.isActive ? filteredChatRooms[indexPath.row] : allChatRooms[indexPath.row]
        
        goToMessage(chatRoom: chatRoomObjeect)
        
    }
    
    
    
    
    
    
    
    private func downlaodChatRooms(){
        
        FChatRoomListener.shared.downloadChatRooms { (allFBChatRooms) in
            
            self.allChatRooms = allFBChatRooms
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- Navigation
    
    func  goToMessage(chatRoom: ChatRoom) {
        
        //MARK:- To make sure that both users have chatrooms
        
        restartChat(chatRoomId: chatRoom.chatRoomId, memberIds: chatRoom.memberIds)
        
        let privateMessageView = MessageVC(chatId: chatRoom.chatRoomId, recipientId: chatRoom.receiverId, recipientName: chatRoom.receiverName)
        
        navigationController?.pushViewController(privateMessageView, animated: true)
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
