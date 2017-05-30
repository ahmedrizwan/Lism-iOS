//
//  FollowersViewControllers.swift
//  LismApp
//
//  Created by Arkhitech on 28/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation

import AVOSCloud

class FollowersViewControllers: UIViewController, UITableViewDelegate, UITableViewDataSource,UITabBarDelegate
{
    
    

    @IBOutlet weak var  followersTableView : UITableView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    var userFollowersArray : [AVUser] = [AVUser]()
    var userObjInfo : AVUser!
    var userFollowingsArray: [AVUser] = [AVUser]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateFollowingsList()
        
        //if no items posted for sale so far then we will show no items details view
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.followersTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //   self.progressView.isHidden = true
        
    }
        // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFollowersArray.count
    }
    
    // cell height
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersAndFollowingCustomCell", for: indexPath ) as! FollowersAndFollowingCustomCell
        let userObj = self.userFollowersArray[indexPath.item]
        if let parseFile = userObj.value(forKey: "profileImage")
        {
            let userImageFile = parseFile as! AVFile
            userImageFile.getDataInBackground({ (data, error) in
                cell.userImageView.image = UIImage.init(data: data!)
                  cell.userImageView.layer.cornerRadius =    cell.userImageView.frame.size.width/2
                  cell.userImageView.clipsToBounds = true
                
            })
        }
        
        if(userObj.objectId != AVUser.current()?.objectId)
        {
            cell.userFollowersOrFollowingButton.isHidden = false
        if(self.checkIfUserFollowingThisUser(userObj: userObj))
        {
        //following
            cell.userFollowersOrFollowingButton.backgroundColor =  UIColor(colorLiteralRed: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)
            cell.userFollowersOrFollowingButton.setTitle("FOLLOWING", for: .normal)
        }
        else //not following
        {
            
            cell.userFollowersOrFollowingButton.backgroundColor =  UIColor(colorLiteralRed: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            cell.userFollowersOrFollowingButton.setTitle("FOLLOW +", for: .normal)
        //show follo
            
        }
        }
        else
        {
            cell.userFollowersOrFollowingButton.isHidden = true

        }

        cell.tag = indexPath.item
        cell.delegate = self
        cell.userFollowersOrFollowingButton.tag = indexPath.item
        cell.userNameLabel.text =  "@\(userObj.username!)"
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
    }
    func followThisUser(index : Int)
    {
        self.progressView.isHidden = false
        self.progressView.startAnimating()
        let userObj  = self.userFollowersArray[index]
        if(self.checkIfUserFollowingThisUser(userObj: userObj))
        {
        AVUser.current()?.unfollow(userObj.objectId!, andCallback: { (status, error) in
           self.updateFollowingsList()
        })
        }
        else
        {
           AVUser.current()?.follow(userObj.objectId!, andCallback: { (status, error) in
            self.updateFollowingsList()
        })
        
        }
        
        
    }
    
    func checkIfUserFollowingThisUser (userObj : AVUser) ->Bool
    {
            var isFound = false
        
                if self.userFollowingsArray.contains(where: { $0.objectId ==  userObj.objectId }) {
                    //found here
                    isFound = true
                }
            return isFound
    }

    
    func updateFollowingsList ()
    {
        self.progressView.isHidden = false
        self.progressView.startAnimating()
        AVUser.current()?.getFollowees { (objects, error) in
        
            if(error == nil)
            {
                self.progressView.isHidden = true
                self.progressView.stopAnimating()
                self.userFollowingsArray = (objects as! [AVUser])
               
                self.followersTableView.reloadData()

            }

        }
    }
    
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
