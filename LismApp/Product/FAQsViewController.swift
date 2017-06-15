//
//  FAQsViewController.swift
//  LismApp
//
//  Created by Arkhitech on 10/6/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation


import AVOSCloud

class FAQsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    var userImageFile : AVFile!
  
    @IBOutlet weak var  settingTableView : UITableView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    
    let items = [Constants.faq1_how_to_sell_an_item.localized(using: "Main"),Constants.faq2_how_do_recv_payment.localized(using: "Main"),Constants.faq3_how_to_pay.localized(using: "Main"), Constants.faq4_price_items.localized(using: "Main"), Constants.faq5_item_condition.localized(using: "Main"), Constants.faq6_how_shopping_words.localized(using: "Main"), Constants.faq7_why_item_removed.localized(using: "Main"), Constants.faq8_what_can_i_sell.localized(using: "Main"),Constants.faq9_how_to_buy_safely.localized(using: "Main"), Constants.faq10_sell_safely.localized(using: "Main"), Constants.faq11_not_recvd_item.localized(using: "Main")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if no items posted for sale so far then we will show no items details view
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingTableView.reloadData()
        
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //   self.progressView.isHidden = true
        
    }
    // MARK: UITableView
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
        
    }
    // cell height
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCustomCell", for: indexPath ) as! SettingsCustomCell
        cell.tag = indexPath.item
        cell.settingBtn.setTitle(self.items[indexPath.row].localized(using: "Main"), for: .normal)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        self.performSegue(withIdentifier: "FaqsToAnswersVC", sender: self)

        //
        
    }
    
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
