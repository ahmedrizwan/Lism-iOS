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
    
 static let sell_is_more = "LESS IS MORE"
static let sell_with_us_it_s_easy = "SELL WITH US IT\'S EASY"
    static let selling_is_fast_and_easy = "SELLING IS FAST AND EASY"
    static let selling_description = "Step1: Upload the item you wish to sell \nStep2: Receive confirmation within 24 hrs\nStep3: Adda captivating description and post it!"
    static let you_earn_more = "YOU EARN MORE"
    static let earn_more_description = "Receive up to 80% of the sale price for your items"


}
