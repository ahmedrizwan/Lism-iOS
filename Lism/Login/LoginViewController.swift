//
//  LoginViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 05/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var stackView: UIStackView!
    
    var logoImageView: UIImageView!
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    
    var loginButton: UIButton!
    var forgotPasswordButton: UIButton!
    
    var centerYStackView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.placeholder = "Phone/Email/Username"
        usernameTextField.autocapitalizationType = .none
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.black
        
        forgotPasswordButton = UIButton()
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.setTitleColor(UIColor.blue, for: .normal)
        
        let image = UIImage()
        logoImageView = UIImageView(image: image)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewHeightConstraint = NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        logoImageView.addConstraints([imageViewHeightConstraint])
        
        stackView = UIStackView(arrangedSubviews: [logoImageView, usernameTextField, passwordTextField, loginButton, forgotPasswordButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        let centerXStackView = NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        centerYStackView = NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        view.addConstraints([centerXStackView, centerYStackView])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if(centerYStackView.constant == 0) {
            
            if let keyboardFrame = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]! as? CGRect {
                let finalFrame = view.convert(keyboardFrame, from: nil)
                centerYStackView.constant = stackView.frame.origin.y + finalFrame.size.height * -1
            }
            
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        centerYStackView.constant = 0.0
        UIView.animate(withDuration: 1.0) { 
            self.view.layoutIfNeeded()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
