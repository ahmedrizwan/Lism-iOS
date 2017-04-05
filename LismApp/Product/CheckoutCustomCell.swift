//
//  CheckoutCustomCell.swift
//  LismApp
//
//  Created by Arkhitech on 5/4/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import UIKit

class CheckoutCustomCell: UITableViewCell {
    @IBOutlet weak var sizeAndPriceTextView: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    var delegate : ProductCheckoutViewController!

    
    
    
    @IBAction func removeBtnAction(sender: UIButton)
    {
    
    delegate.removeCompletelyFromCheckoutOrder(item: sender.tag)
    }
    
    @IBAction func checkBoxBtnAction(sender: UIButton)
    {
        delegate.addOrRemoveFromCheckOutObj(item: sender.tag)

        
    }

    
    
}
