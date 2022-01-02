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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        autoLogin()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        LocationManager.shared.stopUpdating()
        
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

