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
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.tag = indexPath.item
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
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
