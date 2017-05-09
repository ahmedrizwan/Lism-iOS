

import AVFoundation
import UIKit
import AVOSCloud

class Product: AVObject, AVSubclassing {
  
    
    var objectIdForProduct: String = String()
    var prodcut_description: String = String()
    var category: String = String()
    var address: String = String()
    var trackingNumber: String = String()
    var color: String = String()
    var name: String = String()
    var priceRetail : String = String()
    var productLikes : Int = Int()
    var size: String = String()
    var brand: String = String()
    var status: String = String()
    var condition: String = String()
    var sellingPrice: Int = Int()
    var favorite: Bool = false
    var isAddedToCheckOut: Bool = true

    var user : AVUser!
    var buyingUser : AVUser!

    var productImagesObjects : [AVObject] = []

    var productImageUrl: URL!
    var productImagesArray: [URL] = []
    var queryObj: AVQuery!
    var updatedAtValue: Date = Date()

//   override  class  func initialize() {
  //      Product.registerSubclass()
   // }
    static func parseClassName() -> String {
        return "Product"
    }
    
   
    func ProductInintWithDic(dict:AVObject) {
        
        
       let avRelationObj =  dict.relation(forKey: "images")
        avRelationObj.query().findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
            for obj in objects!
            {
                let avImageObject  = obj as! AVObject
                if let productImageUrl = avImageObject.object(forKey: "imageUrl") {
                     self.productImageUrl =   URL(string: productImageUrl as! String)
                    self.productImagesArray.append( self.productImageUrl)
                    self.productImagesObjects.append(avImageObject)
                }
                
            }
            }
        }
        
            
        if let primaryImageUrl = dict.object(forKey: "primaryImageUrl") {
            self.productImageUrl =   URL(string: primaryImageUrl as! String)
        }
        
        if let objectIdForProduct = dict.object(forKey: "objectId") {
            self.objectIdForProduct = objectIdForProduct as! String
        }
        
        if let size = dict.value(forKey: "size") {
            self.size = size as! String
        }
        
        if let name = dict.value(forKey: "name") {
            self.name = name as! String
        }
        if let brand = dict.value(forKey: "brand") {
            self.brand = brand as! String
        }
        if let address = dict.value(forKey: "address") {
            self.address = address as! String
        }
        if let status = dict.value(forKey: "status") {
            self.status = status as! String
        }
        if let updatedAtValue = dict.value(forKey: "updatedAt") {
            self.updatedAtValue = updatedAtValue as! Date
        }
        
        if let prod_desc = dict["description"] {
            self.prodcut_description = prod_desc as! String
        }

        if let priceRetail = dict.value(forKey: "priceRetail") {
            self.priceRetail = priceRetail as! String
        }
    
        if let trackingNumber = dict.value(forKey: "trackingNumber") {
            self.trackingNumber = trackingNumber as! String
        }
        
        
        if let priceSelling = dict.value(forKey: "priceSelling") {
          
            self.sellingPrice = priceSelling as! Int
    
        }
        
        
        if let productLikes = dict.value(forKey: "productLikes") {
            self.productLikes = productLikes as! Int
        }
        
        if let comments = dict.value(forKey: "comments") {
            self.queryObj = (comments as! AVRelation).query()
        }
        
       
        

        if let category = dict.value(forKey: "category") {
            self.category = category as! String
        }
        
        
        if let color = dict.value(forKey: "color") {
            self.color = color as! String
        }
        
        if let user = dict.value(forKey: "user") {
            self.user = user as! AVUser
           
        }
        
        if let user = dict.value(forKey: "buyingUser") {
            self.buyingUser = user as! AVUser
            
        }
        if let condition = dict.value(forKey: "condition") {
            self.condition = condition as! String
        }

        
    }
    
    


}
