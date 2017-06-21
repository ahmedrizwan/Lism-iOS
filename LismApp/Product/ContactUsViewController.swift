//
//  ContactUsViewController.swift
//  LismApp
//
//  Created by Arkhitech on 21/6/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
class ContactUsViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var  textViewHeading : UITextView!
    @IBOutlet weak var  textViewDesc : UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textViewDesc.layer.borderColor = UIColor.gray.cgColor
        
        textViewDesc.layer.borderWidth = 1.0
        textViewDesc.delegate = self

    
    }
    
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
