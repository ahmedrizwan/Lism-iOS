

import AVFoundation
import UIKit
import AVOSCloud

class User: NSObject {
  
    
    var objectId: String = String()
    var userName: String = String()

    
    func UserInintWithDic(dict:AVObject) {
        
       
        if let objectId = dict.object(forKey: "objectId") {
            self.objectId = objectId as! String
        }
        
        if let userName = dict.value(forKey: "userName") {
            self.userName = userName as! String
        }
        
       
    
    }
    
    


}
