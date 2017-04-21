
import Foundation
import AVOSCloud

class SellMoreViewController: UIViewController,UIImagePickerControllerDelegate,    UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
    
    @IBOutlet weak var colorsTableView : UITableView!
    @IBOutlet weak var colorsTableViewParent : UIView!

    @IBOutlet weak var mainColorsView : UIView!

    @IBOutlet weak var selectedCategoryBtn : UIButton!
    @IBOutlet weak var sizesBtn : UIButton!
    @IBOutlet weak var sizesBtnHeightConstaint : NSLayoutConstraint!

    @IBOutlet weak var scrollView : UIScrollView!

    @IBOutlet weak var addCamBtn1 : UIButton!
    @IBOutlet weak var addCamBtn2 : UIButton!
    @IBOutlet weak var addCamBtn3 : UIButton!
    @IBOutlet weak var addCamBtn4 : UIButton!
    @IBOutlet weak var addCamBtn5 : UIButton!
    @IBOutlet weak var crossBtn1 : UIButton!
    @IBOutlet weak var crossBtn2 : UIButton!
    @IBOutlet weak var crossBtn3 : UIButton!
    @IBOutlet weak var crossBtn4 : UIButton!
    @IBOutlet weak var crossBtn5 : UIButton!
    
    @IBOutlet weak var colorsBtn : UIButton!
    
      @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var brandTextfield: UITextField!

    @IBOutlet weak var estimatedPriceLabel : UILabel!
    @IBOutlet weak var estimatedTextField: UITextField!

    @IBOutlet weak var sellingPriceLabel : UILabel!
    @IBOutlet weak var sellingPriceTextField: UITextField!
    @IBOutlet weak var itemsConditionBtn : UIButton!
    @IBOutlet weak var itemConditionLabel : UILabel!

    @IBOutlet weak var postForSaleBtn : UIButton!
     @IBOutlet weak var descTextView : UITextView!

    let PLACEHOLDER_TEXT = "PRODUCT DESCRIPTION"

    var selectedBtn = UIButton()
     var btnToUpdateText = UIButton()
    var crossBtnToEnable = UIButton()
    var nextBtnToEnable = UIButton()

    var colors :[String] = []
    var categories : [String: Any]!
    var sizes : [String: Any]!

     var isShoesOrClothing = false
    
    var brands :[AVObject] = []
    var itemConditions : [String: Any]!
    var itemConditionsToRender : [String: Any]!


    let picker = UIImagePickerController()
    var colorsDictionary  : [String: String]!
    
    var arrayOFEnabledButtons = [UIButton]()
    var allButtons = [UIButton]()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.createColrosDict()
        // This is for rounded corners
        self.mainColorsView.layer.cornerRadius = 10
        self.mainColorsView.layer.masksToBounds = true
        loadInfo() {
            print("Background Fetch Complete")
        }
        allButtons.append(addCamBtn1)
        allButtons.append(addCamBtn2)
        allButtons.append(addCamBtn3)
        allButtons.append(addCamBtn4)
        allButtons.append(addCamBtn5)
        self.setUpDescriptionTextView()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1050)
    }
    func setUpDescriptionTextView()
    {
        sizesBtnHeightConstaint.constant = 0
        productNameTextfield.layer.borderWidth = 1.0
        brandTextfield.layer.borderWidth = 1.0
        sellingPriceTextField.layer.borderWidth = 1.0
        estimatedTextField.layer.borderWidth = 1.0

        descTextView.layer.borderColor = UIColor.gray.cgColor
        productNameTextfield.layer.borderColor = UIColor.gray.cgColor
        brandTextfield.layer.borderColor = UIColor.gray.cgColor
        sellingPriceTextField.layer.borderColor = UIColor.gray.cgColor
        estimatedTextField.layer.borderColor = UIColor.gray.cgColor


        descTextView.layer.borderWidth = 1.0
        descTextView.delegate = self
        applyPlaceholderStyle(aTextview: descTextView, placeholderText: PLACEHOLDER_TEXT)
        
    }
    func loadInfo(completionHandler: (() -> Void)!) {
        self.loadBrandsInfo()
        self.loadColorsInfo()
        self.loadCategoriesInfo()
        self.loadItemsConditionInfo()
        completionHandler()
    }
    func createColrosDict()
    {
        colorsDictionary = ["black" : "#000000",
                            "white" : "#FFFFFF",
                            "grey" : "#808080",
                            "brown": "#8B4513",
                            "burgundy" : "#800020",
                            "red" : "#ff0000",
                            "blue" : "#0000ff",
                            "purple" : "#800080",
                            "pink" : "#ff69b4",
                            "orange" : "#ffa500",
                            "yellow" :"#ffff00",
                            "green" : "#008000",
                            "gold" : "#ffd700",
                            "silver" :"#c0c0c0",
                            
        
        ]
    
    }
    @IBAction func crossButton1Action(sender : AnyObject)
    {
        self.clearImage(imageToClear: addCamBtn1, imageToDisable : crossBtn1)
    }
    @IBAction func crossButton2Action(sender : AnyObject)
    {
        self.clearImage(imageToClear: addCamBtn2, imageToDisable : crossBtn2 )
 
    }
    @IBAction func crossButton3Action(sender : AnyObject)
    {
        self.clearImage(imageToClear: addCamBtn3, imageToDisable : crossBtn3 )
 
    }
    @IBAction func crossButton4Action(sender : AnyObject)
    {
        self.clearImage(imageToClear: addCamBtn4, imageToDisable : crossBtn4 )
   
    }
    @IBAction func crossButton5Action(sender : AnyObject)
    {
        self.clearImage(imageToClear: addCamBtn5, imageToDisable : crossBtn5)

    }
    func clearImage(imageToClear : UIButton ,imageToDisable : UIButton )
    {
        imageToDisable.isHidden = true
        imageToClear.isUserInteractionEnabled = true
        let indexOfButton = arrayOFEnabledButtons.index(of: imageToClear)
        if(indexOfButton != nil)
        {
        arrayOFEnabledButtons.remove(at: indexOfButton!)
        }
        let buttonToAdd = updateImageIfNotset()
        buttonToAdd.setBackgroundImage(UIImage(named :"addPhotoAsset 1"), for: .normal)
       //set all others as cam
        self.setAllOtherCamExcept(buttonWithAdd: buttonToAdd)
        // imageToClear.setBackgroundImage(UIImage(named :"camera"), for: .normal)
    }
    
    func setAllOtherCamExcept(buttonWithAdd : UIButton)
    {
        
        for button in allButtons
        {
            if(button != buttonWithAdd && !arrayOFEnabledButtons.contains(button))
            {
                button.setBackgroundImage(UIImage(named :"camera"), for: .normal)
            }
        }
    }

    
    func updateImageIfNotset() -> UIButton
    {
        
        for button in allButtons
        {
        if(!arrayOFEnabledButtons.contains(button))
        {
          return button
        }
        }
        return UIButton()
}
    
    @IBAction func camera1AddButtonAction(sender : AnyObject)
    {
        self.addCameraAction(selectedBtn: addCamBtn1, imageToEnable: crossBtn1, nextButtonToAdd : updateImageIfNotset())
    }
    @IBAction func camera2AddButtonAction(sender : AnyObject)
    {
        self.addCameraAction(selectedBtn: addCamBtn2, imageToEnable: crossBtn2 , nextButtonToAdd : updateImageIfNotset())

    }
    @IBAction func camera3AddButtonAction(sender : AnyObject)
    {
        self.addCameraAction(selectedBtn: addCamBtn3, imageToEnable: crossBtn3 , nextButtonToAdd : updateImageIfNotset())
   
    }
    @IBAction func camera4AddButtonAction(sender : AnyObject)
    {
        self.addCameraAction(selectedBtn: addCamBtn4, imageToEnable: crossBtn4 , nextButtonToAdd : updateImageIfNotset())
  
    }
    @IBAction func camera5AddButtonAction(sender : AnyObject)
    {
        self.addCameraAction(selectedBtn: addCamBtn5, imageToEnable: crossBtn5, nextButtonToAdd : updateImageIfNotset())

    }
    func addCameraAction(selectedBtn: UIButton, imageToEnable : UIButton  , nextButtonToAdd : UIButton)
    {
        self.selectedBtn = selectedBtn
         self.selectedBtn.isUserInteractionEnabled = false
        arrayOFEnabledButtons.append(self.selectedBtn)
        self.crossBtnToEnable = imageToEnable
        self.nextBtnToEnable = nextButtonToAdd
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
            selectedBtn.setBackgroundImage(chosenImage, for: .normal)
        } else if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedBtn.setBackgroundImage(chosenImage, for: .normal)
        } else {

        }
        nextBtnToEnable.setBackgroundImage(UIImage(named : "addPhotoAsset 1"), for: .normal)
         self.crossBtnToEnable.isHidden = false
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
        if aTextView == descTextView && aTextView.text == PLACEHOLDER_TEXT
        {
            // move cursor to start
            moveCursorToStart(aTextView: aTextView)
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
            if textView == descTextView && textView.text == PLACEHOLDER_TEXT
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
    
    @IBAction func itemCoditionButtonAction(sender : AnyObject)
    {
        btnToUpdateText = sender as! UIButton
         let dict = itemConditions as NSDictionary
         if(self.selectedCategoryBtn.titleLabel?.text == "Shoes" || self.selectedCategoryBtn.titleLabel?.text == "Handbags")
         {
           
            self.itemConditionsToRender = dict.value(forKey: "Shoes and Handbags") as! [String: Any]
  
        }
        else
         {
            self.itemConditionsToRender = dict.value(forKey: "Clothing And Accessories") as! [String: Any]

        }
              self.showAlertcontrollerForITemsCondtion(title: "Item Condition" , objectToDisplay : self.itemConditionsToRender)
}
    
    @IBAction func categoryButtonAction(sender : AnyObject)
    {
        btnToUpdateText = sender as! UIButton
        self.showAlertcontroller(title: "Categories" , objectToDisplay : self.categories)
    }
    @IBAction func sizeButtonAction(sender : AnyObject)
    {
        btnToUpdateText = sender as! UIButton
        self.showAlertcontroller(title: "Size" , objectToDisplay : self.sizes)
    }
    
    @IBAction func selectColorButtonAction(sender : AnyObject)
    {
        colorsTableViewParent.isHidden = false;
        colorsTableView.reloadData()
    }
    @IBAction func  postForSaleAction(sender : AnyObject)
    {
    
    }
    func loadCategoriesInfo()
    {
    
        let query: AVQuery = AVQuery(className: "Category")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
            self.categories = self.convertToDictionary(text:(objects?[0] as! AVObject).value(forKey: "value") as! String)!
                for (_, value) in self.categories {
                    print("key: \(value)")
                }
            }
            
            
        }
        
    }
    func convertToDictionary(text: String) ->[String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return  [String: [String]]()
    }


    func loadBrandsInfo()
    {
        
        let query: AVQuery = AVQuery(className: "Brand")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                self.brands = objects as! [AVObject]
            }
            
            
        }

    }
    func loadColorsInfo()
    {
        
        
        let query: AVQuery = AVQuery(className: "Color")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
            
                for object in objects!
                {
                let objectColor = object as! AVObject
                 self.colors.append(objectColor.value(forKey: "value") as! String)
                }
            }
            
            
        }
        
    }
    func loadItemsConditionInfo()
    {
        
        let query: AVQuery = AVQuery(className: "ItemConditions")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                
                self.itemConditions = self.convertToDictionary(text:(objects?[0] as! AVObject).value(forKey: "value") as! String)!
                
            
            }
            
            
            
        }
    }

    func showAlertcontroller(title: String, objectToDisplay : [String: Any])
{
 
    

    let alertController = UIAlertController(title: title, message:"", preferredStyle: UIAlertControllerStyle.alert)
    alertController.view.tintColor = UIColor.darkGray

    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
    }
    for (key, value) in objectToDisplay {
        print("key: \(value)")
        let okAction = UIAlertAction(title: "\(key)", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            
    
            self.btnToUpdateText.setTitle(result.title!, for: .normal)
            self.btnToUpdateText.titleLabel?.text = result.title!
            if(self.selectedCategoryBtn.titleLabel?.text == "Shoes" || self.selectedCategoryBtn.titleLabel?.text == "Clothing" || !self.sizesBtn.isHidden)
            {
                self.sizesBtnHeightConstaint.constant = self.selectedCategoryBtn.frame.size.height
                self.sizesBtn.isHidden = false
                
            }
            else
            {
                self.sizesBtnHeightConstaint.constant = 0
                self.sizesBtn.isHidden = true
            }
            self.view.updateConstraintsIfNeeded()
            if(value is NSArray)
            {
            self.showAlertcontrollerArray(title: "\(key)" , objectToDisplay: value as! [Any])
            }
                print(result.title!)
        }
        alertController.addAction(okAction)
        
    }
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func showAlertcontrollerForITemsCondtion(title: String, objectToDisplay : [String: Any])
    {
        
        
        
        let alertController = UIAlertController(title: title, message:"", preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = UIColor.darkGray
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        for (key, value) in objectToDisplay {
            print("key: \(value)")
            let okAction = UIAlertAction(title: "\(key)", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                
                
                self.btnToUpdateText.setTitle(key , for: .normal)
          
                print(result.title!)
            }
            alertController.addAction(okAction)
            
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    func showAlertcontrollerArray(title: String, objectToDisplay : [Any])
    {
      
        
        
        let alertController = UIAlertController(title: title, message:"", preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = UIColor.darkGray
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        var title = ""
    
        for value in objectToDisplay {
            print("key: \(value)")
            if(value is String)
            {
                title = value as! String
            }
            else if (value is NSDictionary)
            {
            let dict = value as! NSDictionary
                for (key, _) in dict
                {
                    title = key as! String
                }
            }
            
            if(title == "sizes")
            {
                let dict = value as! NSDictionary
                self.sizes = dict.value(forKey: "sizes") as! [String: Any]
                //populate this dict
            }
            else
            {
            let okAction = UIAlertAction(title: title, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                if (value is NSDictionary)
                {
                    let dict = value as! NSDictionary
                    
                    self.showAlertcontrollerArray(title: title , objectToDisplay: dict.value(forKey: result.title!) as! [Any])
                }
                self.btnToUpdateText.setTitle(result.title!, for: .normal)

                print(result.title!)
            }
                alertController.addAction(okAction)

            }
            
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorsCustomCell", for: indexPath ) as! ColorsCustomCell
        cell.colorTitle.text = self.colors[indexPath.row]
        cell.colorImage.layer.cornerRadius =   cell.colorImage.frame.size.width/2
        if(colorsDictionary[ (cell.colorTitle.text?.lowercased())!] != nil)
        {
        cell.colorImage.backgroundColor = hexStringToUIColor (hex:(colorsDictionary[ (cell.colorTitle.text?.lowercased())!]!))
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
     self.colorsTableViewParent.isHidden = true
    let currentCellValue = tableView.cellForRow(at: indexPath)! as! ColorsCustomCell
        colorsBtn.setTitle(currentCellValue.colorTitle.text, for: .normal)

    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    @IBAction func backbuttonAction(sender : AnyObject)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
}
