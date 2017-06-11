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
    
    let items = [Constants.faq1_how_to_sell_an_item,Constants.faq2_how_do_recv_payment,Constants.faq3_how_to_pay, Constants.faq4_price_items, Constants.faq5_item_condition, Constants.faq6_how_shopping_words, Constants.faq7_why_item_removed, Constants.faq8_what_can_i_sell,Constants.faq9_how_to_buy_safely, Constants.faq10_sell_safely, Constants.faq11_not_recvd_item ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if no items posted for sale so far then we will show no items details view
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
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
        cell.settingBtn.setTitle(self.items[indexPath.row], for: .normal)
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
