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
    @IBOutlet weak var  saveBtn : UIButton!

 var selectedLocale = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     selectedLocale = Localize.currentLanguage()
               self.updateBtnStatus()
    }
    
    func updateBtnStatus()
    {
        englishBtn.setTitle("English".localized(using: "Main"), for: .normal)
        saveBtn.setTitle("SAVE".localized(using: "Main"), for: .normal)

        if(selectedLocale == "en")
        {
            englishBtn.backgroundColor =  UIColor(colorLiteralRed: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            
            chineseBtn.backgroundColor =  UIColor(colorLiteralRed: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        }
        else
        {
            chineseBtn.backgroundColor =  UIColor(colorLiteralRed: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            
            englishBtn.backgroundColor =  UIColor(colorLiteralRed: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        }

    }
    ////en //zh-Hans
    @IBAction func englishBtnAction(sender : AnyObject)
    {
        //Localize.setCurrentLanguage("en")

        selectedLocale = "en"
        self.updateBtnStatus()

    }

    
    @IBAction func chineseBtnAction(sender : AnyObject)
    {
       // Localize.setCurrentLanguage("zh-Hans")
        selectedLocale = "zh-Hans"
        self.updateBtnStatus()


    
    }
    @IBAction func savebuttonAction(sender : AnyObject)
    {
        Localize.setCurrentLanguage(selectedLocale)
        self.updateBtnStatus()

        
    }
    
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
