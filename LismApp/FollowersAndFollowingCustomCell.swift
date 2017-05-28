//
//  UserFollowersCustomCell.swift
//  LismApp
//
//  Created by Arkhitech on 28/5/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import UIKit

class FollowersAndFollowingCustomCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFollowersOrFollowingButton: UIButton!
    
    @IBOutlet weak var delegate  : FollowersViewControllers!
    @IBOutlet weak var delegateforFollowing  : FollowingsViewController!

    @IBAction func userFollowersButtonAction(sender : AnyObject)
    {
    
        
        let btn = sender as! UIButton
        delegate.followThisUser(index: btn.tag)

    }
    
    
    @IBAction func userFollowingButtonAction(sender : AnyObject)
    {
        
        let btn = sender as! UIButton
        delegateforFollowing.unfollowThisUser(index: btn.tag)
    }
    
}
