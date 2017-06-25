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

    @IBOutlet var firstNameTextField : UITextField!
    @IBOutlet var lastNameTextField : UITextField!
    @IBOutlet var emailTextField : UITextField!

    @IBOutlet var usernameTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var retypePasswordTextField : UITextField!

    @IBOutlet var nextBtn : UIButton!

      var keyboardIsShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Digits.sharedInstance().logOut()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.styleTextField(textField: usernameTextField)
        self.styleTextField(textField: passwordTextField)
        self.styleTextField(textField: retypePasswordTextField)
        self.styleTextField(textField: emailTextField)
        self.styleTextField(textField: firstNameTextField)
        self.styleTextField(textField: lastNameTextField)

        nextBtn.setTitle("NEXT".localized(using: "Main"), for: .normal)


        
    }
    func styleTextField(textField : UITextField)
    {
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.gray.cgColor

    
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
        avUser.setObject("\(firstNameTextField.text!) \(lastNameTextField.text!)", forKey: "fullName")
        avUser.signUpInBackground { (result, error) in
            if error == nil {
                self.verifyPhoneNumber()
            } else {
                print("ERROR Signing UP \(error)")
                Constants.showAlert(message: error!.localizedDescription, view: self)
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
                
               // AVInstallation.current().addUniqueObject(AVUser.current()?.objectId! as Any, forKey: "channels")

                avUser?.saveEventually()
            } else {
                avUser?.deleteEventually()
                print("Auth error \(error!.localizedDescription)")
            }
        })
        
    }
    
    // MARK: - Button Actions
    
  @IBAction  func onNextButtonPress() {

        if let fullName = firstNameTextField.text, fullName.characters.count == 0   || lastNameTextField.text?.characters.count == 0 {
           
            Constants.showAlert(message: "Please enter name".localized(using: "Main"), view: self)
            
        } else if let email = emailTextField.text, email.characters.count == 0 {
            Constants.showAlert(message: "Please enter email".localized(using: "Main"), view: self)

            
        } else if let email = emailTextField.text, !email.isValidEmail() {
            
            Constants.showAlert(message: "Email not valid".localized(using: "Main"), view: self)

        } else if let username = usernameTextField.text, username.characters.count == 0 {
            Constants.showAlert(message: "Please enter username".localized(using: "Main"), view: self)

            
        } else if let password = passwordTextField.text, !password.isValidPassword() {
            Constants.showAlert(message:  "Password length should be greater than 6".localized(using: "Main"), view: self)

        } else if let password = passwordTextField.text, let rePassword = retypePasswordTextField.text, password != rePassword {
            Constants.showAlert(message:  "Password do not match".localized(using: "Main"), view: self)

            
        } else {
            registerAVUser()
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
        case firstNameTextField:
            emailTextField.becomeFirstResponder()
            break
        case emailTextField:
            usernameTextField.becomeFirstResponder()
            break
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            retypePasswordTextField.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        
        return false
    }
    
}
