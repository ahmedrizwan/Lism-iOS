
import Foundation
import AVOSCloud

class UpdatePostedItemForSaleViewController: UIViewController,UIImagePickerControllerDelegate,    UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource, UITextViewDelegate , UIGestureRecognizerDelegate
{
    
    @IBOutlet weak var colorsTableView : UITableView!
    @IBOutlet weak var colorsTableViewParent : UIView!
    
    @IBOutlet weak var mainColorsView : UIView!
    
    @IBOutlet weak var selectedCategoryBtn : UIButton!
    @IBOutlet weak var sizesBtn : UIButton!
    @IBOutlet weak var sizesBtnHeightConstaint : NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstaint : NSLayoutConstraint!
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var progressBar : UIActivityIndicatorView!
    
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
    var primarySelected = false
    var selectedBtn = UIButton()
    var btnToUpdateText = UIButton()
    var crossBtnToEnable = UIButton()
    var nextBtnToEnable = UIButton()
    var deletedImages = UIButton()

    var colors :[String] = []
    var categories : [String: Any] = ["" : ""]
    var sizes : [String: Any] = ["" : ""]
    
    var isShoesOrClothing = false
    
    var brands :[AVObject] = []
    var itemConditions : [String: Any]!
    var itemConditionsToRender : [String: Any]!
    
    
    let picker = UIImagePickerController()
    var colorsDictionary  : [String: String]!
    
    var arrayOFEnabledButtons = [UIButton]()
    var arrayOFImagesToUpload = [UIButton]()
    var arrayOFImagesToRemove = [UIButton]()

    var allButtons = [UIButton]()
    var itemToPostcount = 0
    var  productObj  : Product!
    var firstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.createColrosDict()
        self.progressBar.isHidden = true
        
        // This is for rounded corners
        self.mainColorsView.layer.cornerRadius = 10
        self.mainColorsView.layer.masksToBounds = true
        allButtons.append(addCamBtn1)
        allButtons.append(addCamBtn2)
        allButtons.append(addCamBtn3)
        allButtons.append(addCamBtn4)
        allButtons.append(addCamBtn5)
        
        self.hideKeyboardWhenTappedAround()
        
        }

    @IBAction func closeTableView(sender : AnyObject)
    {
        colorsTableViewParent.isHidden = true;

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(firstTime)
        {
        self.viewHeightConstaint.constant = 115
        loadInfo() {
            print("Background Fetch Complete")
            self.firstTime = false
        }
        self.setUpDescriptionTextView()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.progressBar.isHidden = true
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1060)
        addCamBtn1.frame = CGRect(x: addCamBtn1.frame.origin.x, y: addCamBtn1.frame.origin.y, width: addCamBtn1.frame.size.width, height: addCamBtn1.frame.size.width)
        addCamBtn2.frame = CGRect(x: addCamBtn2.frame.origin.x, y: addCamBtn1.frame.origin.y, width: addCamBtn1.frame.size.width, height: addCamBtn1.frame.size.width)
        addCamBtn3.frame = CGRect(x: addCamBtn3.frame.origin.x, y: addCamBtn1.frame.origin.y, width: addCamBtn1.frame.size.width, height: addCamBtn1.frame.size.width)
        addCamBtn4.frame = CGRect(x: addCamBtn4.frame.origin.x, y: addCamBtn1.frame.origin.y, width: addCamBtn1.frame.size.width, height: addCamBtn1.frame.size.width)
        addCamBtn5.frame = CGRect(x: addCamBtn5.frame.origin.x, y: addCamBtn1.frame.origin.y, width: addCamBtn1.frame.size.width, height: addCamBtn1.frame.size.width)
        
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
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
        
        self.productNameTextfield.text = self.productObj.name
        self.brandTextfield.text = self.productObj.brand
        self.descTextView.text = self.productObj.prodcut_description


        self.sellingPriceTextField.text = "\(self.productObj.sellingPrice)"
        self.estimatedTextField.text = "\(self.productObj.priceRetail)"
        self.selectedCategoryBtn.setTitle(self.productObj.category, for: .normal)
        self.selectedCategoryBtn.titleLabel?.text = self.productObj.category

       

        
        if(self.productObj.size != "")//|| !self.sizesBtn.isHidden)
        {
            self.sizesBtnHeightConstaint.constant = self.selectedCategoryBtn.frame.size.height
            self.sizesBtn.isHidden = false
            
            self.viewHeightConstaint.constant = 165
            self.sizesBtn.setTitle(self.productObj.size, for: .normal)
            self.sizesBtn.titleLabel?.text = self.productObj.size
        }
        else
        {
            self.sizesBtnHeightConstaint.constant = 0
            self.sizesBtn.isHidden = true
            self.viewHeightConstaint.constant = 115
            
        }
        self.itemsConditionBtn.setTitle(self.productObj.condition, for: .normal)
        self.itemsConditionBtn.titleLabel?.text = self.productObj.condition

        
        self.colorsBtn.setTitle(self.productObj.color, for: .normal)
        self.colorsBtn.titleLabel?.text = self.productObj.color

        if(productObj.productImageUrl != nil)
        {
            primarySelected = true
            
           // self.updateImageViewStatus(buttonTOSet: addCamBtn1,crossButtonToEnable : crossBtn1,imageURL: self.productObj.productImageUrl)
        }
        
        var index =  1
        
        for imageUrl in self.productObj.productImagesArray
        {
            if(index == 1)
            {
                self.updateImageViewStatus(buttonTOSet: addCamBtn1,crossButtonToEnable : crossBtn1 ,imageURL: imageUrl)
            }
            else if(index == 2)
            {
                self.updateImageViewStatus(buttonTOSet: addCamBtn2,crossButtonToEnable : crossBtn2,imageURL: imageUrl)
            }
            else if(index == 3)
            {
                self.updateImageViewStatus(buttonTOSet: addCamBtn3,crossButtonToEnable : crossBtn3 ,imageURL: imageUrl)
            }
            
            else if(index == 4)
            {
                self.updateImageViewStatus(buttonTOSet: addCamBtn4,crossButtonToEnable : crossBtn4 ,imageURL: imageUrl)
            }
            
            else if(index == 5)
            {
                self.updateImageViewStatus(buttonTOSet: addCamBtn5,crossButtonToEnable : crossBtn5 ,imageURL: imageUrl)
            }
            
            index = index + 1

        }
        
        descTextView.layer.borderWidth = 1.0
        descTextView.delegate = self
      
        
    }
    func updateImageViewStatus(buttonTOSet : UIButton, crossButtonToEnable :UIButton, imageURL : URL )
        {
            buttonTOSet.sd_setBackgroundImage(with: imageURL, for: .normal)
            self.crossBtnToEnable = crossButtonToEnable
            arrayOFEnabledButtons.append(buttonTOSet)
            self.enableNextButton()
        }
    func loadInfo(completionHandler: (() -> Void)!) {
        self.loadBrandsInfo(completionHandler: completionHandler)
       
//
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
        self.primarySelected = false
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
        var indexOfButton = arrayOFEnabledButtons.index(of: imageToClear)
        if(indexOfButton != nil)
        {
            arrayOFEnabledButtons.remove(at: indexOfButton!)
            arrayOFImagesToRemove.append(imageToClear)
        }
        
        indexOfButton = arrayOFImagesToUpload.index(of: imageToClear)
        if(indexOfButton != nil)
        {
            arrayOFImagesToUpload.remove(at: indexOfButton!)
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
        arrayOFImagesToUpload.append(self.selectedBtn)
        self.crossBtnToEnable = imageToEnable
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
        self.primarySelected = true

            self.enableNextButton()
             dismiss(animated:true, completion: nil) //5
    }
    
    func enableNextButton()
    {
        self.nextBtnToEnable = updateImageIfNotset()
        nextBtnToEnable.setBackgroundImage(UIImage(named : "addPhotoAsset 1"), for: .normal)
        self.crossBtnToEnable.isHidden = false

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
    
    func showAlert (error : String)
    {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func checkIfAllDataSet()-> Bool
    {
        if((self.productNameTextfield.text?.characters.count)! < 2)
        {
            self.showAlert(error: "Enter product name")
            return false
            
        }
        if((self.descTextView.text?.characters.count)! < 2)
        {
            self.showAlert(error: "Enter product description")
            
            return false
            
        }
        if((self.brandTextfield.text?.characters.count)! < 2)
        {
            self.showAlert(error: "Enter brand name")
            
            return false
            
        }
        if(arrayOFEnabledButtons.count == 0 && arrayOFImagesToUpload.count == 0)
        {
            self.showAlert(error: "Please upload atleast one image")
            
            return false
            
        }
        
        if((colorsBtn.title(for: .normal)!) == "SELECT COLOR")
        {
            self.showAlert(error: "Please choose color")
            
            return false
            
        }
        if((selectedCategoryBtn.title(for: .normal)!) == "CATEGORY")
        {
            self.showAlert(error: "Please select category")
            
            return false
            
        }
        if((itemsConditionBtn.title(for: .normal)!) == "ITEM CONDITION")
        {
            self.showAlert(error: "Please choose item condition")
            
            return false
            
        }
        
        if((self.estimatedTextField.text?.characters.count)! <= 0 )
        {
            self.showAlert(error: "Enter estimated price")
            
            return false
            
        }
        if((self.sellingPriceTextField.text?.characters.count)! <= 0 )
        {
            self.showAlert(error: "Enter selling price")
            
            return false
            
        }
        
        return true
    }
    
    @IBAction func  postForSaleAction(sender : AnyObject)
    {
        if(self.checkIfAllDataSet())
        {
            postForSaleBtn.isUserInteractionEnabled = false
            self.itemToPostcount = arrayOFImagesToUpload.count
            // All done!
            progressBar.isHidden = false
            for imageBtn in arrayOFImagesToRemove
            {
           let btnUrl =  imageBtn.sd_imageURL(for: .normal)
                for avImageObject in  self.productObj.productImagesObjects
                {
                    if let productImageUrl = avImageObject.object(forKey: "imageUrl")
                       
                        {
                            if(URL(string: productImageUrl as! String) ==  btnUrl)
                            {
                                self.productObj.relation(forKey: "images").remove(avImageObject)

                            }
                        }

                }
            }
            if(arrayOFImagesToUpload.count>0)
            {
            for imageBtn in arrayOFImagesToUpload
            {
                self.uploadImageViewController(scaledImage: imageBtn.backgroundImage(for: .normal)!,product: productObj )
            }
            }
            else
            {
                self.saveProductWithImage(productBO: self.productObj , imagesObject : AVObject())

            }
            
        }
        
    }
    func uploadProductWithImage(product:AVObject) -> Product
    {
        product.setObject(self.productNameTextfield.text, forKey: "name")
        product.setObject(self.descTextView.text, forKey: "description")
        product.setObject(self.brandTextfield.text!, forKey: "brand")
        product.setObject(colorsBtn.title(for: .normal)!, forKey: "color")
        product.setObject(AVUser.current(), forKey: "user")
        product.setObject("Posted for Sale", forKey: "status")
        
        product.setObject(self.selectedCategoryBtn.title(for: .normal)!, forKey: "category")
        if(self.sizesBtn.title(for: .normal) == "SIZE")
        {
        product.setObject(self.sizesBtn.title(for: .normal)!, forKey: "size")
        }
        product.setObject(itemsConditionBtn.title(for: .normal)!, forKey: "condition")
        product.setObject(self.estimatedTextField.text!, forKey: "priceRetail")
        product.setObject(Int(self.sellingPriceTextField.text!)!, forKey: "priceSelling")
        
        product.setObject(0, forKey: "productLikes")
        
        //    presenter.onPostClick(v, product, imageFiles);
        return product as! Product
        //self.saveProductWithImage(productBO: product, imagesObject: imageObjects)
    }
    func saveProductWithImage(productBO : Product, imagesObject : AVObject )
    {
        let query: AVQuery = AVQuery(className: "Product")
        query.whereKey("objectId", equalTo: self.productObj.objectId!)
        query.getFirstObjectInBackground { (object, error) in
            
            var productInfo = object
            productInfo = self.uploadProductWithImage(product : self.productObj)
        productInfo?.saveInBackground  { (objects, error) in
            if(error == nil)
            {
                if(self.itemToPostcount == 0)
                {
                    
                    AVUser.current()?.relation(forKey: Constants.SELL_PRODUCTS).add(productBO)
                    
                    AVUser.current()?.saveInBackground { (objects, error) in
                        self.postForSaleBtn.isUserInteractionEnabled = false
                        
                        if(error == nil)
                        {
                            self.progressBar.isHidden = true
                            self.showAlertView()
                            // show product has been posted and redirection
                            print("show product has been posted and redirection")
                        }
                        else
                        {
                            //show error mesage
                        }
                    }
                }
            }
            
            
            }
        }
    }
    
    func uploadImageViewController(scaledImage: UIImage , product : Product)
    {
        
        let imageData = UIImagePNGRepresentation(scaledImage)
        let imageFile:AVFile = AVFile(data: imageData!)
        imageFile.saveInBackground { (status, error) in
            if(error == nil)
            {
                self.itemToPostcount = self.itemToPostcount - 1
                if( !self.primarySelected )
                {
                    self.primaryImageUploaded(imageFile: imageFile, product: product , isPrimary: true)
                    //self.uploadProductWithImage(imageObjects: imageFile)
                }
                else
                {

                    self.productImageUploaded(imageFile: imageFile, product: product)
                }
                //uploaded sucess fully
            }
            else{
                self.postForSaleBtn.isUserInteractionEnabled = false
                
            }
        }
        
    }
    
    func primaryImageUploaded (imageFile : AVFile , product : Product , isPrimary : Bool)
    {
        let object = AVObject.init(className: "ProductImage")
        object.setObject(imageFile.url, forKey: "imageUrl")
        object.saveInBackground  {(status, error) in
            if(error == nil)
            {
                //uploaded sucess fully
                if(isPrimary)
                {
                    product.setObject(imageFile.url!, forKey: "primaryImageUrl")
                    product.relation(forKey: "images").add(object)
   
                }
                self.saveProductWithImage(productBO: product , imagesObject : object)
            }
        }
    }
    
    
    func productImageUploaded (imageFile : AVFile , product : Product)
    {
        let object = AVObject.init(className: "ProductImage")
        object.setObject(imageFile.url, forKey: "imageUrl")
        object.saveInBackground  {(status, error) in
            if(error == nil)
            {
                product.relation(forKey: "images").add(object)

                self.saveProductWithImage(productBO: product , imagesObject : object)
            }
        }
    }
    
    
    
    func showAlertView()
    {
        let alert = UIAlertController(title: "Success", message: "Product has been posted for sale", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            self.backbuttonAction(sender: "" as AnyObject)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadCategoriesInfo(completionHandler: (() -> Void)!)
    {
        
        let query: AVQuery = AVQuery(className: "Category")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                self.categories = self.convertToDictionary(text:(objects?[0] as! AVObject).value(forKey: "value") as! String)!
                for (_, value) in self.categories {
                 
                    print("key: \(value)")
                    if (value is NSArray )
                    {
                
                  //  self.sizes = (value as! NSArray )["sizes"]  as! [String: Any]
                    
                    }
                }
            }
        }
            
            self.loadItemsConditionInfo(completionHandler: completionHandler)

            
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
    
    
    func loadBrandsInfo(completionHandler: (() -> Void)!)
    {
        
        let query: AVQuery = AVQuery(className: "Brand")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                self.brands = objects as! [AVObject]
            }
            
            self.loadColorsInfo(completionHandler: completionHandler)
                   }
        
    }
    func loadColorsInfo(completionHandler: (() -> Void)!)
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
            self.loadCategoriesInfo(completionHandler : completionHandler)
           
            
            
        }
        
    }
    func loadItemsConditionInfo(completionHandler: (() -> Void)!)
    {
        
        let query: AVQuery = AVQuery(className: "ItemConditions")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                
                self.itemConditions = self.convertToDictionary(text:(objects?[0] as! AVObject).value(forKey: "value") as! String)!
                
                
            }
            
             completionHandler()
            
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
                if(self.selectedCategoryBtn.titleLabel?.text == "Shoes" || self.selectedCategoryBtn.titleLabel?.text == "Clothing" )//|| !self.sizesBtn.isHidden)
                {
                    self.sizesBtnHeightConstaint.constant = self.selectedCategoryBtn.frame.size.height
                    self.sizesBtn.isHidden = false
                    
                    self.viewHeightConstaint.constant = 165
                    
                }
                else if(self.btnToUpdateText != self.sizesBtn)
                {
                    self.sizesBtnHeightConstaint.constant = 0
                    self.sizesBtn.isHidden = true
                    self.viewHeightConstaint.constant = 115
                    
                }
                self.scrollView.updateConstraintsIfNeeded()
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
            let okAction = UIAlertAction(title: "\(key)".capitalizeFirst(), style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                
                
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
        
        _ = navigationController?.popViewController(animated: true)
    }
}
