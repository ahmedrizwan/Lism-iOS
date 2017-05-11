//
//  ProfileViewController.swift
//  LismApp
//
//  Created by Arkhitech on 10/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import AVOSCloud

class ProfileViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate,UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
    var items : [Product] = []
    var boughtItems : [Product] = []

    @IBOutlet weak var likesCountLabel : UILabel!
    @IBOutlet weak var followingCountLabel : UILabel!
    @IBOutlet weak var follwerCountLabel : UILabel!
    @IBOutlet weak var userImageview : UIImageView!
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var noProductBoughtSoFar : UILabel!

    var userFollowersArray : NSArray = NSArray()
    var userFollowingsArray : NSArray = NSArray()
    var favoritesList : [Product] = []
    @IBOutlet weak var  productsTableView : UITableView!
    var seelctedProductObj : Product!

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
                    Constants.produceAttributedText(string: prod_desc as! String, textView:  self.descriptionTextView)
                    self.descriptionTextView.textAlignment = NSTextAlignment.left
                }
            }
        })
        
     AVUser.current()?.getFollowersAndFollowees({ (object, error)
        in
        print((object?["followees"] as! NSArray).count)
        self.followingCountLabel.text = "\((object?["followees"] as! NSArray).count)"
        self.follwerCountLabel.text = "\((object?["followers"] as! NSArray).count)"
        self.userFollowersArray = (object?["followers"] as! NSArray)
        self.userFollowingsArray = (object?["followees"] as! NSArray)

     })
        self.getBoughtProductList()
        self.minusButtonAction(sender: "" as! AnyObject)
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
        
        Constants.produceAttributedText(string: "Size\(productObj.size) \n  Est. Retail ¥ \(productObj.priceRetail)", textView: cell.retailPriceTextView)
       
        cell.likeButton.isSelected = productObj.favorite
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/2 - 20, height: collectionView.bounds.height/2 + 40)
        
    }
//
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        seelctedProductObj = items[indexPath.item]
        self.performSegue(withIdentifier: "ProfileViewToProductDetailsVC", sender: self)
        
    }
    func getProductList()
    {
        
        
        
        self.view.isUserInteractionEnabled = false
        let query: AVQuery = (AVUser.current()?.relation(forKey: "sellProducts").query())!
        query.includeKey("user")
        self.progressView.isHidden = false
        query.findObjectsInBackground { (objects, error) in
            self.progressView.isHidden = true
            self.view.isUserInteractionEnabled = true
            if(error == nil)
            {
                self.items.removeAll()
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    
                    
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.items.append(productObj)
                }
                self.loadFavoritesList()

            }
            else
            {
                Constants.showAlert(message: "Unable to load products.", view: self)
                
            }
            
            
        }
        
        
    }
    
    @IBAction func minusButtonAction (sender : AnyObject)
    {
        self.productsTableView.isHidden = true
        self.productsCollectionView.isHidden = false
    }
    
    @IBAction func plusButtonAction (sender : AnyObject)
    {
        self.productsTableView.isHidden = false
        self.productsCollectionView.isHidden = true
    }
    
    func getBoughtProductList()
    {
        
        
        
        let query: AVQuery = AVQuery(className: "Product")
       query.whereKey("buyingUser", equalTo: AVUser.current() as Any)

        
        query.limit = ProductViewController.ITEM_LIMIT
        self.progressView.isHidden = false
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    
                    
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.boughtItems.append(productObj)
                }
                if(self.boughtItems.count <= 0 )
                {
                self.noProductBoughtSoFar.isHidden = false
                }
                self.productsTableView.reloadData()
            }
            else
            {
                Constants.showAlert(message: "Unable to load products.", view: self)
            }
            
        }
        
    }
    
    func loadFavoritesList()
    {
        
        
        
        let query: AVQuery = (AVUser.current()?.relation(forKey: "favorites").query())!
        query.includeKey("user")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.favoritesList.append(productObj)
                }
                self.comapreToUpdateFavoriteProductsList()
            }
            else
            {
                Constants.showAlert(message: "Unable to load products.", view: self)
                
            }
            self.progressView.isHidden = true
            
            
        }
        
        
    }
    func comapreToUpdateFavoriteProductsList()
    {
        for productObj in self.items
        {
            for objFavorite in self.favoritesList
            {
                if(productObj.objectId == objFavorite.objectId)
                {
                    productObj.favorite = true
                }
            }
            
        }
        self.productsCollectionView.reloadData()
    }
    

    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boughtItems.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellItemsCustomCell", for: indexPath ) as! SellItemsCustomCell
        let productObj = self.boughtItems[indexPath.item]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        Constants.produceAttributedTextForItems(string: "\(productObj.name)\n\(productObj.brand)\nSize \(productObj.size) \n¥ \(productObj.sellingPrice)", textView: cell.sizeAndPriceTextView)
        if(productObj.productImageUrl != nil)
        {
            cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }
        cell.tag = indexPath.item
        cell.productStatusLabel.text = productObj.status
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        seelctedProductObj = self.boughtItems[indexPath.item]
        if(seelctedProductObj.status == "Posted for Sale")
        {
            //selltoedictvc
            self.performSegue(withIdentifier: "ProfileViewControllerToUpdatePostedItemForSaleVC", sender: self)
        }
        else
            
            
        {
            self.performSegue(withIdentifier: "ProfileViewToWaitingToBeSentVC", sender: self)
            // Constants.showAlert(message: "You cannot edit sold product", view: self)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ProfileViewControllerToUpdatePostedItemForSaleVC") {
            let viewController:UpdatePostedItemForSaleViewController = segue.destination as! UpdatePostedItemForSaleViewController
            viewController.productObj = seelctedProductObj
            // pass data to next view
        }
        else if (segue.identifier == "ProfileViewToWaitingToBeSentVC") {
            let viewController:UpdateWaitingtoBeSentStatus = segue.destination as! UpdateWaitingtoBeSentStatus
            viewController.productObj = seelctedProductObj
            // pass data to next view
        }
      else  if (segue.identifier == "ProfileViewToProductDetailsVC") {
            let viewController:ProductDetailViewController = segue.destination as! ProductDetailViewController
            viewController.productBO = seelctedProductObj            
            // pass data to next view
        }
        
    }


    
    
}
