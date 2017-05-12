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
class Constants {

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
    
     static let USER_CART = "userCart"
 static let sell_is_more = "LESS IS MORE"
static let sell_with_us_it_s_easy = "SELL WITH US IT\'S EASY"
    static let selling_is_fast_and_easy = "SELLING IS FAST AND EASY"
    static let selling_description = "Step1: Upload the item you wish to sell \nStep2: Receive confirmation within 24 hrs\nStep3: Adda captivating description and post it!"
    static let you_earn_more = "YOU EARN MORE"
    static let earn_more_description = "Receive up to 80% of the sale price for your items"
     static let SELL_PRODUCTS = "sellProducts"

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
        attributedString.addAttribute(NSFontAttributeName , value: UIFont(name: "Avenir", size: CGFloat(8))!,range: NSMakeRange(0, attributedString.length))
        
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.45
        paragraphStyle.maximumLineHeight = 8 // change line spacing between each line like 30 or 40
        
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

}
