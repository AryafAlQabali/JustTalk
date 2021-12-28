//
//  ChatRoomTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 23/05/1443 AH.
//

import UIKit

class ChatRoomTableVC: UITableViewController {

    //MARK:- Vars
    var allChatRooms:[ChatRoom] = []
    var filteredChatRooms:[ChatRoom] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        downlaodChatRooms()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allChatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
        
        
        
//
//        let chatRoom = ChatRoom(id: "123", chatRoomId: "123", senderId: "123", senderName: "Azhar", receiverId: "123", receiverName: "Aljrboa", date: Date(), memberId: [""], lastMessage: "Hello zozh , how are you? ", unreadCounter: 1, avaterLink: "")
//
        cell.configureCell(chatRoom: allChatRooms[indexPath.row])
    return cell
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
    
    
    
    
    private func downlaodChatRooms(){
        
        FChatRoomListener.shared.downloadChatRooms { (allFBChatRooms) in
            
            self.allChatRooms = allFBChatRooms
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}

