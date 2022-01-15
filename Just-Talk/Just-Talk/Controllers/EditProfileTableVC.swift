//
//  EditProfileTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 19/05/1443 AH.
//

import UIKit
import Gallery
import ProgressHUD




class EditProfileTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        showUserInfo()
        configureTextField()
   
    }
    
    var gallery : GalleryController!
    
 //MARK:- IBOutlets
    
    @IBOutlet weak var avatarImageViewOutlet: UIImageView!
    
    @IBOutlet weak var usernameTextFieldOutlet: UITextField!
    
    @IBOutlet weak var statusLabOutlet: UILabel!
    
    
    
    
    
    //MARK:- IBAction
    @IBAction func editButPressed(_ sender: UIButton) {
        
        showImageGallery()
        
    }
    
    
    
    
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileToStatusSegue", sender: self)
        }
    }

    
    
    
    //MARK:- Show user info
    
    private func showUserInfo() {
        
        if let user = User.currentUser {
            
            usernameTextFieldOutlet.text = user.username
            statusLabOutlet.text = user.status.localized
        
            
            
            if user.avatarLink != "" {
                 
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImageViewOutlet.image = avatarImage?.circleMasked
                }
    
        }
    }
}
    
    
}


extension EditProfileTableVC: UITextFieldDelegate {
    
    //MARK:- Configure Textfield
    
    private func configureTextField() {
        
        usernameTextFieldOutlet.delegate = self
        usernameTextFieldOutlet.clearButtonMode = .whileEditing
        
    }
    //MARK:- Gallery
    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    //MARK:- Text field delegate function
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextFieldOutlet {
            
            if textField.text != "" {
                
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    FUserListener.shared.saveUserToFirestore(user)
                }
            }
            
            textField.resignFirstResponder()
            return false
        }
     return true
    }
    private func uploadImagePerson(_ image: UIImage) {
        
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        
        
        FileStorage.uploadeImage(image, directory: fileDirectory) { (avatarLink) in
            if var user = User.currentUser{
        
                
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FUserListener.shared.saveUserToFirestore(user)
        }
        //TODO:- Save image locally
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentId)
    }
        
    }
    
}



extension EditProfileTableVC:  GalleryControllerDelegate {
    
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            images.first!.resolve { (imagePerson) in
                if imagePerson != nil {
                    

                    self.uploadImagePerson(imagePerson!)
                    
                    self.avatarImageViewOutlet.image = imagePerson
                }else{
                    ProgressHUD.showError("Could not select image".localized)
                }
            }
        }
    
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
