//
//  ProductStatusViewController.swift
//  LismApp
//
//  Created by Arkhitech on 28/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//
import AVOSCloud
import Foundation
class ProductStatusViewController : UIViewController
{
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productBO: Product!
    @IBOutlet var first_Btn : UIButton!
    @IBOutlet var secon_Btn : UIButton!
    @IBOutlet var third_Btn : UIButton!
    @IBOutlet var forth_Btn : UIButton!

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var orderNumber: UILabel!
    @IBOutlet var waitingToSentLabel: UILabel!
    @IBOutlet var timeRemainingToSendLabel: UILabel!
    
    @IBOutlet var itemHasBeenSentLabel: UILabel!
    @IBOutlet var namePhoneAddressTextView: UITextView!

    @IBOutlet var itemhasBeenReceivedLabel: UILabel!
    @IBOutlet var dateTimeTextview: UITextView!
    
    @IBOutlet var itemhasBeenConfirmedLabel: UILabel!

    override func viewDidLoad()
    {
        self.userImageView.layer.cornerRadius =  self.userImageView.frame.size.width/2
        self.userImageView.clipsToBounds = true
        
        self.productImageView.sd_setImage(with: productBO.productImageUrl, placeholderImage: nil)
        secon_Btn.isSelected = true
        self.userNameLabel.text = AVUser.current()?.username
        namePhoneAddressTextView.text = "Name : \(AVUser.current()?.username)\nPhone : +9238768768376 \nAddress : this is dummy address value I am placing this text here for testing purpose,we will update it later."
        dateTimeTextview.text = "Date Recieved : 24-may - 2017\nTime Recieved : 11:00am"

    }
    
    @IBAction func confirmOrder(sender:AnyObject)

    {
    
    }
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }

}
