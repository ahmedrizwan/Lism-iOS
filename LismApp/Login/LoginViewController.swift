//
//  LoginViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 05/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit
import AVOSCloud

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        
        return result
    }
    
    func isValidPassword() -> Bool {
        
        return self.characters.count > 5
    }
}

class LoginViewController: UIViewController , UITextFieldDelegate{
    
    
    @IBOutlet var usernameTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var loginBtn : UIButton!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        usernameTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
      
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
       
        usernameTextField.layer.borderWidth =  0.5
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        loginBtn.setTitle("LOGIN".localized(using: "Main"), for: .normal)
    }
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if  (usernameTextField.text?.isValidEmail())! &&  (passwordTextField.text?.isValidPassword())!
        {
          loginBtn.backgroundColor =  UIColor(colorLiteralRed: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        return true
    }

    @IBAction func onLoginButtonPress() {
        if let isValidEmail = usernameTextField.text?.isValidEmail(), !isValidEmail {
            Constants.showAlert(message: "Please enter a valid username".localized(using: "Main"), view: self)
            
        } else if let isValidPassword = passwordTextField.text?.isValidPassword(), !isValidPassword {
            Constants.showAlert(message: "Password length should be greater than 5".localized(using: "Main"), view: self)

            
        } else {
            let query = AVUser.query()
            let username = usernameTextField.text!
            query.whereKey("email", equalTo: username)

            query.getFirstObjectInBackground({ (object, error) in
                if object !== nil {
                    let avUser = object as! AVUser
                    let avUsername = avUser.username!
                    
                    AVUser.logInWithUsername(inBackground: avUsername, password: self.passwordTextField.text!, block: { (user, error) in
                        if error == nil {
                            
                            //AVInstallation.current().addUniqueObject(AVUser.current()?.objectId! as Any, forKey: "channels")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn") //Bool
                             UserDefaults.standard.set(username, forKey: "username")
                           // self.showAlert(message: "Login Successful")
                            // TODO: do something here when login is successfull
                            
                        self.loadMainProductsView()
                        }
                        else {
                            self.showAlert(message: "Login Unsuccessful".localized(using: "Main"))
                            // TODO: do something here when login has failed
                        }
                    })
                }
            })
        }
        
    }
    
    func loadMainProductsView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductViewController")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func showAlert(message:String)
    {
        let alert = UIAlertController(title: "Alert",message:message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK",style:UIAlertActionStyle.default,handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Keyboard
      /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
