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
    @IBOutlet weak var followBtn : UIButton!
    @IBOutlet weak var notifcationsBtn : UIButton!

    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
    var items : [Product] = []
    var boughtItems : [Product] = []
    var isFollowingUser = false
    @IBOutlet weak var likesCountLabel : UILabel!
    @IBOutlet weak var followingCountLabel : UILabel!
    @IBOutlet weak var follwerCountLabel : UILabel!
    @IBOutlet weak var userImageview : UIImageView!
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var noProductBoughtSoFar : UILabel!

    var userFollowersArray : [AVUser] = [AVUser]()
    var userFollowingsArray : [AVUser] = [AVUser]()
    var favoritesList : [Product] = []
    @IBOutlet weak var  productsTableView : UITableView!
    var seelctedProductObj : Product!
    var userObj : AVUser  = AVUser.current()!
    @IBOutlet weak var userLabel : UILabel!

    @IBOutlet weak var favoritesCollectionView : UICollectionView!

    @IBOutlet weak var productsCollectionView : UICollectionView!
    
    
    @IBOutlet weak var minusBtn : UIButton!
    @IBOutlet weak var plusBtn : UIButton!
    @IBOutlet weak var minusBtnForClick : UIButton!
    @IBOutlet weak var plusBtnForClick : UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(userObj.username != nil)
        {
        self.userLabel.text = "@\(userObj.username!)"
        }
        self.getUserInfo()
        
        Constants.addShadow(button: minusBtn)
        Constants.addShadow(button: plusBtn)


        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.selectedItem = selectedTabBarItem
        self.productsTableView.reloadData()

    }
    func getUserInfo()
    {
        let query = AVUser.query()
        query.whereKey("objectId", equalTo: userObj.objectId! as Any)
        query.includeKey("likes")

        query.getFirstObjectInBackground({ (object, error) in
            if object !== nil {
                self.progressView.isHidden = true
                if(error == nil)
                {
                self.getProductList()
                if let parseFile = object?.value(forKey: "profileImage")
                {
                (parseFile as! AVFile).getDataInBackground({ (data, error) in
                    self.userImageview.image = UIImage.init(data: data!)
                    self.userImageview.layer.cornerRadius =  self.userImageview.frame.size.width/2
                    self.userImageview.clipsToBounds = true
                    
                })
                }
                if let website = object!.value(forKey: "website")
                {
               self.emailLabel.text =  website as? String
                    if(website as? String == "")
                    {
                        self.emailLabel.text  = "No website"
                    }

                }
                if let likes = object!.value(forKey: "likes")
                {
                    let likesCount = (likes as! AVObject).value(forKey: "likes")!
                    self.likesCountLabel.text = "\(likesCount)"
                    if(likesCount as! Int == 0 )
                    {
                        self.likesCountLabel.text = "-"

                    }
                }
               
                if let prod_desc = object?["description"] {
                    Constants.produceAttributedText(string: prod_desc as! String, textView:  self.descriptionTextView)
                    self.descriptionTextView.textAlignment = NSTextAlignment.left
                }
                }
            }
        })
        
        self.updateFollowersAndFollowingInfo()
        self.getBoughtProductList()
        self.minusButtonAction(sender: "" as AnyObject)
        
        if(!userObj.isEqual(AVUser.current()))
        {
            self.getFollowerAndFolloweeOfCurrentUser()
        }
        else
        {
        notifcationsBtn.isHidden = false
        }
    }
    func updateFollowersAndFollowingInfo()
    {
    userObj.getFollowersAndFollowees({ (object, error)
    in
        self.progressView.isHidden = true
        self.progressView.stopAnimating()
    if(error == nil)
    {
    print((object?["followees"] as! NSArray).count)
    let followersCount = (object?["followers"] as! NSArray).count
    let followingsCount = (object?["followees"] as! NSArray).count
    self.followingCountLabel.text = "\(followingsCount)"
    
    self.follwerCountLabel.text = "\(followersCount)"
    
    
    if(followersCount == 0 )
    {
    self.follwerCountLabel.text = "-"
    }
    
    if(followingsCount == 0 )
    {
    self.followingCountLabel.text = "-"
    }
    
    }
    
    })
    }
    func getFollowerAndFolloweeOfCurrentUser()
    {
    
       
        
        AVUser.current()?.getFollowersAndFollowees({ (object, error)
            in
            if(error == nil)
            {
                print((object?["followees"] as! NSArray).count)
          
                self.userFollowersArray = (object?["followers"] as! [AVUser])
                
                self.userFollowingsArray = (object?["followees"] as! [AVUser])
                
               
                if self.userFollowingsArray .contains(where: { $0.objectId ==  self.userObj.objectId }) {
                    // found
                    self.isFollowingUser = true
                    self.followBtn.isHidden = false
                    self.followBtn.setTitle("Unfollow -", for: .normal)
                    print("I m following this use")
                }
                if(!self.isFollowingUser)
                {
                     self.followBtn.isHidden = false
                    self.followBtn.setTitle("Follow + ", for: .normal)

                }
                
            }
            
        })
        
    }

    @IBAction func notificationsBtnAction (sender : AnyObject)
    {
    
    
    }
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if(collectionView == productsCollectionView)
       {
        return self.items.count
        }
        return self.boughtItems.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == productsCollectionView)
        {
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCustomCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        let productObj = self.boughtItems[indexPath.item]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if(productObj.productImageUrl != nil)
        {
            cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }

        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == productsCollectionView)
        {
        return CGSize(width: collectionView.bounds.width/2 - 20, height: collectionView.bounds.height/2 + 70)
        
        }
          return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height/3)
        
    }
//
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
       if(collectionView == productsCollectionView)
       {
         seelctedProductObj = items[indexPath.item]
        }
        else
       {
         seelctedProductObj = boughtItems[indexPath.item]
        }
        self.performSegue(withIdentifier: "ProfileViewToProductDetailsVC", sender: self)
        
    }
    func getProductList()
    {
        
        
        
        self.view.isUserInteractionEnabled = false
        let query: AVQuery = (userObj.relation(forKey: "sellProducts").query())
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
        self.noProductBoughtSoFar.isHidden = true
        minusBtn.isHidden = false
        plusBtn.isHidden = true
        self.productsTableView.isHidden = true
        self.productsCollectionView.isHidden = false
        self.favoritesCollectionView.isHidden = true

    }
    @IBAction func followUnfollowBtnAction()
    {
        progressView.isHidden = false
        progressView.startAnimating()
        if(isFollowingUser)
        {
            AVUser.current()?.unfollow(userObj.objectId!, andCallback: { (status, error) in
                
                self.isFollowingUser = false
                self.followBtn.setTitle("Follow +", for: .normal)
                self.updateFollowersAndFollowingInfo()
            })
        // will unfollow user
        }
        else
        {
            AVUser.current()?.follow(userObj.objectId!, andCallback: { (status, error) in
                
                self.isFollowingUser = true
                self.followBtn.setTitle("Unfollow -", for: .normal)
                self.updateFollowersAndFollowingInfo()
            })
        //will follow user
        
        }
    
    
    }
    @IBAction func plusButtonAction (sender : AnyObject)
    {
        minusBtn.isHidden = true
        plusBtn.isHidden = false
        if(self.boughtItems.count <= 0 )
        {
            if(!self.userObj.isEqual(AVUser.current()))
            {
                self.noProductBoughtSoFar.text = "You have not added any product to your favorite list."
            }
            self.noProductBoughtSoFar.isHidden = false
        }
        else
        {
          if(userObj == AVUser.current())
          {
        self.productsTableView.isHidden = false
            }
            else
            {
                self.favoritesCollectionView.isHidden = false
            }
        }
        self.productsCollectionView.isHidden = true
       
    }
    
    func getBoughtProductList()
    {
        
        
        
        let query: AVQuery = AVQuery(className: "Product")
       query.whereKey("buyingUser", equalTo: userObj as Any)

        
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
        
        
        
        let query: AVQuery = (userObj.relation(forKey: "favorites").query())
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
                if(!self.userObj.isEqual(AVUser.current()))
                {
                self.boughtItems = self.favoritesList
                    self.favoritesCollectionView.reloadData()
                
                }
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
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item",item.tag)
        
        if(item.tag == 1)
        {
            //load new view
            self.performSegue(withIdentifier: "ProfileToSellView", sender: self)
        }
            
       else if(item.tag == 4)
        {
            //load new view
            self.performSegue(withIdentifier: "ProfileToProductView", sender: self)
        }
        
        //This method will be called when user changes tab.
    }

    
    
}
