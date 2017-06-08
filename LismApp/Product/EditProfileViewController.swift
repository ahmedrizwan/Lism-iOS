//
//  EditProfileViewController.swift
//  LismApp
//
//  Created by Arkhitech on 7/6/17.
//  Copyright © 2017 Arkhitech. All rights reserved.
//

import Foundation
import AVOSCloud
class EditProfileViewController: UIViewController,UITabBarDelegate,WWCalendarTimeSelectorProtocol,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var profileImageBtn : UIButton!
    @IBOutlet weak var websiteTextField  : UITextField!
    @IBOutlet weak var descriptionTextview  : UITextView!
    @IBOutlet weak var maleBtn : UIButton!
    @IBOutlet weak var femaleBtn : UIButton!
    let picker = UIImagePickerController()
    var isImageSelected = false
    @IBOutlet weak var dobBtn : UIButton!
    var user : User = User()

    let PLACEHOLDER_TEXT = "Write your introduction here for others to see"

    override func viewDidLoad() {
        super.viewDidLoad()
        websiteTextField.layer.borderWidth = 1.0
        websiteTextField.layer.borderColor = UIColor.gray.cgColor
        descriptionTextview.layer.borderWidth = 1.0

        descriptionTextview.layer.borderColor = UIColor.gray.cgColor
        applyPlaceholderStyle(aTextview: descriptionTextview, placeholderText: PLACEHOLDER_TEXT)
        femaleBtn.isSelected = true
        picker.delegate = self
        self.getUserInfo()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImageBtn.layer.cornerRadius = profileImageBtn.frame.size.height/2
        profileImageBtn.layer.masksToBounds = true
    }
    func getUserInfo()
    {
        let query = AVUser.query()
        query.whereKey("objectId", equalTo: AVUser.current()!.objectId! as Any)
        query.getFirstObjectInBackground({ (object, error) in
            if object !== nil {
                self.progressView.isHidden = true
                if(error == nil)
                {
                    self.user =  object as! User
                    
                    
                     self.user.UserInintWithDic(dict:  object!)
                    if let parseFile = object?.value(forKey: "profileImage")
                    {
                         let userImageFile = parseFile as! AVFile
                        userImageFile.getDataInBackground({ (data, error) in
                            self.profileImageBtn.setBackgroundImage( UIImage.init(data: data!), for: .normal)
                            
                            
                        })
                    }
                    if let website:String = object!.value(forKey: "website") as! String?
                    {
                        if(website != "")
                        {
                        self.websiteTextField.text = website
                        }
                    }
                    if let dob:String = object!.value(forKey: "dob") as! String?
                    {
                        if(dob != "")
                        {
                        self.dobBtn.setTitle(dob, for: .normal)
                        }
                    }
                    if let gender:String = object!.value(forKey: "gender") as! String?
                    {
                        if(gender == "m")
                        {
                            self.maleBtn.isSelected = true
                            self.femaleBtn.isSelected = false
                        }
                    }

                    
                }
            }
        })
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
      
        
        let dateFormatter = DateFormatter()
      
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let availabletoDateTime = dateFormatter.string(from: date)
        let convertedDate = dateFormatter.date(from: availabletoDateTime)

        dateFormatter.dateFormat  = "yyyy/MM/dd"
        let dateValue =  dateFormatter.string(from: convertedDate!)
        self.dobBtn.setTitle(dateValue, for: .normal)
    }
    
    @IBAction func saveBtnAction(sender : AnyObject)
    {
       
        let userObj = AVUser.current()!
        if(self.dobBtn.title(for: .normal) != "SELECT DOB")
        {
            userObj.setObject(self.dobBtn.title(for: .normal), forKey: "dob")
        }
        userObj.setObject(self.websiteTextField.text, forKey: "website")
       userObj.setObject(self.descriptionTextview.text, forKey: "description")
        if(femaleBtn.isSelected)
        {
            userObj.setObject("f", forKey: "gender")

        }
        else
        {
            userObj.setObject("m", forKey: "gender")

        }
        
        if(isImageSelected)
        {
        let imageData = UIImagePNGRepresentation((self.profileImageBtn.backgroundImage(for: .normal))!)
        let imageFile:AVFile = AVFile(data: imageData!)
        imageFile.saveInBackground { (status, error) in
            if(error == nil)
            {
                
               userObj.setObject(imageFile, forKey: "profileImage")
                self.updateUserData(userInfo: userObj)

                //uploaded sucess fully
            }
            else{
                
            }
        }
        }
        else
        {
            self.updateUserData(userInfo: userObj)
        }
    }
    
    
    func updateUserData (userInfo : AVUser)
    {
        userInfo.saveInBackground { (status, error) in
            if(error == nil)
            {
                //go back
                self.backbuttonAction(sender: 0 as AnyObject)
            }
        }
    }
    
    
    @IBAction func skipBtnAction(sender : AnyObject)
    {
        
        _ = navigationController?.popViewController(animated: true)

    }
    @IBAction func linkWithWeChatBtnAction(sender : AnyObject)
    {
        
        
    }
    @IBAction func maleBtnAction(sender : AnyObject)
    {
        maleBtn.isSelected = !maleBtn.isSelected
        femaleBtn.isSelected = !maleBtn.isSelected

    }
    @IBAction func femaleBtnAction(sender : AnyObject)
    {
        femaleBtn.isSelected = !femaleBtn.isSelected
        maleBtn.isSelected = !femaleBtn.isSelected

        
    }

    @IBAction func addProfilePictureBtnAction(sender : AnyObject)
    {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
 
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageBtn.setBackgroundImage(chosenImage, for: .normal)
        } else if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageBtn.setBackgroundImage(chosenImage, for: .normal)
        } else {
            
        }
        self.isImageSelected = true
     
        dismiss(animated:true, completion: nil) //5
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
