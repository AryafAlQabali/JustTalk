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
        registerOutlet.layer.cornerRadius = 6
        emailLblOutlet.text = ""
        passwordLblOutlet.text = ""
        confirmPasswordLblOutlet.text = ""
        
        emailTextFieldOutlet.delegate = self
        passwordTextFieldOutlet.delegate = self
        confirmPasswordTextFieldOutlet.delegate = self

        setupBagroundTap()

        
        imageicon.image = UIImage(named: "closeEye")
        let contenView = UIView()
        
        contenView.addSubview(imageicon)
        
        contenView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.height)
        
        imageicon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeEye")!.size.width, height: UIImage(named: "closeEye")!.size.height)
      
        passwordTextFieldOutlet.rightView = contenView
        passwordTextFieldOutlet.rightViewMode = .always
        
//        confirmPasswordTextFieldOutlet.rightView = contenView
//        confirmPasswordTextFieldOutlet.rightViewMode = .always

        
        let tapGesturRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGesturRecognizer:)))
        
        imageicon.isUserInteractionEnabled = true
        imageicon.addGestureRecognizer(tapGesturRecognizer)
        
    }

    
    
    //MARK:- Variables
    var isLogin: Bool = false
    
      var iconClick = false
      let imageicon = UIImageView()
    
    
    
//MARK:- IBOutlets
    
   
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var emailLblOutlet: UILabel!
    @IBOutlet weak var passwordLblOutlet: UILabel!
    @IBOutlet weak var confirmPasswordLblOutlet: UILabel!
    @IBOutlet weak var haveAnAccountOutlet: UILabel!
    
    
    
    //MARK:- View
    @IBOutlet weak var viewEmailOutlet: UIView!
    @IBOutlet weak var viewPasswordOutlet: UIView!
    @IBOutlet weak var viewConfirmPasswordOutlet: UIView!
    
   
    
    
    
    
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
            ProgressHUD.showError("All fields are required".localized)
      
    }
    }
    @IBAction func resendEmailPressed(_ sender: UIButton) {
       // print("resendEmailPressed")
        
        resendVerficationEmail()
        
        
        
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if isDataInputedFor(mode: isLogin ? "login" : "register") {
            
            isLogin ? loginUser() : registreUser()
            
        
            //TODO:- LOGIN or Register
            
            //Register
           
        }else{
            ProgressHUD.showError("All fields are required".localized)
        }
        
        
        
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        updateUIMode(mode: isLogin)
    }
    
    
    private func updateUIMode(mode: Bool) {
        
        if !mode {
            titleOutlet.text = "Welcome Back!".localized
            confirmPasswordLblOutlet.isHidden = true
            confirmPasswordTextFieldOutlet.isHidden = true
            registerOutlet.setTitle("Login".localized, for: .normal)
            loginOutlet.setTitle("Register".localized, for: .normal)
            haveAnAccountOutlet.text = "Don't have an account?".localized
            forgetPasswordOutlet.isHidden = false
            resendEmailOutlet.isHidden = true
            viewConfirmPasswordOutlet.isHidden = true
        } else {
            titleOutlet.text = "Create Account".localized
            confirmPasswordLblOutlet.isHidden = false
            confirmPasswordTextFieldOutlet.isHidden = false
            registerOutlet.setTitle("Register".localized, for: .normal)
            loginOutlet.setTitle("Login".localized, for: .normal)
            haveAnAccountOutlet.text = "Already have account?".localized
            resendEmailOutlet.isHidden = false
            forgetPasswordOutlet.isHidden = true
            viewConfirmPasswordOutlet.isHidden = false
          
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
                ProgressHUD.showSuccess("Reset password email has email been sent".localized)
            }else {
                ProgressHUD.showFailed("There is no user record corresponding to this identifier.The user may have been deleted".localized)
                
                
               // ================
    }
    
        }
    }
    
    
    
    
    
    
    
    
    
    //MARK:- Register User
    
    private func registreUser(){
      
        
            if passwordTextFieldOutlet.text == confirmPasswordTextFieldOutlet.text! {
                FUserListener.shared.registerUserWith(email: emailTextFieldOutlet.text!, password: passwordTextFieldOutlet.text!) { (error) in
                    if error == nil {
                        ProgressHUD.showSuccess("Verification email sent, please verify your email and confirm the registeratio".localized)
                        
                    }else{
                        ProgressHUD.showError("The email address or password is incorrect".localized)
                    }
                }
            }
        
    }
    
    
    private func resendVerficationEmail() {
        FUserListener.shared.resendVerficationEmailWith(email: emailTextFieldOutlet.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Verification email sent successfully".localized)
            }else {
                ProgressHUD.showFailed("We have blocked all requests from this device due to unusual activity. try again later".localized)
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
                ProgressHUD.showFailed("Please check your email and verify your registraion".localized)
            }
            
            } else {
                ProgressHUD.showFailed("Incorrect email or wrong password".localized)
            
        }
    }
    
}
    
    @objc func imageTapped(tapGesturRecognizer:UITapGestureRecognizer){
        let tappedImage = tapGesturRecognizer.view as! UIImageView
        
        if iconClick {
            iconClick = false
            tappedImage.image = UIImage(named: "openEye")
            passwordTextFieldOutlet.isSecureTextEntry = false
            
            confirmPasswordTextFieldOutlet.isSecureTextEntry = false
        }else{
            iconClick = true
            tappedImage.image = UIImage(named: "closeEye")
            passwordTextFieldOutlet.isSecureTextEntry = true
            
            confirmPasswordTextFieldOutlet.isSecureTextEntry = true
        }
   
    }
    
    
    //MARK:- Navigation
    private func  gotToApp() {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    

    
    
}


//MARK:- UI Text Delegate

extension LoginVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLblOutlet.text = emailTextFieldOutlet.hasText ? "Email".localized : ""
        passwordLblOutlet.text = passwordTextFieldOutlet.hasText ? "Password".localized : ""
        confirmPasswordLblOutlet.text = confirmPasswordTextFieldOutlet.hasText ? "Confirm Password".localized : ""

    }
}


