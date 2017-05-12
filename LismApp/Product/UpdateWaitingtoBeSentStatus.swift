//
//  UpdateWaitingtoBeSentStatus.swift
//  LismApp
//
//  Created by Arkhitech on 8/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//
import AVOSCloud

import Foundation
class UpdateWaitingtoBeSentStatus: UIViewController,UITabBarDelegate
{
    var  productObj  : Product!

    @IBOutlet var imageView : UIImageView!
    @IBOutlet var orderNumLabel : UILabel!
    @IBOutlet var buyerInfoLabel : UILabel!
    @IBOutlet var buyerDetailTextView : UITextView!
    @IBOutlet var sizeLabel : UILabel!
    @IBOutlet var priceLabel : UILabel!
    @IBOutlet weak var progressBar : UIActivityIndicatorView!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!

    @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet var courierBtn : UIButton!
    @IBOutlet var confirmDeliveryBtn : UIButton!

    @IBOutlet var trackingField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "¥ \(self.productObj.sellingPrice)"
        orderNumLabel.text = "Order #: \(self.productObj.objectId!)"
        sizeLabel.text = "Size \(self.productObj.size)"
        trackingField.layer.borderWidth = 1.0
        self.courierBtn.setTitle("Courier 1", for: .normal)

        if(self.productObj.status == "Sent")
        {
            trackingField.isUserInteractionEnabled = false;
            trackingField.text = self.productObj.trackingNumber
            confirmDeliveryBtn.isHidden = true
            
        }
        
        
        trackingField.layer.borderColor = UIColor.gray.cgColor
        if(self.productObj.productImageUrl != nil)
        {
            self.imageView.sd_setImage(with: self.productObj.productImageUrl, placeholderImage: nil)
        }
        

        productObj.buyingUser.fetchIfNeededInBackground { (object, error) in
            if(error == nil)
            {
                self.buyerDetailTextView.text =   "\(object!.object(forKey: "fullName")!) \n \n\(self.productObj.address) \n \n\(object!.object(forKey: "mobilePhoneNumber")!)"
                           }
        }
        
        tabBar.selectedItem = selectedTabBarItem

        
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item",item.tag)
        
     
            if(item.tag == 2)
            {
                //load new view
                self.performSegue(withIdentifier: "SellUpdateToProfileViewcontroller", sender: self)
                
            }
           

      else  if(item.tag == 4)
        {
            //load new view
            self.performSegue(withIdentifier: "SellToProductView", sender: self)
        }
    }

    @IBAction func confirmDilveryAction (sender  : AnyObject)
    {
    
    self.updateProductInfo(productBO: self.productObj)
    }
    func updateProductInfo(productBO : Product)
    {
        let query: AVQuery = AVQuery(className: "Product")
        query.whereKey("objectId", equalTo: self.productObj.objectId!)
        query.getFirstObjectInBackground { (object, error) in
            productBO.setObject("Sent", forKey: "status")
            productBO.setObject(self.trackingField.text, forKey: "trackingNumber")

            productBO.saveInBackground  { (objects, error) in
                if(error == nil)
                {
                    AVUser.current()?.relation(forKey: Constants.SELL_PRODUCTS).add(productBO)
                        
                        AVUser.current()?.saveInBackground { (objects, error) in
                            
                            if(error == nil)
                            {
                                self.progressBar.isHidden = true
                                Constants.showAlert(message: "\(productBO.name)  has been shipped!", view: self)                                // show product has been posted and redirection
                                self.confirmDeliveryBtn.isHidden = true
                                print("show product has been posted and redirection")
                            }
                            else
                            {
                                //show error mesage
                            }
                        }
                    
                }
                
                
            }
        }
    }
    
    @IBAction func courierBtnAction (sender  : AnyObject)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Select Courier", message: "", preferredStyle: .actionSheet)
        let courierBtn1: UIAlertAction = UIAlertAction(title: "Courier 1", style: .default) { action -> Void in
            //Just dismiss the action sheet
            self.courierBtn.setTitle("Courier 1", for: .normal)
        }
        actionSheetController.addAction(courierBtn1)
        let courierBtn2: UIAlertAction = UIAlertAction(title: "Courier 2", style: .default) { action -> Void in
            self.courierBtn.setTitle("Courier 2", for: .normal)

            //Just dismiss the action sheet
        }
        actionSheetController.addAction(courierBtn2)

        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
  
    @IBAction func gobackAction (sender  : AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
