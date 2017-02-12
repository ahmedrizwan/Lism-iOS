//
//  ProductCollectionViewCell.swift
//  Lism
//
//  Created by Nofel Mahmood on 09/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var sizeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var priceRetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var priceSellingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.nameAndFavBtnSv])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    lazy var nameAndFavBtnSv: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.productNameLabel, self.favoriteButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 8
        sv.distribution = .fillProportionally
        
        return sv
    }()
    
    lazy var pinToTopMainStackViewConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.mainStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        return constraint
    }()
    
    lazy var widthMainStackViewConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self.mainStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.size.width)
        
        return constraint
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(mainStackView)
        addConstraints([pinToTopMainStackViewConstraint, widthMainStackViewConstraint])
    
    }

}
