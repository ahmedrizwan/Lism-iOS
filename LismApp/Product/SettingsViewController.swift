//
//  SettingsViewController.swift
//  LismApp
//
//  Created by Arkhitech on 7/6/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation

import AVOSCloud

class SettingsViewController: UIViewController, UITabBarDelegate,UITableViewDelegate, UITableViewDataSource
{
    var userImageFile : AVFile!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!

    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var profileTitleLabel : UILabel!
    @IBOutlet weak var  settingTableView : UITableView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    let section = ["SETTINGS", "SUPPORT", "LEGAL"]

let items = [["EDIT PROFILE", "LANGUAGE"], ["FAQ", "CONTACT US"], ["TERMS + CONDITIONS", "PRIVACY POLICY", "RETURN POLICY", "LOGOUT"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTitleLabel.text = "@\(AVUser.current()!.username!)"
       
        //if no items posted for sale so far then we will show no items details view
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(userImageFile != nil)
        {
            userImageFile.getDataInBackground({ (data, error) in
                self.imageView.image = UIImage.init(data: data!)
                self.imageView.layer.cornerRadius =    self.imageView.frame.size.width/2
                self.imageView.clipsToBounds = true
                
            })
            
        }
            }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //   self.progressView.isHidden = true
        
    }
    // MARK: UITableView
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 48))
            let menuHeaderLabel = UILabel(frame: CGRect(x: 16, y: 10, width: self.view.frame.size.width, height: 48))
        menuHeaderLabel.textColor =   UIColor(colorLiteralRed: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)

            menuHeaderLabel.text = self.section[section]
            menuHeaderLabel.font = UIFont(name: "Avenir-Book", size: 15.0)

            headerView.addSubview(menuHeaderLabel)
            return headerView
        }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count

    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count

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
        cell.settingBtn.setTitle(self.items[indexPath.section][indexPath.row], for: .normal)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {        

        
        if(indexPath.section == 0 && indexPath.row == 0)
        {
        self.performSegue(withIdentifier: "SettingsToEditProfileVC", sender: self)
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
       @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
