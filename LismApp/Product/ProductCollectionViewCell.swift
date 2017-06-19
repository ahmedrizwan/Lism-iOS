//
//  StoresCollectionViewCell.swift
//  HowMuch
//
//  Created by Arkhitech on 11/04/2016.
//  Copyright © 2016 Arkhitech. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    var delegate : ProductViewController!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var retailPriceTextView: UITextView!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var soldBannerImageView: UIImageView!

    @IBAction func addToFavoriteViewController(sender : AnyObject)
    {
        let btn = sender as! UIButton
        delegate.addToFavoriteButtonAction(index: btn.tag)
    }
}
