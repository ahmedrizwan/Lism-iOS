//
//  RegistrationViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 07/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit
import AVOSCloud
import DigitsKit

class RegistrationViewController: UIViewController {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "Arial", size: 32.0)
        let attributedTitleString = NSAttributedString(string: "Register Your LisM", attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: font!])
        label.attributedText = attributedTitleString
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var validationLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.font = UIFont(name: "Arial", size: 16.0)
        
        return label
    }()
    
    lazy var fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Full Name"
        textField.returnKeyType = .next
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        return textField
    }()
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.returnKeyType = .next
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        return textField
    }()
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "UserName"
        textField.returnKeyType = .next
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        return textField
    }()
    lazy var passwordTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.returnKeyType = .next
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        return textField
    }()
    lazy var rePasswordTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Re-Type Password"
        textField.returnKeyType = .next
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        return textField
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor.gray
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(onNextButtonPress), for: .touchUpInside)
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.validationLabel, self.fullNameTextField, self.emailTextField, self.usernameTextField, self.passwordTextField, self.rePasswordTextField])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 16.0
        
        return sv
    }()
    
    lazy var centerXStackView: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.stackView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        return constraint
    }()
    lazy var centerYStackView: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.stackView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        return constraint
    }()
    lazy var widthStackViewConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 240.0)
        
        return constraint
    }()
    
    lazy var nextButtonPinToBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.nextButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        return constraint
    }()
    lazy var nextButtonWidthConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.nextButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.width)
        
        return constraint
    }()
    
    var keyboardIsShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Digits.sharedInstance().logOut()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        view.backgroundColor = UIColor.white
        view.addSubview(stackView)
        view.addConstraints([centerXStackView, centerYStackView, widthStackViewConstraint])
        
        view.addSubview(titleLabel)
        let titleLabelCenterXConstraint = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let titleLabelTrailingStackViewConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: -110.0)
        view.addConstraints([titleLabelCenterXConstraint, titleLabelTrailingStackViewConstraint])
        
        view.addSubview(nextButton)
        view.addConstraints([nextButtonPinToBottomConstraint, nextButtonWidthConstraint])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - AV Actions
    
    func registerAVUser() {
        let avUser = AVUser()
        avUser.username = usernameTextField.text!
        avUser.password = passwordTextField.text!
        avUser.email = emailTextField.text!
        avUser.setObject(fullNameTextField.text!, forKey: "fullName")
        avUser.signUpInBackground { (result, error) in
            if error == nil {
                self.verifyPhoneNumber()
            } else {
                print("ERROR Signing UP \(error)")
            }
        }
    }
    
    // MARK: - Digits Actions
    
    func verifyPhoneNumber() {
        Digits.sharedInstance().authenticate(completion: { (session, error) in
            let avUser = AVUser.current()
            if session != nil {
                let phoneNumber = session!.phoneNumber!
                let message = "Phone Number: \(phoneNumber)"
                let alertController = UIAlertController(title: "You are Logged in!", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
                self.present(alertController, animated: true, completion: .none)
                avUser?.setObject(phoneNumber, forKey: "mobilePhoneNumber")
                avUser?.saveEventually()
            } else {
                avUser?.deleteEventually()
                print("Auth error \(error!.localizedDescription)")
            }
        })
        
    }
    
    // MARK: - Button Actions
    
    func onNextButtonPress() {

        if let fullName = fullNameTextField.text, fullName.characters.count == 0 {
            validationLabel.text = "Please enter name"
        } else if let email = emailTextField.text, email.characters.count == 0 {
            validationLabel.text = "Please enter email"
        } else if let email = emailTextField.text, !email.isValidEmail() {
            validationLabel.text = "Email not valid"
        } else if let username = usernameTextField.text, username.characters.count == 0 {
            validationLabel.text = "Please enter username"
        } else if let password = passwordTextField.text, !password.isValidPassword() {
            validationLabel.text = "Password length should be greater than 6"
        } else if let password = passwordTextField.text, let rePassword = rePasswordTextField.text, password != rePassword {
            validationLabel.text = "Password do not match"
        } else {
            registerAVUser()
        }
    }
    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if(!keyboardIsShowing) {
            keyboardIsShowing = true
            
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
        keyboardIsShowing = false
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

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case fullNameTextField:
            emailTextField.becomeFirstResponder()
            break
        case emailTextField:
            usernameTextField.becomeFirstResponder()
            break
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            rePasswordTextField.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        
        return false
    }
    
}
