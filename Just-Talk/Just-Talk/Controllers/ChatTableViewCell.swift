//
//  ChatTableViewCell.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 23/05/1443 AH.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    
    
    
    
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var avatarImgOutlet: UIImageView!
    @IBOutlet weak var usernameLblOutlet: UILabel!
    @IBOutlet weak var lastMessageLblOutlet: UILabel!
    @IBOutlet weak var dateLblOutlet: UILabel!
    @IBOutlet weak var unreadCounterLblOutlet: UILabel!
    @IBOutlet weak var unreadCounterViewOutlet: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unreadCounterViewOutlet.layer.cornerRadius = unreadCounterViewOutlet.frame.width / 2
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell (chatRoom: ChatRoom) {
        usernameLblOutlet.text = chatRoom.receiverName
        usernameLblOutlet.minimumScaleFactor = 0.9
        
        
        
        lastMessageLblOutlet.text = chatRoom.lastMessage
        lastMessageLblOutlet.numberOfLines = 2
        lastMessageLblOutlet.minimumScaleFactor = 0.9
        
        if chatRoom.unreadCounter != 0 {
            self.unreadCounterLblOutlet.text = "\(chatRoom.unreadCounter)"
            self.unreadCounterViewOutlet.isHidden =  false
        }else {
            self.unreadCounterViewOutlet.isHidden = true
        }
        
        if chatRoom.avaterLink != "" {
            FileStorage.downloadImage(imageUrl: chatRoom.avaterLink) { (avatarImage) in
                self.avatarImgOutlet.image = avatarImage?.circleMasked
            }
        } else {
            self.avatarImgOutlet.image = UIImage(named: "profail")
        }
        dateLblOutlet.text = timeElapsed(chatRoom.date ?? Date())
    }
    
    
    
}
