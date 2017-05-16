//
//  NotificationBO.swift
//  LismApp
//
//  Created by Arkhitech on 16/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AVOSCloud

class NotificationLog: AVObject, AVSubclassing {

    var userId: String = String()
    var otherUser : AVUser = AVUser()
    var product : Product = Product()
    var type: String = String()
    var createdAtValue: Date = Date()

    var isRead: Bool = Bool()

    static func parseClassName() -> String {
        return "NotificationLog"
    }
    
    
    func NotificationInintWithDic(dict:AVObject) {
        
        
        if let userId = dict.object(forKey: "userId") {
            self.userId = userId as! String
        }
        
        if let otherUser = dict.value(forKey: "otherUser") {
            self.otherUser = otherUser as! AVUser
           // self.otherUser.UserInintWithDic(dict: otherUser as! AVObject)
        }
        
        
        if let product = dict.value(forKey: "product") {
            self.product =  product as! Product
            self.product.ProductInintWithDic(dict: product as! AVObject)
        }
        
        if let type = dict.value(forKey: "type") {
            self.type = type as! String
        }
        
        if let createdAtValue = dict.value(forKey: "createdAt") {
            self.createdAtValue = createdAtValue as! Date
        }
        
        
        if let isRead = dict.value(forKey: "isRead") {
            self.isRead = isRead as! Bool
        }
        
        
    }
    
}
