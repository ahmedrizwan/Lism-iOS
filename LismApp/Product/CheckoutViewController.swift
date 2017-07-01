//
//  CheckoutViewController.swift
//  LismApp
//
//  Created by Arkhitech on 30/4/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//
import AVOSCloud
import Foundation
extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
class CheckoutViewController: UIViewController,UITextViewDelegate
{
    let PLACEHOLDER_TEXT = "Enter Address"

    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet var addressButton : UIButton!
    @IBOutlet var textViewForAddress : UITextView!
    @IBOutlet var paymentMethodLabel : UILabel!
    @IBOutlet var deliveryAddressLabel : UILabel!
    @IBOutlet var defaultAddressLabel : UILabel!

    @IBOutlet var addNewAddressBtn : UIButton!

    @IBOutlet var checkOutBtn : UIButton!

    var checkoutArray : [Product] = []
    var avobjectsArray : [AVObject] = []
    let relation = (AVUser.current()?.relation(forKey: "userCart"))! as AVRelation

    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutArray.removeAll()
//        textViewForAddress.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressView.isHidden = true
        addressButton.isSelected = true
        paymentMethodLabel.text = "PAYMENT METHOD".localized(using: "Main")
        deliveryAddressLabel.text = "DELIVERY ADDRESS".localized(using: "Main")
        defaultAddressLabel.text = "Default address".localized(using: "Main")
        addNewAddressBtn.setTitle("Add New Address".localized(using: "Main"), for: .normal)
        checkOutBtn.setTitle("CHECKOUT".localized(using: "Main"), for: .normal)
        textViewForAddress.layer.borderColor = UIColor.lightGray.cgColor
        
        textViewForAddress.layer.borderWidth = 1.0
        textViewForAddress.delegate = self
        applyPlaceholderStyle(aTextview: textViewForAddress, placeholderText: PLACEHOLDER_TEXT)

    }
    override func  viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.isHidden = true

    }
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueCheckOutbuttonAction(sender : AnyObject)
    {
        progressView.isHidden = false
      
        
        let query: AVQuery = relation.query()
        query.includeKey("user")
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil
            {
            for obj in objects!
            {

                self.relation.remove(obj as! AVObject)

               
                let productObj:Product =  obj as! Product
                 self.checkoutArray.append(productObj)
                productObj.setObject(AVUser.current(), forKey: "buyingUser")

                productObj.setObject(Constants.waiting_to_be_sent, forKey: "status")
                productObj.setObject(self.textViewForAddress.text, forKey: "address")

                self.avobjectsArray.append(productObj)
                self.avobjectsArray.append(Constants.getProductNotification(product: productObj, type: Constants.NotificationType.TYPE_SELL_BOUGHT))

            }
                AVObject.saveAll(inBackground:  self.avobjectsArray, block: { (objects, error) in

                    if error == nil
                    {
                       (AVUser.current())?.saveInBackground{ (objects, error) in
                            
                            if error == nil
                            {
                            
                                for product:Product in self.checkoutArray
                                {
                                Constants.sendPushToChannel(vc: self, channelInfo: product.user.objectId!, message: "\("Your product".localized(using: "Main")) \(product.name) \("has been sold!".localized(using: "Main"))", content: "")
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetUpdatedList"), object: nil)

                                
                                let alert = UIAlertController(title: "",message:"Order placed (without payment)!".localized(using: "Main"),
                                                              preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK".localized(using: "Main"),
                                                            style: UIAlertActionStyle.default,
                                                            handler: {(alert: UIAlertAction!) in self.navigationController?.backToViewController(viewController: ProductViewController.self)}))
                                self.present(alert, animated: true, completion: nil)
                                ///redirect to main view
                                

                            }
                            self.progressView.isHidden = true

                        }
                    
                    }
                })
        }

    }
    }
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
        
    }
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool
    {
        if aTextView == textViewForAddress && aTextView.text == PLACEHOLDER_TEXT
        {
            // move cursor to start
            //moveCursorToStart(aTextView: aTextView)
            aTextView.text = ""
        }
        return true
    }
    func moveCursorToStart(aTextView: UITextView)
    {
        aTextView.selectedRange = NSMakeRange(0, 0);
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            // check if the only text is the placeholder and remove it if needed
            // unless they've hit the delete button with the placeholder displayed
            if textView == textViewForAddress && textView.text == PLACEHOLDER_TEXT
            {
                if text.utf16.count == 0 // they hit the back button
                {
                    return false // ignore it
                }
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            applyPlaceholderStyle(aTextview: textView, placeholderText: PLACEHOLDER_TEXT)
            moveCursorToStart(aTextView: textView)
            return false
        }
    }
    

    
}

