//
//  Constants.swift
//  LismApp
//
//  Created by Arkhitech on 25/3/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import AVFoundation
import  UIKit
import AVOSCloud

class Constants {

   static var currentUser: User = User()
    static var favoritesList : [Product] = [Product]()
    struct NotificationType
    {
        static let TYPE_FOLLOW         = "follow"
        static let TYPE_SELL_BOUGHT         = "bought"
        static let TYPE_SELL_SENT         = "sent"
        static let TYPE_SELL_CONFIRMED         = "confirmed"
        static let TYPE_COMMENT         = "commented"
        static let TYPE_LIKE         = "liked"


    
    }
    static let faq1_how_to_sell_an_item = "How do I sell an Item?"
    static let faq2_how_do_recv_payment = "How do I receive payment?"
    static let faq3_how_to_pay = "How do I pay for an Item?"
    static let faq4_price_items = "How should I price Items?"
    static let faq5_item_condition  = "What condition is my Item in?"
    static let faq6_how_shopping_words = "How does shipping work?"
    static let faq7_why_item_removed = "Why has my Item been removed?"
    static let faq8_what_can_i_sell = "What can I sell?"
    static let faq9_how_to_buy_safely = "How can I buy safely?"
    static let faq10_sell_safely = "How can I sell safely?"
    static let faq11_not_recvd_item = "I haven't received my Item"
    
    static let SETTINGS = "SETTINGS"
    static let SUPPORT = "SUPPORT"
    static let LEGAL = "LEGAL"
struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
    static func showAlert(message:String,view:UIViewController)
    {
        let alert = UIAlertController(title: "",message:message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK",style:UIAlertActionStyle.default,handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    static let waiting_to_be_sent = "Waiting to be Sent"
    static let sent = "Sent"

    static let posted_for_sale = "Posted for Sale"
     static let USER_CART = "userCart"
 static let sell_is_more = "LESS IS MORE"
static let sell_with_us_it_s_easy = "SELL WITH US IT\'S EASY"
    static let selling_is_fast_and_easy = "SELLING IS FAST AND EASY"
    static let selling_description = "Step1: Upload the item you wish to sell \nStep2: Receive confirmation within 24 hrs\nStep3: Adda captivating description and post it!"
    static let you_earn_more = "YOU EARN MORE"
    static let earn_more_description = "Receive up to 80% of the sale price for your items"
     static let SELL_PRODUCTS = "sellProducts"
static let time_remaining_text = "Time remaining for Seller to send Item : 2d"
    static let waiting_to_be_sent_status_text = "Waiting to be Sent"
  static  func produceAttributedTextForItems(string: String, textView : UITextView)
    {
        
        let attributedString = NSMutableAttributedString(string:string)
        attributedString.addAttribute(NSFontAttributeName , value: UIFont(name: "Avenir", size: CGFloat(14))!,range: NSMakeRange(0, attributedString.length))
        
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.maximumLineHeight = 15 // change line spacing between each line like 30 or 40
        
        paragraphStyle.alignment = NSTextAlignment.left
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 182.0/255.0, green: 182.0/255.0, blue: 182.0/255.0, alpha: 1.0), range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        textView.attributedText=attributedString
        
    }
    
 static   func produceAttributedText(string: String, textView : UITextView)
    {
        
        let attributedString = NSMutableAttributedString(string:string)
        attributedString.addAttribute(NSFontAttributeName , value: UIFont(name: "Avenir", size: CGFloat(9.5))!,range: NSMakeRange(0, attributedString.length))
        
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.75
        paragraphStyle.maximumLineHeight = 10 // change line spacing between each line like 30 or 40
        
        paragraphStyle.alignment = NSTextAlignment.center
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 182.0/255.0, green: 182.0/255.0, blue: 182.0/255.0, alpha: 1.0), range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        textView.attributedText=attributedString
        
    }
    static  func addShadow(button : UIButton)
    {
        
        
        // let shadowPath = UIBezierPath(rect: button.bounds).cgPath
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset =  CGSize(width: 0, height: 4)
        
        button.layer.shadowOpacity = 0.2
        //button.layer.masksToBounds = false
        // button.layer.shadowPath = shadowPath
        button.layer.cornerRadius = 0.5
        
    }
    static func getProductNotification ( product : Product , type : String)-> NotificationLog
    {
        let notifLog = NotificationLog()
        notifLog.setObject(product, forKey: "product")
        notifLog.setObject(product.user.objectId, forKey: "userId")
        notifLog.setObject(AVUser.current(), forKey: "otherUser")
        notifLog.setObject(type, forKey: "type")
        notifLog.setObject(false, forKey: "read")

        return notifLog
    }
    
    static func sendPushToChannel(vc : UIViewController, channelInfo: String , message : String , content : String )
    {
    let pushQuery = AVInstallation.query()
    pushQuery.whereKey("channels", contains: channelInfo)
        let push = AVPush()
        let jsonObject: [String: AnyObject] = [
          //  "content-available": "1" as AnyObject,
            "message": message as AnyObject,
            "content":content as AnyObject,
            "alert": "\(message) \(content)" as AnyObject
            
        ]
        //push.setQuery(pushQuery)
        push.setPushToIOS(true)
        push.setPushToAndroid(true)
        push.setData(jsonObject)
        push.setChannel(channelInfo)
     //   AVPush.setProductionMode(false)
        
        push.sendInBackground { (status, error) in
            print(status)
        }


    }
    
   static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
  static  func updateCount(relation : AVRelation) -> Int
    {
        var count = 0 ;
        (AVUser.current()!.relation(forKey: "userCart")).query().countObjectsInBackground{(objects, error) in
            
            if(error == nil)
            {
                print (objects)
                if( objects > 0 )
                {
                    //self.cartCountLabel.text = "\(objects)"
                  count = objects
                }
            }
            else
            {
                //show error mesage
            }
        }
        return count;
        
    }


}
