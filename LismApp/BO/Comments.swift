//
//  Comments.swift
//  LismApp
//
//

import Foundation
import AVOSCloud

class Comments: AVObject,AVSubclassing  {
    
    
    var user: AVUser = AVUser()
    var comment: String = String()
    
    override  class  func initialize() {
        Comments.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "Comment"
    }
    func CommentInintWithDic(dict:AVObject) {
        
        
        if let comment = dict.object(forKey: "comment") {
            self.comment = comment as! String
        }
        
        if let user = dict.value(forKey: "user") {
            self.user = user as! AVUser
        }
        
        
        
    }
    
    
    
    
}
