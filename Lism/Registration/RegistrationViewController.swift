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
        
        return label
    }()
    
    lazy var fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Full Name"
        
        return textField
    }()
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        
        return textField
    }()
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "UserName"
        
        return textField
    }()
    lazy var passwordTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        
        return textField
    }()
    lazy var rePasswordTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Re-Type Password"
        
        return textField
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.titleLabel, self.fullNameTextField, self.emailTextField, self.usernameTextField, self.passwordTextField, self.rePasswordTextField])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        view.addSubview(stackView)
        view.addConstraints([centerXStackView, centerYStackView])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
