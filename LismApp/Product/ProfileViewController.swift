//
//  ProfileViewController.swift
//  LismApp
//
//  Created by Arkhitech on 10/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import AVOSCloud

class ProfileViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
    var items : [Product] = []
    @IBOutlet weak var likesCountLabel : UILabel!
    @IBOutlet weak var followingCountLabel : UILabel!
    @IBOutlet weak var follwerCountLabel : UILabel!
    @IBOutlet weak var userImageview : UIImageView!
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var emailLabel : UILabel!

    @IBOutlet weak var userLabel : UILabel!


    @IBOutlet weak var productsCollectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let userObj = AVUser.current()
        userLabel.text = "@\(userObj!.username!)"
    
              self.getUserInfo()
        
    }
    func getUserInfo()
    {
        let query = AVUser.query()
        query.whereKey("objectId", equalTo: AVUser.current()?.objectId! as Any)
        query.includeKey("likes")

        query.getFirstObjectInBackground({ (object, error) in
            if object !== nil {
                self.progressView.isHidden = true
                
                self.getProductList()
                let parseFile = object?.value(forKey: "profileImage") as! AVFile
                parseFile.getDataInBackground({ (data, error) in
                    self.userImageview.image = UIImage.init(data: data!)
                    self.userImageview.layer.cornerRadius =  self.userImageview.frame.size.width/2
                    self.userImageview.clipsToBounds = true
                })
                if let website = object!.value(forKey: "website")
                {
                    self.emailLabel.text =  website as? String
                }
                if let likes = object!.value(forKey: "likes")
                {
                    self.likesCountLabel.text =  (likes as! AVObject).value(forKey: "likes") as? String
                }
                
                if let prod_desc = object?["description"] {
                    self.produceAttributedText(string: prod_desc as! String, textView:  self.descriptionTextView)
                }
            }
        })
    }


    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "prodcutsCustomCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        let productObj = self.items[indexPath.item]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.nameLabel.text = productObj.brand
        if(productObj.productImageUrl != nil)
        {
            cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }
        cell.priceLabel.text = "¥ \(productObj.sellingPrice)" ;
        
        
        //cell.retailPriceTextView.text = "Size\(productObj.size) \n  Est. Retail ¥ \(productObj.priceRetail)"
        
        self.produceAttributedText(string: "Size\(productObj.size) \n  Est. Retail ¥ \(productObj.priceRetail)", textView: cell.retailPriceTextView)
        if (indexPath.row + 1 == self.items.count )
        {
            self.getMoreProductList(size: self.items.count)
        }
        cell.likeButton.isSelected = productObj.favorite
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/2 - 20, height: collectionView.bounds.height/2)
        
    }

    func produceAttributedText(string: String, textView : UITextView)
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
    
    func getProductList()
    {
        
        
        
        let query: AVQuery = AVQuery(className: "Product")
        query.includeKey("images")
        query.includeKey("user")
        query.includeKey("userLikes")
        query.includeKey("buyingUser")
        
        query.limit = ProductViewController.ITEM_LIMIT
        self.progressView.isHidden = false
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    
                    
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.items.append(productObj)
                }
                self.productsCollectionView.reloadData()
                self.progressView.isHidden = true
            }
            else
            {
                Constants.showAlert(message: "Unable to load products.", view: self)
            }
            
        }
        
    }
    func getMoreProductList(size: Int)
    {
        
        
        
        let query: AVQuery = AVQuery(className: "Product")
        query.includeKey("images")
        query.includeKey("user")
        query.includeKey("userLikes")
        query.limit = ProductViewController.ITEM_LIMIT
        query.skip = size
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.items.append(productObj)
                }
            }
            
        }
        
        
    }

}
