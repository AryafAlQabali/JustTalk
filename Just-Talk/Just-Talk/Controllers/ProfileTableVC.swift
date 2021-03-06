//
//  ProfileTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 22/05/1443 AH.
//

import UIKit

class ProfileTableVC: UITableViewController {

    var user: User?
    
    //MARK:- IBOutlet
    @IBOutlet weak var avatarimageViewOutlet: UIImageView!
    @IBOutlet weak var usernameLblOutlet: UILabel!
    @IBOutlet weak var statusLblOutlet: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        setupUI()
        

    }
    private func setupUI(){
        if user != nil {

            self.title = user?.username
            
            usernameLblOutlet.text = user?.username
            statusLblOutlet.text = user?.status
            
            if user?.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user!.avatarLink) { (avatarImage) in
                    self.avatarimageViewOutlet.image = avatarImage?.circleMasked
                }
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableView")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            print("Start chating")
        
            let chatId = startChat(sender: User.currentUser!, receiver: user!)
            
            
            let privateMessage = MessageVC(chatId: chatId, recipientId: user!.id, recipientName: user!.username)
            
            navigationController?.pushViewController(privateMessage, animated: true)
        }
    }

}
