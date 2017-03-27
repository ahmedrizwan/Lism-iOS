//
//  Comments.swift
//  LismApp
//
//

import Foundation
import AVOSCloud

class Comments: NSObject {
    
    
    var user: AVUser = AVUser()
    var comment: String = String()
    
    
    func CommentInintWithDic(dict:AVObject) {
        
        
        if let comment = dict.object(forKey: "comment") {
            self.comment = comment as! String
        }
        
        if let user = dict.value(forKey: "user") {
            self.user = user as! AVUser
        }
        
        
        
    }
    
    
    
    
}
