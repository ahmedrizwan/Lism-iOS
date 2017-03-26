

import AVFoundation
import UIKit
import AVOSCloud

class Product: NSObject {
  
    
    var objectId: String = String()
    var prodcut_description: String = String()
    var category: String = String()
    var address: String = String()
    var trackingNumber: String = String()
    var color: String = String()
    var name: String = String()
    var priceRetail : Int = Int()
    var productLikes : Int = Int()
    var size: String = String()
    var brand: String = String()
    var status: String = String()
    var condition: String = String()
    var sellingPrice: String = String()

    var productImageUrl: URL!

    
    func ProductInintWithDic(dict:AVObject) {
        
        
        print(dict)
       let avRelationObj =  dict.relation(forKey: "images") 
        avRelationObj.query().findObjectsInBackground { (objects, error) in
            for obj in objects!
            {
                let avImageObject  = obj as! AVObject
                if let productImageUrl = avImageObject.object(forKey: "imageUrl") {
                     self.productImageUrl =   URL(string: productImageUrl as! String)
                }
                
            }

        }
        if let objectId = dict.object(forKey: "objectId") {
            self.objectId = objectId as! String
        }
        
        if let size = dict.value(forKey: "size") {
            self.size = size as! String
        }
        
        if let name = dict.value(forKey: "name") {
            self.name = name as! String
        }
        if let address = dict.value(forKey: "address") {
            self.address = address as! String
        }

    
    }
    
    


}
