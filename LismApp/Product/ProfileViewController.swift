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
    @IBOutlet weak var followersBtn : UIButton!
    @IBOutlet weak var followingsBtn : UIButton!

    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var followBtn : UIButton!
    @IBOutlet weak var settingsBtn : UIButton!

    @IBOutlet weak var notifcationsBtn : UIButton!
    @IBOutlet weak var redDotView : UIView? = UIView()
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
   
    var boughtItems : [Product] = []
    var isFollowingUser = false
    @IBOutlet weak var likesCountLabel : UILabel!
    @IBOutlet weak var followingCountLabel : UILabel!
    @IBOutlet weak var follwerCountLabel : UILabel!
    @IBOutlet weak var userImageview : UIImageView!
    @IBOutlet weak var descriptionTextView : UILabel!
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var noProductBoughtSoFar : UILabel!
    var notificationItems : [NotificationLog] = []

    var userFollowersArray : [AVUser] = [AVUser]()
    var userFollowingsArray : [AVUser] = [AVUser]()
    var userMeFollowingsArray : [AVUser] = [AVUser]()

    var userMeFollowersArray : [AVUser] = [AVUser]()
    
    var favoritesList : [Product] = []
     var items : [Product] = []
    @IBOutlet weak var  productsTableView : UITableView!
    var seelctedProductObj : Product!
    var userObj : AVUser  = AVUser.current()!
    var userImageFile : AVFile!
    @IBOutlet weak var userLabel : UILabel!

    @IBOutlet weak var favoritesCollectionView : UICollectionView!

    @IBOutlet weak var productsCollectionView : UICollectionView!
    
    
    @IBOutlet weak var minusBtn : UIButton!
    @IBOutlet weak var plusBtn : UIButton!
    @IBOutlet weak var minusBtnForClick : UIButton!
    @IBOutlet weak var plusBtnForClick : UIButton!
    @IBOutlet weak var notificationLabel : UILabel!

    @IBOutlet weak var followersLabel : UILabel!
    @IBOutlet weak var totalLikesLabel : UILabel!
    @IBOutlet weak var followingsLabel : UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        notificationLabel.isHidden = true
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
        self.productsCollectionView.reloadData()
        self.updateFollowersAndFollowingInfo()
        self.getFollowerAndFolloweeOfCurrentUser()
        totalLikesLabel.text = "Total Likes".localized(using: "Main")
        followersLabel.text = "Followers".localized(using: "Main")
        followingsLabel.text = "Following".localized(using: "Main")
        self.favoritesCollectionView.isHidden = true


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
                     self.userImageFile = parseFile as! AVFile
                self.userImageFile.getDataInBackground({ (data, error) in
                    self.userImageview.image = UIImage.init(data: data!)
                    self.userImageview.layer.cornerRadius =  self.userImageview.frame.size.width/2
                    self.userImageview.clipsToBounds = true
                    
                })
                }
                if let website = object!.value(forKey: "website")
                {
                    
                    let attrs = [NSUnderlineStyleAttributeName : 1]
                    
                    let attributedString = NSMutableAttributedString(string:"")
                    
                    let buttonTitleStr = NSMutableAttributedString(string:(website as? String)!, attributes:attrs)
                    attributedString.append(buttonTitleStr)
                    self.emailLabel.attributedText = attributedString

                    if(website as? String == "")
                    {
                        self.emailLabel.text  = "No website".localized(using: "Main")
                    }
                    else
                    {
                        Constants.currentUser.website = website as! String
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
               else
                {
                    self.likesCountLabel.text = "-"

                    }
                if let prod_desc = object?["description"] {
                 //   Constants.produceAttributedText(string: prod_desc as! String, textView:  self.descriptionTextView)
                    self.descriptionTextView.text = prod_desc as! String
                    self.descriptionTextView.textAlignment = NSTextAlignment.left
                }
                }
            }
        })
        
        self.getBoughtProductList(size: 0)

        if(!userObj.isEqual(AVUser.current()))
        {
            plusBtn.setImage(UIImage(named : "heart"), for: .normal)
            plusBtnForClick.setImage(UIImage(named : "heart"), for: .normal)
            
        }
        else//its me profile
        {
            Constants.currentUser.userName = (AVUser.current()?.username)!
            settingsBtn.isHidden = false
            self.loadNotifications() //if any notification is here
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
        
        self.userFollowersArray = (object?["followers"] as! [AVUser])
        
        self.userFollowingsArray = (object?["followees"] as! [AVUser])
        

    let followersCount =  self.userFollowersArray.count
    let followingsCount = self.userFollowingsArray.count
    self.followingCountLabel.text = "\(followingsCount)"
    
    self.follwerCountLabel.text = "\(followersCount)"
    
        
        self.followersBtn.isHidden = false
         self.followingsBtn.isHidden = false
        if(followersCount == 0 )
        {
            self.follwerCountLabel.text = "-"
        
            self.followersBtn.isHidden = true
        }
    
        if(followingsCount == 0 )
        {
            self.followingCountLabel.text = "-"
            self.followingsBtn.isHidden = true

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
          
                
                self.userMeFollowersArray = (object?["followers"] as! [AVUser])
                
                self.userMeFollowingsArray = (object?["followees"] as! [AVUser])
                
               
                if self.userMeFollowingsArray.contains(where: { $0.objectId ==  self.userObj.objectId }) {
                    // found
                    self.isFollowingUser = true
                    self.followBtn.isHidden = false
                    self.followBtn.setTitle("Unfollow -".localized(using: "Main"), for: .normal)
                }
                if(!self.isFollowingUser && AVUser.current()?.objectId != self.userObj.objectId)
                {
                     self.followBtn.isHidden = false
                    self.followBtn.setTitle("Follow + ".localized(using: "Main"), for: .normal)

                }
                
            }
            
        })
        
    }
    func loadNotifications()
    {
        var notifCount = 0
        let query: AVQuery = AVQuery(className: "NotificationLog")
        query.includeKey("otherUser")
        query.includeKey("product")
        query.includeKey("images")
        query.includeKey("user")
        progressView.isHidden = false
        progressView.startAnimating()
        query.whereKey("userId", equalTo: AVUser.current()!.objectId! as Any)
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                for obj in objects!
                {
                    let notifObj:NotificationLog =  obj as! NotificationLog
                    
                    
                    notifObj.NotificationInintWithDic(dict: obj as! AVObject)
                    notifObj.read = (obj as! AVObject).value(forKey: "read") as! Bool 
                    if((obj as! AVObject).value(forKey: "read") as! Bool == false)
                    {
                        self.selectedTabBarItem.selectedImage = UIImage(named : "person_notif")
                       // self.redDotView?.isHidden = false
                        notifCount = notifCount + 1
                         self.notificationLabel.isHidden = false
                         self.notificationLabel.layer.cornerRadius = self.notificationLabel.frame.size.height/2
                     //   self.notificationLabel.text = "\(notifCount)"
                    }
                    self.notificationItems.append(notifObj)
                    
                }
                 self.notificationItems =  self.notificationItems.reversed()
            }
            self.progressView.isHidden = true
            self.progressView.stopAnimating()
        }
    }
    
    @IBAction func notificationsBtnAction (sender : AnyObject)
    {

    
    }
    
    @IBAction func followersBtnAction (sender : AnyObject)
    {
        self.performSegue(withIdentifier: "ProfileToUserFollowersVC", sender: self)
        
    }
    @IBAction func followingsBtnAction (sender : AnyObject)
    {
        //
        self.performSegue(withIdentifier: "ProfileToUserFollowingViewController", sender: self)

        
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
        
            if(productObj.status == Constants.sent || productObj.status == Constants.waiting_to_be_sent)
            {
                cell.soldBannerImageView.isHidden = false
            }
            else
            {
                cell.soldBannerImageView.isHidden = true
                
            }
        //cell.retailPriceTextView.text = "Size\(productObj.size) \n  Est. Retail ¥ \(productObj.priceRetail)"
        
            Constants.produceAttributedText(string: "\("Size".localized(using: "Main"))\(productObj.size) \n  \("Est. Retail ¥".localized(using: "Main")) \(productObj.priceRetail)", textView: cell.retailPriceTextView)
            
            if (indexPath.row + 1 == self.items.count )
            {
                //self.getMoreProductList(size: self.items.count)
            }
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
       return CGSize(width: collectionView.bounds.width/2 - 20 , height: collectionView.bounds.width/2 + 60)
        
        }
          return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.width/3)
        
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
        query.whereKey("user", equalTo: self.userObj)

//        query.limit = 6
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
                self.productsTableView.reloadData()
                self.loadFavoritesList()

            }
            else
            {
                Constants.showAlert(message: "Unable to load products.".localized(using: "Main"), view: self)
                
            }
            
            
        }
        
        
    }
    
    func getMoreProductList(size: Int)
    {
        
        
        
        let query: AVQuery = AVQuery(className: "Product")
        query.includeKey("images")
        query.includeKey("user")
        query.includeKey("userLikes")
        query.whereKey("user", equalTo: self.userObj)

        query.limit = 6
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
                DispatchQueue.main.async(execute: {
                    self.comapreToUpdateFavoriteProductsList()
                    self.progressView.isHidden = true
                    
                })
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
                Constants.sendPushToChannel(vc: self, channelInfo: self.userObj.objectId!, message: "\(AVUser.current()!.username) started following you!", content: "")

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
    
    func getBoughtProductList(size : Int)
    {
        
        
        
        let query: AVQuery = AVQuery(className: "Product")
       query.whereKey("buyingUser", equalTo: userObj as Any)
        query.limit = 6
        query.skip = size
        self.progressView.isHidden = false
        self.progressView.startAnimating()
        DispatchQueue.global(qos: .background).async {
            query.findObjectsInBackground { (objects, error) in
                if(error == nil)
                {
                    for obj in objects!
                    {
                        let productObj:Product =  obj as! Product
                        
                        
                        productObj.ProductInintWithDic(dict: obj as! AVObject)
                        self.boughtItems.append(productObj)
                    }
                }
                else
                {
                    Constants.showAlert(message: "Unable to load products.".localized(using: "Main"), view: self)
                }
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    self.progressView.isHidden = true
                    self.progressView.stopAnimating()
                    self.productsTableView.reloadData()

                }

              
                
            }
            }
    
        
    }
    
    

    
    func loadFavoritesList()
    {
            self.favoritesList =   Constants.favoritesList
        DispatchQueue.main.async(execute: {
            self.comapreToUpdateFavoriteProductsList()
            self.progressView.isHidden = true
            self.progressView.stopAnimating()

            
        })
        if(!self.userObj.isEqual(AVUser.current()))
        {
            self.boughtItems = self.favoritesList
            self.favoritesCollectionView.reloadData()
            
        }
        
//        let query: AVQuery = (userObj.relation(forKey: "favorites").query())
//        query.includeKey("user")
//        query.findObjectsInBackground { (objects, error) in
//            if(error == nil)
//            {
//                for obj in objects!
//                {
//                    let productObj:Product =  obj as! Product
//                    productObj.ProductInintWithDic(dict: obj as! AVObject)
//                    self.favoritesList.append(productObj)
//                }
//               
//                self.comapreToUpdateFavoriteProductsList()
//                if(!self.userObj.isEqual(AVUser.current()))
//                {
//                self.boughtItems = self.favoritesList
//                    self.favoritesCollectionView.reloadData()
//                
//                }
//            }
//            else
//            {
//                Constants.showAlert(message: "Unable to load products.", view: self)
//                
//            }
//            self.progressView.isHidden = true
//            
//            
//        }
//        
//        
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
        Constants.produceAttributedTextForItems(string: "\(productObj.name)\n\(productObj.brand)\n\("Size".localized(using: "Main")) \(productObj.size) \n¥ \(productObj.sellingPrice)", textView: cell.sizeAndPriceTextView)
        if(productObj.productImageUrl != nil)
        {
            cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }
        cell.tag = indexPath.item
        cell.productStatusLabel.text = productObj.status.localized(using: "Main")
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        if (indexPath.row + 1 == self.boughtItems.count )
        {
            self.getBoughtProductList(size: self.boughtItems.count)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        seelctedProductObj = self.boughtItems[indexPath.item]
//        if(seelctedProductObj.status == "Posted for Sale")
//        {
//            //selltoedictvc
//            self.performSegue(withIdentifier: "ProfileViewControllerToUpdatePostedItemForSaleVC", sender: self)
//        }
//        else
//            
//            
//        {
//            self.performSegue(withIdentifier: "ProfileViewToWaitingToBeSentVC", sender: self)
//            // Constants.showAlert(message: "You cannot edit sold product", view: self)
//        }
        
        self.performSegue(withIdentifier: "ProfileToProductStatusView", sender: self)

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
        else if (segue.identifier == "ProfileToProductStatusView") {
            let viewController:ProductStatusViewController = segue.destination as! ProductStatusViewController
            viewController.productBO = seelctedProductObj
            viewController.userImageFile = self.userImageFile
         //   viewController.userImageView.image = self.userImageview.image
            // pass data to next view
        }

      else  if (segue.identifier == "ProfileViewToProductDetailsVC") {
            let viewController:ProductDetailViewController = segue.destination as! ProductDetailViewController
            viewController.productBO = seelctedProductObj
            
            // pass data to next view
        }
            //
        else if (segue.identifier == "ProfileToUserFollowersVC") { //gooing tp notiication
            let viewController:FollowersViewControllers = segue.destination as! FollowersViewControllers
            viewController.userFollowersArray = self.userFollowersArray
            viewController.userObjInfo = self.userObj
            viewController.userFollowingsArray = self.userMeFollowingsArray
          
            
        }//
        else if (segue.identifier == "ProfileToUserFollowingViewController") { //gooing tp notiication
            let viewController:FollowingsViewController = segue.destination as! FollowingsViewController
            viewController.userFolloweringsArray = self.userFollowingsArray
            viewController.userObjInfo = self.userObj
            viewController.userFolloweringsArray = self.userMeFollowingsArray

            
        }
        else if (segue.identifier == "ProfileToNotificationViewcontroller") { //gooing tp notiication
            let viewController:NotificationsViewcontroller = segue.destination as! NotificationsViewcontroller
            viewController.items = self.notificationItems
            self.notificationLabel.isHidden  = true
            self.selectedTabBarItem.selectedImage  = UIImage(named : "person")

        
        }
        
        else if (segue.identifier == "ProfileToSettingsVC") { //gooing tp notiication
            let viewController:SettingsViewController = segue.destination as! SettingsViewController
            viewController.userImageFile = self.userImageFile
            
            
            
        }
        else if (segue.identifier == "ProfileToProductView") {
            let viewController:ProductViewController = segue.destination as! ProductViewController
            viewController.isloadingFav = sender as! Bool
            // pass data to next view
        }

        //ProfileToSettingsVC
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item",item.tag)
        
        if(item.tag == 1)
        {
            //load new view
            self.performSegue(withIdentifier: "ProfileToSellView", sender: self)
        }
   
            
        else if(item.tag == 3)
        {
            //load new view
            self.performSegue(withIdentifier: "ProfileToProductView", sender: true)
        }

       else if(item.tag == 4)
        {
            //load new view
            self.performSegue(withIdentifier: "ProfileToProductView", sender: false)
        }
        
        //This method will be called when user changes tab.
    }

    
    
}
