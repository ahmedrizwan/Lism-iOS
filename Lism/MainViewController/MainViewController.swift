//
//  MainViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 04/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var languageButton: UIButton!
    var enterButton: UIButton!
    var loginButton: UIButton!
    var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        languageButton = UIButton()
        languageButton.translatesAutoresizingMaskIntoConstraints = false
        let languageFont = UIFont(name: "Arial", size: 16.0)
        let attributedLanguageTitleString = NSAttributedString(string: "Chinese/English", attributes: [NSFontAttributeName: languageFont!, NSForegroundColorAttributeName: UIColor(colorLiteralRed: 108.0/255.0, green: 108.0/255.0, blue: 108.0/255.0, alpha: 1.0)])
        languageButton.setAttributedTitle(attributedLanguageTitleString, for: .normal)
        view.addSubview(languageButton)
        let pinToRightConstraint = NSLayoutConstraint(item: languageButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -16.0)
        let pinToTopConstraint = NSLayoutConstraint(item: languageButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 24.0)
        view.addConstraints([pinToTopConstraint, pinToRightConstraint])
        
        enterButton = UIButton()
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "Arial", size: 32.0)
        let attributedTitleString = NSAttributedString(string: "Enter", attributes: [NSFontAttributeName: font!, NSForegroundColorAttributeName: UIColor(colorLiteralRed: 129.0/255.0, green: 4.0/255.0, blue: 21.0/255.0, alpha: 1.0)])
        enterButton.setAttributedTitle(attributedTitleString, for: .normal)
        view.addSubview(enterButton)
        let verticallyCenterConstraint = NSLayoutConstraint(item: enterButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let horizontallyCenterConstraint = NSLayoutConstraint(item: enterButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraints([verticallyCenterConstraint, horizontallyCenterConstraint])
        
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor(colorLiteralRed: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        loginButton.setTitleColor(UIColor(colorLiteralRed: 21.0/255.0, green: 21.0/255.0, blue: 21.0/255.0, alpha: 1.0), for: .normal)
        
        registerButton = UIButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = UIColor(colorLiteralRed: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        registerButton.setTitleColor(UIColor.white, for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [loginButton, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let pinToBottomConstraint = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.width)
        view.addConstraints([pinToBottomConstraint, widthConstraint])
        
    }
    
    // MARK: IBActions
    
    @IBAction func onLoginButtonPress() {
        
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
