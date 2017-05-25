

import AVFoundation
import UIKit
import AVOSCloud

class User: AVUser {
    
    
    var userName: String = String()
    var profileImage : AVFile = AVFile()
    
    
    
    func UserInintWithDic(dict:AVObject) {
        
        
        if let userName = dict.value(forKey: "userName") {
            self.userName = userName as! String
        }
        
        if let profileImage = dict.value(forKey: "profileImage") {
            self.profileImage = profileImage as! AVFile
        }
        
        
    }
    
    
    
    
}
