//
//  ProductCheckoutViewController.swift
//  LismApp
//
//  Created by Arkhitech on 5/4/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import UIKit
import AVOSCloud
class ProductCheckoutViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    

    @IBOutlet var checkOutTableView : UITableView!
    var checkoutArray : [Product] = []
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var totalLabel : UILabel!
    @IBOutlet weak var totalTextLabel : UILabel!
    @IBOutlet weak var continueBtn : UIButton!

    let relation = (AVUser.current()?.relation(forKey: "userCart"))! as AVRelation

    var totalPrice = 0
    override func viewDidLoad() {
        //   let backImg: UIImage = (UIImage(named: "back_btn")
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadCheckoutProducts()
totalTextLabel.text = "TOTAL".localized(using: "Main")
        continueBtn.setTitle("CONTINUE".localized(using: "Main"), for: .normal)
    }
    func loadCheckoutProducts()
    {
        progressView.isHidden = false
        let query: AVQuery = relation.query()
        query.includeKey("user")
        query.findObjectsInBackground { (objects, error) in
            self.progressView.isHidden = true
            if(error == nil)
            {
                self.checkoutArray.removeAll()
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                   // self.relation.add(productObj)
                    self.totalPrice =  self.totalPrice + productObj.sellingPrice
                    self.checkoutArray.append(productObj)
                }
                    self.totalLabel.text = "¥ \(self.totalPrice)"
                    self.checkOutTableView.reloadData()
            }
            else
            {
                Constants.showAlert(message: ("Unable to load products.").localized(using: "Main"), view: self)

            }
            
        }
        
     
    
    }
    
    func removeCompletelyFromCheckoutOrder(item : Int)
    {
        let productObj = self.checkoutArray[item]
        relation.remove(productObj)
    
        (AVUser.current())?.saveInBackground{ (objects, error) in
            self.progressView.isHidden = true
            if(error == nil)
            {
                self.totalPrice  =  self.totalPrice - productObj.sellingPrice
                self.totalLabel.text = "¥ \( self.totalPrice )"
                
                 self.checkoutArray.remove(at: item)
                
                self.checkOutTableView.reloadData()
            }
            
        }
    
    }
    func addOrRemoveFromCheckOutObj(item : Int)
    {
        let indexPath = IndexPath(item: item, section: 0)
       let cell = self.checkOutTableView.cellForRow(at: indexPath) as! CheckoutCustomCell

            cell.checkBtn.isSelected = !cell.checkBtn.isSelected
            let productObj = self.checkoutArray[indexPath.item]
        
            productObj.isAddedToCheckOut = cell.checkBtn.isSelected
        if(productObj.isAddedToCheckOut)
        {
            self.totalPrice  =  self.totalPrice + productObj.sellingPrice

            self.totalLabel.text = "¥ \(self.totalPrice )"

        }
        else
        {
            self.totalPrice  =  self.totalPrice - productObj.sellingPrice

            self.totalLabel.text = "¥ \(self.totalPrice )"

        }
    }
    
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkoutArray.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCustomCell", for: indexPath ) as! CheckoutCustomCell
        let productObj = self.checkoutArray[indexPath.item]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let brandInfo = (productObj.brand).uppercased()
        if(productObj.size == "")
        {
          cell.sizeAndPriceTextView.text = "\(brandInfo) \(productObj.name)\n¥ \(productObj.sellingPrice)"
        }
        else
        {
        cell.sizeAndPriceTextView.text = "\(brandInfo) \(productObj.name)\n\("Size".localized(using: "Main")) \(productObj.size) \n¥ \(productObj.sellingPrice)"
        }
        if(productObj.productImageUrl != nil)
        {
            cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }
        cell.checkBtn.isSelected = productObj.isAddedToCheckOut
        cell.delegate = self
        
        cell.checkBtn.tag = indexPath.row
        cell.removeBtn.tag  = indexPath.row
        cell.removeBtn.setTitle("Remove".localized(using: "Main"), for: .normal)
        cell.selectionStyle = UITableViewCellSelectionStyle.none;

        DispatchQueue.global().async {
            do {
                if let profileImage = productObj.user.value(forKey: "profileImage")
                {
                    let parseFile = profileImage as! AVFile
                    parseFile.getDataInBackground({ (data, error) in
                         DispatchQueue.main.async(execute: {
                        cell.userImageView.image = UIImage.init(data: data!)
                        cell.userImageView.layer.cornerRadius =  cell.userImageView.frame.size.width/2 
                        cell.userImageView.clipsToBounds = true
                        })
                    })
                    print("file exists");
                }
            }
           

        }
       

        return cell
    }

    @IBAction func backbuttonAction(sender : AnyObject)
    {
    
        _ = navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ProductListToCheckOutAddressViewController") {
            let viewController:CheckoutViewController = segue.destination as! CheckoutViewController
            viewController.checkoutArray = self.checkoutArray
            
            // pass data to next view
        }
    }
    
}
