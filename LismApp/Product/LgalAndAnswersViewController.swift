//
//  LgalAndAnswersViewController.swift
//  LismApp
//
//  Created by Arkhitech on 10/6/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
class LgalAndAnswersViewController: UIViewController
{
    var titleString : String = String ()
    @IBOutlet weak var  textView : UITextView!
    @IBOutlet weak var  titleLabel : UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleString
    }
    
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }

}
