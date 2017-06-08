

import AVFoundation
import UIKit
import AVOSCloud

class User: AVUser {
    
    
    var userName: String = String()
    var profileImage : AVFile = AVFile()
    var userRelatedDesc: String = String()
    var website: String = String()
    var dob: String = String()
    var gender: String = String()
    var favoriteRelation : AVRelation = AVRelation()
    
    override class func parseClassName() -> String {
        return "_User"
    }

    
    func UserInintWithDic(dict:AVObject) {
        
        
        if let userName = dict.value(forKey: "userName") {
            self.userName = userName as! String
        }
        
        if let profileImage = dict.value(forKey: "profileImage") {
            self.profileImage = profileImage as! AVFile
        }
        
        
        if let userRelatedDesc = dict["description"] {
            self.userRelatedDesc = userRelatedDesc as! String
        }
        
        if let dob = dict.value(forKey:"dob"){
            self.dob = dob as! String
        }
        if let gender = dict.value(forKey:"gender"){
            self.gender = gender as! String
        }
        
        if let favoriteRelation = dict.value(forKey:"favorites"){
            self.favoriteRelation = favoriteRelation as! AVRelation
        }

    }
    
    
    
    
}
