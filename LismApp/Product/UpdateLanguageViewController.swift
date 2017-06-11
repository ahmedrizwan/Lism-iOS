//
//  UpdateLanguageViewController.swift
//  LismApp
//
//  Created by Arkhitech on 11/6/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
class UpdateLanguageViewController: UIViewController
{
    var titleString : String = String ()
   
    @IBOutlet weak var  englishBtn : UIButton!
    @IBOutlet weak var  chineseBtn : UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    ////en //zh-Hans
    @IBAction func englishBtnAction(sender : AnyObject)
    {
        Localize.setCurrentLanguage("en")
    }

    
    @IBAction func chineseBtnAction(sender : AnyObject)
    {
        Localize.setCurrentLanguage("zh-Hans")
    
    }
    @IBAction func savebuttonAction(sender : AnyObject)
    {
    }
    
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
