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
class CheckoutViewController: UIViewController
{
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
        addressButton.setTitle("Add New Address".localized(using: "Main"), for: .normal)
        checkOutBtn.setTitle("CHECKOUT".localized(using: "Main"), for: .normal)
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
 
    
}

