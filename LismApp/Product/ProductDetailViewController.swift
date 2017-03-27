
import Foundation
import UIKit
import AVOSCloud

class ProductDetailViewController: UIViewController,iCarouselDataSource,iCarouselDelegate
{
    @IBOutlet weak var scrollView : UIScrollView!
    var productBO : Product!
    var commentsArray : [Comments]!
    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var favoriteBtn : UIButton!
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var priceSizeNameTextView : UITextView!
    @IBOutlet weak var sellingPriceLabel : UILabel!
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var daysAgoLabel : UILabel!
    @IBOutlet weak var likesLabel : UILabel!

    @IBOutlet var vwCarousel: iCarousel!
    override func viewDidLoad() {
     //   let backImg: UIImage = (UIImage(named: "back_btn")
        let backImage = UIImage(named: "back_btn")
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImage, for: .normal, barMetrics: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-1000, -1000), for: .default)

        
      //  UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImg, for: .normal, barMetrics: .default)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        imageView.contentMode = .scaleAspectFit
        
      
        
        let image = UIImage(named: "logo")
        imageView.image = image
        self.navigationController?.navigationBar.backItem?.title = ""
        
        navigationItem.titleView = imageView
        self.updateProductDetails()
        vwCarousel.type = iCarouselType.rotary
        vwCarousel .reloadData()
        
    }
    func updateProductDetails()
    {
               favoriteBtn.isSelected = productBO.favorite
        likesLabel.text = "\(productBO.productLikes)"
        productNameLabel.text = productBO.name
        userNameLabel.text = "@" + (AVUser.current()?.username!)!

        priceSizeNameTextView.text = "\(productBO.brand) \n  Size \(productBO.size) \n  Est. Retail ¥ \(productBO.priceRetail)"
        sellingPriceLabel.text = "¥" + productBO.sellingPrice
        
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return productBO.productImagesArray.count
    }
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView 
    {
        var itemView: UIImageView
        if (view == nil)
        {
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:carousel.frame.size.width, height:carousel.frame.size.height))
            itemView.contentMode = .scaleAspectFit
        }
        else
        {
            itemView = view as! UIImageView;
        }
        itemView.sd_setImage(with: productBO.productImagesArray[index], placeholderImage: nil)

        return itemView
    }
    
    
    func loadComments()
    {
        let query: AVQuery = (productBO?.relationObjForComments.query())!
        query.findObjectsInBackground { (objects, error) in
            
            if(error == nil)
            {
                for obj in objects!
                {
                let commentBO:Comments =  Comments()
                commentBO.CommentInintWithDic(dict: obj as! AVObject)
                self.commentsArray.append(commentBO)
                }
            }
            else
            {
                //show error mesage
            }
        }
        
        
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

