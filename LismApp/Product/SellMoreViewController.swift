
import Foundation
import AVOSCloud

class SellMoreViewController: UIViewController,UIImagePickerControllerDelegate,    UINavigationControllerDelegate
{
    @IBOutlet weak var addCamBtn1 : UIButton!
    @IBOutlet weak var addCamBtn2 : UIButton!
    @IBOutlet weak var addCamBtn3 : UIButton!
    @IBOutlet weak var addCamBtn4 : UIButton!
    @IBOutlet weak var addCamBtn5 : UIButton!
    var colors :[AVObject] = []
    var categories :[AVObject] = []
    var brands :[AVObject] = []
    var itemConditions :[AVObject] = []

    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        loadInfo() {
            print("Background Fetch Complete")
        }
    }
    func loadInfo(completionHandler: (() -> Void)!) {
        self.loadBrandsInfo()
        self.loadColorsInfo()
        self.loadCategoriesInfo()
        self.loadItemsConditionInfo()
        completionHandler()
    }
    
    @IBAction func cameraAndAddButtonAction(sender : AnyObject)
    {
    
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
       // let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
       
        dismiss(animated:true, completion: nil) //5
    }
    
    @IBAction func categoryButtonAction(sender : AnyObject)
    {
        
        
    }
    @IBAction func selectColorButtonAction(sender : AnyObject)
    {
        
        
    }
    func loadCategoriesInfo()
    {
    
        let query: AVQuery = AVQuery(className: "Category")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
            self.categories = objects as! [AVObject]
            }
            
            
        }
        
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
                self.itemConditions = objects as! [AVObject]
            }
            
            
        }
        
    }
    func loadItemsConditionInfo()
    {
        
        let query: AVQuery = AVQuery(className: "ItemConditions")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                self.itemConditions = objects as! [AVObject]
            }
            
            
        }
    }


}
