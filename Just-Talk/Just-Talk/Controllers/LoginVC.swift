//
//  ViewController.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 15/05/1443 AH.
//

import UIKit
import ProgressHUD

class LoginVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLblOutlet.text = ""
        passwordLblOutlet.text = ""
        confirmPasswordLblOutlet.text = ""
        
//        emailTextFieldOutlet.delegate = self
//        passwordTextFieldOutlet.delegate = self
//        confirmPasswordTextFieldOutlet.delegate = self
//
        setupBagroundTap()
        
        let email = UIImage(named: "email")
        addleftImg(textField: emailTextFieldOutlet, img: email!)
        let password = UIImage(named: "lock")
        addleftImg(textField: passwordTextFieldOutlet, img: password!)
        let confirpassword = UIImage(named: "lock")
        addleftImg(textField: confirmPasswordTextFieldOutlet, img: confirpassword!)
        
        
    }
    
    //MARK:- Variables
    var isLogin: Bool = false
    
    
    
//MARK:- IBOutlets
    
   
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var emailLblOutlet: UILabel!
    @IBOutlet weak var passwordLblOutlet: UILabel!
    @IBOutlet weak var confirmPasswordLblOutlet: UILabel!
    @IBOutlet weak var haveAnAccountOutlet: UILabel!
    
    
    
    
   
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    @IBOutlet weak var confirmPasswordTextFieldOutlet: UITextField!
    
    
    
    
    
   
    @IBOutlet weak var forgetPasswordOutlet: UIButton!
    @IBOutlet weak var resendEmailOutlet: UIButton!
   
    @IBOutlet weak var registerOutlet: UIButton!
    @IBOutlet weak var loginOutlet: UIButton!
    
    
    

    
    //MARK:- IBAction
    @IBAction func forgetPasswordPressed(_ sender: UIButton) {
        if isDataInputedFor(mode: "forgetPassword"){
            print("All data inputed correctly")
       
           forgetPassword()
            
        }else{
            ProgressHUD.showError("All fields are required")
      
    }
    }
    @IBAction func resendEmailPressed(_ sender: UIButton) {
        print("resendEmailPressed")
        
        resendVerficationEmail()
        
        
        
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if isDataInputedFor(mode: isLogin ? "login" : "register") {
            
            isLogin ? loginUser() : registreUser()
            
        
            //TODO:- LOGIN or Register
            
            //Register
           
        }else{
            ProgressHUD.showError("All fields are required")
        }
        
        
        
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        updateUIMode(mode: isLogin)
    }
    
    
    private func updateUIMode(mode: Bool) {
        
        if !mode {
            titleOutlet.text = "Login".localized
            confirmPasswordLblOutlet.isHidden = true
            confirmPasswordTextFieldOutlet.isHidden = true
            registerOutlet.setTitle("Login".localized, for: .normal)
            loginOutlet.setTitle("Register".localized, for: .normal)
            haveAnAccountOutlet.text = "Don't have an account?".localized
            forgetPasswordOutlet.isHidden = false
            resendEmailOutlet.isHidden = true
        } else {
            titleOutlet.text = "Register".localized
            confirmPasswordLblOutlet.isHidden = false
            confirmPasswordTextFieldOutlet.isHidden = false
            registerOutlet.setTitle("Register".localized, for: .normal)
            loginOutlet.setTitle("Login".localized, for: .normal)
            haveAnAccountOutlet.text = "Already have account?".localized
            resendEmailOutlet.isHidden = false
            forgetPasswordOutlet.isHidden = true
          
        }
        
        isLogin.toggle()
        
    }
    //MARK:- Helpers or Utilites
    private func isDataInputedFor (mode: String) -> Bool {
        switch mode {
        case "login":
            return emailTextFieldOutlet.text != "" && passwordTextFieldOutlet.text != ""
        case "register":
            return emailTextFieldOutlet.text != "" && passwordTextFieldOutlet.text != "" && confirmPasswordTextFieldOutlet.text != ""
        case "forgetPassword":
            return emailTextFieldOutlet .text != ""
            
        default:
            return false
        }
    }
    
    //MARK:-  Tap Gesture Recognizer
    private func setupBagroundTap(){
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard (){
        view.endEditing(false)
    }
    
    
    
    //MARK:- forget Password
    private func forgetPassword() {
        FUserListener.shared.resetPasswordFor(email: emailTextFieldOutlet.text!) { (error) in
            if error == nil{
                ProgressHUD.showSuccess("Reset password email has email been sent")
            }else {
                ProgressHUD.showFailed(error?.localizedDescription)
    }
    
        }
    }
    
    
    
    
    
    
    
    
    
    //MARK:- Register User
    
    private func registreUser(){
      
        
            if passwordTextFieldOutlet.text == confirmPasswordTextFieldOutlet.text! {
                FUserListener.shared.registerUserWith(email: emailTextFieldOutlet.text!, password: passwordTextFieldOutlet.text!) { (error) in
                    if error == nil {
                        ProgressHUD.showSuccess("Verification email sent, please verify your email and confirm the registeration")
                    }else{
                        ProgressHUD.showError(error?.localizedDescription)
                    }
                }
            }
        
    }
    
    
    private func resendVerficationEmail() {
        FUserListener.shared.resendVerficationEmailWith(email: emailTextFieldOutlet.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Verification email sent successfully")
            }else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    
    
    
    //MARK:- Login User
    private func loginUser (){
        FUserListener.shared.loginUserWith(email: emailTextFieldOutlet.text!, password: passwordTextFieldOutlet.text!){ ( error, isEmailVerified) in

            
            if error == nil {
            if isEmailVerified {
                
                self.gotToApp()
                
                
                
                print("Go to appliction")
                
                
            }else {
                ProgressHUD.showFailed("Please check your emaul and verify your registraion")
            }
            
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            
        }
    }
    
}
    //MARK:- Navigation
    private func  gotToApp() {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    
    
    //MARK:- TextFied test
    
    
    func addleftImg(textField:UITextField, img: UIImage) {
        let leftimgView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
        leftimgView.image = img
        textField.leftView = leftimgView
        textField.leftViewMode = .always
    }
    
}


//MARK:- UI Text Delegate
//
//extension LoginVC: UITextFieldDelegate {
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        emailLblOutlet.text = emailTextFieldOutlet.hasText ? "Email" : ""
//        passwordLblOutlet.text = passwordTextFieldOutlet.hasText ? "Password" : ""
//        confirmPasswordLblOutlet.text = confirmPasswordTextFieldOutlet.hasText ? "confirm Password" : ""
//
//    }
//}


