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
    @IBAction func tellFriendButPressed(_ sender: UIButton) {
        print("tell a friend")
    }
    @IBAction func termsButPressed(_ sender: UIButton) {
        print("terms and conditions")
    }
    
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
    
    
    //MARK:- Table Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableView")
        return headerView
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 0.0: 10.0
//
//    }
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

    
    @IBAction func darkAndLight(_ sender: Any) {
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
            if (sender as AnyObject).isOn {
                appDelegate?.overrideUserInterfaceStyle = .dark
                return
            }
            appDelegate?.overrideUserInterfaceStyle = .light
            return
        }
    }
    
    @IBAction func Language(_ sender: Any) {
        
        let alert = UIAlertController(title: "You can change your language by going to your device settings.".localized, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
        
        
        let settings = UIAlertAction(title: "See Settings".localized, style: .default, handler: { (action) -> Void in

            
            UIApplication.shared.open(URL(string: "App-Prefs:root=GENERAL")!, options: [:], completionHandler: nil)
            
        })
        
        alert.addAction(settings)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

