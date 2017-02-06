//
//  LoginViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 05/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var logoImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        imageView.addConstraints([imageViewHeightConstraint])
        
        return UIImageView(image: image)
    }()
    
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Phone/Email/Username"
        textField.autocapitalizationType = .none
        
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.black
        
        return button
    }()
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot Password", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let sV = UIStackView(arrangedSubviews: [self.logoImageView, self.usernameTextField, self.passwordTextField, self.loginButton, self.forgotPasswordButton])
        sV.translatesAutoresizingMaskIntoConstraints = false
        sV.axis = .vertical
        sV.distribution = .fill
        sV.spacing = 16.0
        
        return sV
    }()
    
    lazy var centerXStackView: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.stackView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        return constraint
    }()
    lazy var centerYStackView: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.stackView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        return constraint
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

        view.backgroundColor = UIColor.white

        view.addSubview(stackView)
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
