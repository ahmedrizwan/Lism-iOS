//
//  NotificationsViewcontroller.swift
//  LismApp
//
//  Created by Arkhitech on 16/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import AVOSCloud

class NotificationsViewcontroller : UIViewController,UITableViewDelegate, UITableViewDataSource,UITabBarDelegate
{
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
    var items : [NotificationLog] = []
    var selectedUser : AVUser = AVUser()
    var selectedProduct : Product = Product()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNotifications()
    }
    
    func loadNotifications()
    {
        
        let query: AVQuery = AVQuery(className: "NotificationLog")
        query.includeKey("otherUser")
        query.includeKey("product")
        query.includeKey("images")
        query.includeKey("user")

        query.whereKey("userId", equalTo: AVUser.current()?.objectId as Any)
        self.progressView.isHidden = false
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                for obj in objects!
                {
                    let notifObj:NotificationLog =  NotificationLog()
                    
                    
                    notifObj.NotificationInintWithDic(dict: obj as! AVObject)
                    self.items.append(notifObj)
                
                }
                self.items = self.items.reversed() // so that we can show latest one on top
                self.tableView.reloadData()
                print (objects as Any)
            }
        }
    }
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCustomCell", for: indexPath ) as! NotificationCustomCell
        let notificationObj = self.items[indexPath.item]
        self.updateDaysInfo(notifcationObject: notificationObj, customCellForNotification: cell)

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if(notificationObj.type == Constants.NotificationType.TYPE_SELL_BOUGHT )
        {
        Constants.produceAttributedTextForItems(string: "\(notificationObj.otherUser.username!) bought your product \(notificationObj.product.name).", textView: cell.notificationDesctiption)
            if(notificationObj.product.productImageUrl != nil)
            {
                cell.productImageView.sd_setImage(with: notificationObj.product.productImageUrl, placeholderImage: nil)
            }
        }
        else   if(notificationObj.type == Constants.NotificationType.TYPE_FOLLOW )
        {
            
            Constants.produceAttributedTextForItems(string: "\(notificationObj.otherUser.username!) started following you!", textView: cell.notificationDesctiption)
            if let profileImage = notificationObj.otherUser.value(forKey: "profileImage") {
                self.loadUserImage(parseFile: profileImage as! AVFile, customCellForNotification: cell)

            }
    
        }
        else   if(notificationObj.type == Constants.NotificationType.TYPE_LIKE )
        {
            Constants.produceAttributedTextForItems(string: "\(notificationObj.otherUser.username!) liked your product \(notificationObj.product.name).", textView: cell.notificationDesctiption)
            if let profileImage = notificationObj.otherUser.value(forKey: "profileImage") {
                self.loadUserImage(parseFile: profileImage as! AVFile, customCellForNotification: cell)
                
            }
            if(notificationObj.product.productImageUrl != nil)
            {
                cell.productImageView.sd_setImage(with: notificationObj.product.productImageUrl, placeholderImage: nil)
            }
            
        }
        else   if(notificationObj.type == Constants.NotificationType.TYPE_COMMENT )
        {
            Constants.produceAttributedTextForItems(string: "\(notificationObj.otherUser.username!) commented on your product \(notificationObj.product.name).", textView: cell.notificationDesctiption)
            if let profileImage = notificationObj.otherUser.value(forKey: "profileImage") {
                self.loadUserImage(parseFile: profileImage as! AVFile, customCellForNotification: cell)
                
            }
            if(notificationObj.product.productImageUrl != nil)
            {
                cell.productImageView.sd_setImage(with: notificationObj.product.productImageUrl, placeholderImage: nil)
            }
            
        }
        

        else   if(notificationObj.type == Constants.NotificationType.TYPE_SELL_CONFIRMED )
        {
            Constants.produceAttributedTextForItems(string: "\(notificationObj.otherUser.username!) confirmed your product  \(notificationObj.product.name).", textView: cell.notificationDesctiption)
            if let profileImage = notificationObj.otherUser.value(forKey: "profileImage") {
                self.loadUserImage(parseFile: profileImage as! AVFile, customCellForNotification: cell)
                
            }
            if(notificationObj.product.productImageUrl != nil)
            {
                cell.productImageView.sd_setImage(with: notificationObj.product.productImageUrl, placeholderImage: nil)
            }
            
        }
        
        else   if(notificationObj.type == Constants.NotificationType.TYPE_SELL_SENT )
        {
            Constants.produceAttributedTextForItems(string: "\(notificationObj.otherUser.username!) sent your product \(notificationObj.product.name).", textView: cell.notificationDesctiption)
            if let profileImage = notificationObj.otherUser.value(forKey: "profileImage") {
                self.loadUserImage(parseFile: profileImage as! AVFile, customCellForNotification: cell)
                
            }
            if(notificationObj.product.productImageUrl != nil)
            {
                cell.productImageView.sd_setImage(with: notificationObj.product.productImageUrl, placeholderImage: nil)
            }
            
        }
        
        

        
        
        cell.tag = indexPath.item
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        
        
        return cell
    }
func loadUserImage(parseFile : AVFile ,  customCellForNotification :NotificationCustomCell )
{
    DispatchQueue.global().async {
        do {
            parseFile.getDataInBackground({ (data, error) in
                DispatchQueue.main.async(execute: {
                    if(data != nil)
                    {
                    customCellForNotification.userImage.image = UIImage.init(data: data!)
                    customCellForNotification.userImage.layer.cornerRadius =  customCellForNotification.userImage.frame.size.width/2
                    customCellForNotification.userImage.clipsToBounds = true
                    }
                })
            })
            print("file exists");
            
            
        }
    }
        
}
    func updateDaysInfo(notifcationObject : NotificationLog,  customCellForNotification :NotificationCustomCell )
    {
        let dateValue  = notifcationObject.createdAtValue
        if  Date().days(from: dateValue) > 0
            
        {
            customCellForNotification.productTimeLabel.text =   "Updated \(Date().days(from:  dateValue)) d ago"
            
        }
        else if  Date().hour(from: dateValue) > 0
        {
            // daysAgoLabel.isHidden = false
           customCellForNotification.productTimeLabel.text  =   "Updated \(Date().hour(from: dateValue)) hour ago"
        }
        else if  Date().minute(from: dateValue) > 0
        {
            // daysAgoLabel.isHidden = false
            customCellForNotification.productTimeLabel.text  =   "Updated \(Date().minute(from: dateValue)) minute ago"
        }
            
        else if  Date().seconds(from:dateValue) > 0
        {
            // daysAgoLabel.isHidden = false
            customCellForNotification.productTimeLabel.text  =   "Updated \(Date().seconds(from:  dateValue)) second ago"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let notificationObj = self.items[indexPath.item]
        if(notificationObj.type == Constants.NotificationType.TYPE_SELL_BOUGHT )
        {
            selectedProduct = notificationObj.product
            self.performSegue(withIdentifier: "NotificationToProductsDetailVC", sender: self)


        }
        else   if(notificationObj.type == Constants.NotificationType.TYPE_FOLLOW )
        {
            selectedUser = notificationObj.otherUser
            self.performSegue(withIdentifier: "NotificationToProfileViewController", sender: self)

            
        }
        else   if(notificationObj.type == Constants.NotificationType.TYPE_LIKE )
        {
            selectedProduct = notificationObj.product
            self.performSegue(withIdentifier: "NotificationToProductsDetailVC", sender: self)


        }
        else   if(notificationObj.type == Constants.NotificationType.TYPE_COMMENT )
        {
            selectedProduct = notificationObj.product
            self.performSegue(withIdentifier: "NotificationToProductsDetailVC", sender: self)


        }
        else   if(notificationObj.type == Constants.NotificationType.TYPE_SELL_CONFIRMED )
        {
            selectedProduct = notificationObj.product
            self.performSegue(withIdentifier: "NotificationToProductsDetailVC", sender: self)


        
        }
        else   if(notificationObj.type == Constants.NotificationType.TYPE_SELL_SENT )
        {
            selectedProduct = notificationObj.product
            self.performSegue(withIdentifier: "NotificationToProductsDetailVC", sender: self)


        }
        
    }
    
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item",item.tag)
        if(item.tag == 2)
        {
            //load new view
            self.performSegue(withIdentifier: "SellToProfileViewcontroller", sender: self)
            
        }
        else if(item.tag == 4)
        {
            //load new view
            self.performSegue(withIdentifier: "SellToProductView", sender: self)
        }
        //SellToProfileViewcontroller
        //This method will be called when user changes tab.
    }
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NotificationToProfileViewController") {
            let viewController:ProfileViewController = segue.destination as! ProfileViewController
            viewController.userObj = self.selectedUser
            // pass data to next view
        }
        else   if (segue.identifier == "NotificationToProductsDetailVC") {
            let viewController:ProductDetailViewController = segue.destination as! ProductDetailViewController
            viewController.productBO = selectedProduct
            
            // pass data to next view
        }

    }
    
}
