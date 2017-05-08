//
//  UpdateWaitingtoBeSentStatus.swift
//  LismApp
//
//  Created by Arkhitech on 8/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

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
    
    @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
    @IBOutlet var courierBtn : UIButton!
    @IBOutlet var trackingField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "¥ \(self.productObj.sellingPrice)"
        orderNumLabel.text = "Order #: \(self.productObj.objectId)"
        sizeLabel.text = "Size \(self.productObj.size)"
        tabBar.selectedItem = selectedTabBarItem

        productObj.buyingUser.fetchIfNeededInBackground { (object, error) in
            if(error == nil)
            {
                self.buyerDetailTextView.text =   "\(object?.object(forKey: "fullName")!) \n \n\(self.productObj.address) \n \n\(object?.object(forKey: "mobilePhoneNumber")!)"
                if(self.productObj.productImageUrl != nil)
                {
                    self.imageView.sd_setImage(with: self.productObj.productImageUrl, placeholderImage: nil)
                }

            }
        }
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item",item.tag)
        
        if(item.tag == 4)
        {
            //load new view
            }
        //This method will be called when user changes tab.
    }

    @IBAction func confirmDilveryAction (sender  : AnyObject)
    {
    
    
    }
    
    @IBAction func courierBtnAction (sender  : AnyObject)
    {
        
        
    }
    
    @IBAction func gobackAction (sender  : AnyObject)
    {
    }
}
