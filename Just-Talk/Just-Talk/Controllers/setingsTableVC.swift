//
//  setingsTableVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 19/05/1443 AH.
//

import UIKit

class setingsTableVC: UITableViewController {
    

    //MARK:- IBOutlets
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var usernameLblOutlet: UILabel!
    @IBOutlet weak var statusLblOutlet: UILabel!
    

    
    //MARK:- Lifecycle of table view

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
      
      

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }

    
    
    
    
    //MARK:- IBActions
   
    
    @IBAction func logoutButPressed(_ sender: UIButton) {

        FUserListener.shared.logoutCurrentUser { (error) in
            
            if error == nil {
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView")
                
                
                DispatchQueue.main.async {

                    loginView.modalPresentationStyle = .fullScreen
                    
                    self.present(loginView, animated: true, completion: nil)
                }
                
            }


        }
    }
    
    

 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            
            performSegue(withIdentifier: "SettingsToEditProfileSgue", sender: self)
        }
    }
    
    
    
    //MARK:- Update UI
    private func showUserInfo(){
        if let user = User.currentUser{
            usernameLblOutlet.text = user.username
            statusLblOutlet.text = user.status.localized
            
            
            if user.avatarLink != "" {

                
                //TODO Download and set avater image
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.imageOutlet.image = avatarImage?.circleMasked
                }
                
            }
        }
    }
 
    
    
    
    @IBAction func Language(_ sender: Any) {
        let chengelangu = UIAlertController(title: NSLocalizedString("The application will be restarted".localized, comment: ""), message: NSLocalizedString( "Choose your preferred language".localized,comment: ""), preferredStyle: .actionSheet)
        chengelangu.addAction(UIAlertAction(title: "Einglish".localized, style: .default, handler: { action in
              let currentlang = Locale.current.languageCode
              let newLanguage = currentlang == "en" ? "ar" : "en"
              UserDefaults.standard.setValue([newLanguage], forKey: "AppleLanguages")
              exit(0)
            }))
        chengelangu.addAction(UIAlertAction(title: "Arabic".localized, style: .default, handler: {action in
              let currentlang = Locale.current.languageCode
              let newLanguage = currentlang == "en" ? "ar" : "ar"
              UserDefaults.standard.setValue([newLanguage], forKey: "AppleLanguages")
              exit(0)
            }))
        chengelangu.addAction(UIAlertAction(title:NSLocalizedString("Cancel".localized, comment: ""), style: .cancel, handler: nil))
            present(chengelangu, animated: true, completion: nil)
          }

    
    
    
   
    @IBAction func privacyPolicy(_ sender: Any) {
    
        let alert = UIAlertController(title: "If you require more information or have any questions about the Privacy Policy, please feel free to contact us via the following email: aryafalq4@gmail.com ".localized, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
        
        
        let settings = UIAlertAction(title: "Privacy Policy".localized, style: .default, handler: { (action) -> Void in

            
            UIApplication.shared.open(URL(string: "https://www.termsfeed.com/live/246d14d2-af78-4616-b064-13fe64ef3443")!, options: [:], completionHandler: nil)
            
        })
        
        alert.addAction(settings)
        self.present(alert, animated: true, completion: nil)
    
    }
}

