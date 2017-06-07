//
//  EditProfileViewController.swift
//  LismApp
//
//  Created by Arkhitech on 7/6/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import AVOSCloud
class EditProfileViewController: UIViewController,UITabBarDelegate,WWCalendarTimeSelectorProtocol
{
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
    @IBOutlet weak var progressView : UIActivityIndicatorView!

    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showCalendar(sender : AnyObject) {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        /*
         Any other options are to be set before presenting selector!
         */
        
        present(selector, animated: true, completion: nil)
    }
   
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print(date)
    }
    
}
