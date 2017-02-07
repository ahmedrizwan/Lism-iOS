//
//  RegistrationViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 07/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit

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
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.fullNameTextField, self.emailTextField, self.usernameTextField, self.passwordTextField, self.rePasswordTextField])
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
    
    var keyboardIsShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let nextButtonPinToBottomConstraint = NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let nextButtonWidthConstraint = NSLayoutConstraint(item: nextButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.width)
        view.addSubview(nextButton)
        view.addConstraints([nextButtonPinToBottomConstraint, nextButtonWidthConstraint])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
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

