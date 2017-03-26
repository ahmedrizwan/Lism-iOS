//
//  MainViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 04/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var languageButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let languageFont = UIFont(name: "Arial", size: 16.0)
        let attributedLanguageTitleString = NSAttributedString(string: "Chinese/English", attributes: [NSFontAttributeName: languageFont!, NSForegroundColorAttributeName: UIColor(colorLiteralRed: 108.0/255.0, green: 108.0/255.0, blue: 108.0/255.0, alpha: 1.0)])
        button.setAttributedTitle(attributedLanguageTitleString, for: .normal)
        
        return button
    }()
    lazy var enterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "Arial", size: 32.0)
        let attributedTitleString = NSAttributedString(string: "Enter", attributes: [NSFontAttributeName: font!, NSForegroundColorAttributeName: UIColor(colorLiteralRed: 129.0/255.0, green: 4.0/255.0, blue: 21.0/255.0, alpha: 1.0)])
        button.setAttributedTitle(attributedTitleString, for: .normal)
        
        return button
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(colorLiteralRed: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(onLoginButtonPress), for: .touchUpInside)
        
        return button
    }()
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(colorLiteralRed: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(onRegisterButtonPress), for: .touchUpInside)
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.loginButton, self.registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(languageButton)
        let pinToRightConstraint = NSLayoutConstraint(item: languageButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -16.0)
        let pinToTopConstraint = NSLayoutConstraint(item: languageButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 24.0)
        view.addConstraints([pinToTopConstraint, pinToRightConstraint])
        
        view.addSubview(enterButton)
        let verticallyCenterConstraint = NSLayoutConstraint(item: enterButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let horizontallyCenterConstraint = NSLayoutConstraint(item: enterButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraints([verticallyCenterConstraint, horizontallyCenterConstraint])

        view.addSubview(stackView)
        let pinToBottomConstraint = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.width)
        view.addConstraints([pinToBottomConstraint, widthConstraint])
        
    }
    
    // MARK: IBActions
    
    @IBAction func onLoginButtonPress() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func onRegisterButtonPress() {
        let registrationViewController = RegistrationViewController()
        navigationController?.pushViewController(registrationViewController, animated: true)
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
