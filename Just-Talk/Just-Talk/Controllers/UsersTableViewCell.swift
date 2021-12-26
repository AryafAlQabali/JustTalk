//
//  UsersTableViewCell.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 22/05/1443 AH.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
//MARK:- IBOutlet
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var usernameLblOutlet: UILabel!
    @IBOutlet weak var statusLblOutlet: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(user: User){
        usernameLblOutlet.text = user.username
        statusLblOutlet.text = user.status
        if user.avatarLink != "" {
            FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                self.imageViewOutlet.image = avatarImage?.circleMasked
            }
        }else {
            self.imageViewOutlet.image = UIImage(named: "profail")
        }
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
