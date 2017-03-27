
import Foundation
import UIKit
import AVOSCloud

class ProductDetailViewController: UIViewController,iCarouselDataSource,iCarouselDelegate
{
    @IBOutlet weak var scrollView : UIScrollView!
    var productBO : Product!
    
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var favoriteBtn : UIButton!
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var priceSizeNameTextView : UITextView!
    @IBOutlet weak var sellingPriceLabel : UILabel!
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var daysAgoLabel : UILabel!
    @IBOutlet weak var likesLabel : UILabel!

    @IBOutlet var vwCarousel: iCarousel!
    override func viewDidLoad() {
        let backImg: UIImage = UIImage(named: "back_btn")!
        
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImg, for: .normal, barMetrics: .default)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationController?.navigationBar.backItem?.title = ""
        
        navigationController?.navigationItem.titleView = imageView
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

