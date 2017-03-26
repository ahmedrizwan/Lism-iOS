
import Foundation
import UIKit
import AVOSCloud

class ProductDetailViewController: UIViewController
{
    @IBOutlet weak var scrollView : UIScrollView!
    var productBO : Product!
    
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var favoriteBtn : UIButton!
    @IBOutlet weak var brandNameLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var sizeLabel : UILabel!
    @IBOutlet weak var estRetailLabel : UILabel!
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var daysAgoLabel : UILabel!
    @IBOutlet weak var likesLabel : UILabel!


    override func viewDidLoad() {
        let backImg: UIImage = UIImage(named: "back_btn")!
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImg, for: .normal, barMetrics: .default)
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.updateProductDetails()
    }
    func updateProductDetails()
    {
        if(productBO.productImageUrl != nil)
        {
           productImage.sd_setImage(with: productBO.productImageUrl, placeholderImage: nil)
    
        }
        favoriteBtn.isSelected = productBO.favorite
        likesLabel.text = "\(productBO.productLikes)"
        
    }
    
    @IBAction func addToCart(sender : AnyObject)
    {
    
    }
    
    func addToCartAction(message: String)
    {
        let query: AVQuery = (AVUser.current()?.relation(forKey: "userCart").query())!
        query.findObjectsInBackground { (objects, error) in
            
            if(error == nil)
            {
                Constants.showAlert(message: self.productBO.name + message,view: self)
            }
            else
            {
            //show error mesage
            }
        }
        

    }
}

