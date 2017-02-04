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
        self.loginButton = UIButton()
        self.registerButton = UIButton()
        
        self.loginButton.setTitle("Login", for: .normal)
        self.registerButton.setTitle("Register", for: .normal)
        
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.loginButton.backgroundColor = UIColor(colorLiteralRed: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        self.loginButton.setTitleColor(UIColor(colorLiteralRed: 21.0/255.0, green: 21.0/255.0, blue: 21.0/255.0, alpha: 1.0), for: .normal)
        
        self.registerButton.backgroundColor = UIColor(colorLiteralRed: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
        self.registerButton.setTitleColor(UIColor.white, for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [self.loginButton, self.registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let pinToBottomConstraint = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.width)
        view.addConstraints([pinToBottomConstraint])
        view.addConstraints([widthConstraint])
        
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
