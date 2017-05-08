//
//  UpdateWaitingtoBeSentStatus.swift
//  LismApp
//
//  Created by Arkhitech on 8/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
class UpdateWaitingtoBeSentStatus: UIViewController
{
    var  productObj  : Product!

    @IBOutlet var imageView : UIImageView!
    @IBOutlet var orderNumLabel : UILabel!
    @IBOutlet var buyerInfoLabel : UILabel!
    @IBOutlet var buyerDetailTextView : UITextView!
    @IBOutlet var sizeLabel : UILabel!
    @IBOutlet var priceLabel : UILabel!

    @IBOutlet var courierBtn : UIButton!
    @IBOutlet var trackingField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "¥ \(self.productObj.sellingPrice)"
        sizeLabel.text = self.productObj.size
        
        productObj.buyingUser.fetchIfNeededInBackground { (object, error) in
            if(error == nil)
            {
            
            
            }
        }
    }

    @IBAction func confirmDilveryAction (sender  : AnyObject)
    {
    
    
    }
    
    @IBAction func courierBtnAction (sender  : AnyObject)
    {
        
        
    }
}
