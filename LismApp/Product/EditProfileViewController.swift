//
//  EditProfileViewController.swift
//  LismApp
//
//  Created by Arkhitech on 7/6/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import AVOSCloud
class EditProfileViewController: UIViewController,UITabBarDelegate,WWCalendarTimeSelectorProtocol,UITextViewDelegate
{
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var profileImageBtn : UIButton!
    @IBOutlet weak var websiteTextField  : UITextField!
    @IBOutlet weak var descriptionTextview  : UITextView!
    @IBOutlet weak var maleBtn : UIButton!
    @IBOutlet weak var femaleBtn : UIButton!

    
    let PLACEHOLDER_TEXT = "Write your introduction here for others to see"

    override func viewDidLoad() {
        super.viewDidLoad()
        websiteTextField.layer.borderWidth = 1.0
        websiteTextField.layer.borderColor = UIColor.gray.cgColor
        descriptionTextview.layer.borderWidth = 1.0

        descriptionTextview.layer.borderColor = UIColor.gray.cgColor
        applyPlaceholderStyle(aTextview: descriptionTextview, placeholderText: PLACEHOLDER_TEXT)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImageBtn.layer.cornerRadius = profileImageBtn.frame.size.height/2
        profileImageBtn.layer.masksToBounds = true

    }
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showCalendar(sender : AnyObject) {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        /*
         Any other options are to be set before presenting selector!
         */
        
        present(selector, animated: true, completion: nil)
    }
   
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print(date)
    }
    
    @IBAction func saveBtnAction(sender : AnyObject)
    {
    
    
    }
    @IBAction func skipBtnAction(sender : AnyObject)
    {
        
        
    }
    @IBAction func linkWithWeChatBtnAction(sender : AnyObject)
    {
        
        
    }
    @IBAction func maleBtnAction(sender : AnyObject)
    {
        maleBtn.isSelected = !maleBtn.isSelected
        femaleBtn.isSelected = !femaleBtn.isSelected

    }
    @IBAction func femaleBtnAction(sender : AnyObject)
    {
        maleBtn.isSelected = !maleBtn.isSelected
        femaleBtn.isSelected = !femaleBtn.isSelected
        
    }

    @IBAction func addProfilePictureBtnAction(sender : AnyObject)
    {
        
        
    }
    
    
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
        
    }
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool
    {
        if aTextView == descriptionTextview && aTextView.text == PLACEHOLDER_TEXT
        {
            // move cursor to start
            //moveCursorToStart(aTextView: aTextView)
            aTextView.text = ""
        }
        return true
    }
    func moveCursorToStart(aTextView: UITextView)
    {
        aTextView.selectedRange = NSMakeRange(0, 0);
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            // check if the only text is the placeholder and remove it if needed
            // unless they've hit the delete button with the placeholder displayed
            if textView == descriptionTextview && textView.text == PLACEHOLDER_TEXT
            {
                if text.utf16.count == 0 // they hit the back button
                {
                    return false // ignore it
                }
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            applyPlaceholderStyle(aTextview: textView, placeholderText: PLACEHOLDER_TEXT)
            moveCursorToStart(aTextView: textView)
            return false
        }
    }

}
