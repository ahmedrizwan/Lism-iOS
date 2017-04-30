//
//  CheckoutViewController.swift
//  LismApp
//
//  Created by Arkhitech on 30/4/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//
import AVOSCloud
import Foundation
class CheckoutViewController: UIViewController
{
    @IBOutlet weak var progressView : UIActivityIndicatorView!

    @IBOutlet var textViewForAddress : UITextView!
    var checkoutArray : [Product] = []
    var avobjectsArray : [AVObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutArray.removeAll()
        textViewForAddress.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueCheckOutbuttonAction(sender : AnyObject)
    {
        let relation =       AVUser.current()?.relation(forKey: Constants.USER_CART)
        relation?.query().findObjectsInBackground { (objects, error) in
            
            if error == nil
            {
            for obj in objects!
            {
                relation?.remove(obj as! AVObject)
                let productObj:Product =  obj as! Product
                productObj.setObject(AVUser.current(), forKey: "user")
                productObj.setObject("Waiting to be Sent", forKey: "status")
                productObj.setObject(self.textViewForAddress.text, forKey: "address")
                self.checkoutArray.append(productObj)
                self.avobjectsArray.append(obj as! AVObject)
            }
                AVObject.saveAll(inBackground: self.avobjectsArray, block: { (objects, error) in
                    
                    if error == nil
                    {
                        AVUser.current()?.saveInBackground({ (objects, error) in

                            if error == nil
                            {
                            Constants.showAlert(message: "Order placed (without payment)!", view: self)
                            }
                        })
                    
                    }
                })
        }

    }
    }

    
}

