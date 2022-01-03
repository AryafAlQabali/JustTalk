//
//  SceneDelegate.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 15/05/1443 AH.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var authListener: AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
              guard let _ = (scene as? UIWindowScene) else { return }
        
        autoLogin()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
        }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        LocationManager.shared.startUpdating()
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
        LocationManager.shared.stopUpdating()
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        LocationManager.shared.stopUpdating()
        
        
    }
    func autoLogin(){
        authListener = Auth.auth().addStateDidChangeListener({ auth, user in
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            if user != nil && userDefaults.object(forKey: kCURRENTUSER) != nil {
                
                DispatchQueue.main.async {
                    self.gotToApp()
                    
                }
                
                
              
            }
        })
    }
    private func gotToApp() {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        
        
        self.window?.rootViewController = mainView
    }


}

