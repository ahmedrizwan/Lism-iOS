
import Foundation
import UIKit
import AVOSCloud

class ProductDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var scrollView : UIScrollView!
    var productBO : Product!
    var commentsArray : [Comments] = []
    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var favoriteBtn : UIButton!
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var priceSizeNameTextView : UITextView!
    @IBOutlet weak var sellingPriceLabel : UILabel!
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var daysAgoLabel : UILabel!
    @IBOutlet weak var likesLabel : UILabel!

    @IBOutlet weak var descriptonView : UIView!
    @IBOutlet weak var scrollBtn : UIButton!
    
    @IBOutlet weak var commentsBtn : UIButton!
    @IBOutlet weak var productDescriptionBtn : UIButton!
    @IBOutlet weak var thirdViewBtn : UIButton!



    @IBOutlet weak var descriptonTextView : UITextView!
    @IBOutlet weak var colorMaterialTextView : UITextView!

    
    @IBOutlet weak var commentsView : UIView!
    @IBOutlet weak var commentsTableView : UITableView!


    @IBOutlet weak var policyView : UIView!

    
    
    
    @IBOutlet var slideshow: ImageSlideshow!
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
        
        self.addShadow(button: productDescriptionBtn)
        self.addShadow(button: thirdViewBtn)
        self.addShadow(button: commentsBtn)
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        scrollView.frame =  CGRect(x:  scrollView.frame.origin.x, y:  scrollView.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
        self.showDescriptionView(sender: "" as AnyObject)


    }
    func updateProductDetails()
    {
               favoriteBtn.isSelected = productBO.favorite
        likesLabel.text = "\(productBO.productLikes)"
        productNameLabel.text = productBO.name
        userNameLabel.text = "@" + (AVUser.current()?.username!)!

        priceSizeNameTextView.text = "\(productBO.brand) \n  Size \(productBO.size) \n  Est. Retail ¥ \(productBO.priceRetail)"
        sellingPriceLabel.text = "¥" + productBO.sellingPrice
        
          var sdWebImageSource = [InputSource]()
        for url in self.productBO.productImagesArray
        {
        sdWebImageSource.append(SDWebImageSource(urlString: url.absoluteString)!)
        }
       
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // try out other sources such as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(sdWebImageSource)

    }
    
    
    func addShadow(button : UIButton)
    {
        button.layer.shadowOpacity = 0.7
       // button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 5
    }
   
    
    func loadComments()
    {
        
       
       self.productBO.queryObj.findObjectsInBackground { (objects, error) in
            
            if(error == nil)
            {
                for obj in objects!
                {
                let commentBO:Comments =  Comments()
                commentBO.CommentInintWithDic(dict: obj as! AVObject)
                self.commentsArray.append(commentBO)
                }
                self.commentsTableView.reloadData()
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
    
    
    
    
    @IBAction func showDescriptionView(sender : AnyObject)
    {

        commentsBtn.isHidden = true
        productDescriptionBtn.isHidden = false
        thirdViewBtn.isHidden = true
        
        descriptonView.isHidden = false;
        commentsView.isHidden = true;
    
        descriptonTextView.text = self.productBO.prodcut_description
        colorMaterialTextView.text =   "Color: \(productBO.color) \n Material: \(productBO.size) \n Condition: \(productBO.condition)"

    }
    
    @IBAction func showCommentsView(sender : AnyObject)
    {
    
        commentsBtn.isHidden = false
        productDescriptionBtn.isHidden = true
        thirdViewBtn.isHidden = true

        
        descriptonView.isHidden = true;
        commentsView.isHidden = false;
        self.loadComments()
    }
    @IBAction func showPolicyView(sender : AnyObject)
    {
        commentsBtn.isHidden = true
        productDescriptionBtn.isHidden = true
        thirdViewBtn.isHidden = false
        
        descriptonView.isHidden = true;
        commentsView.isHidden = true;

    
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
    
    @IBAction func moveToScrollBottom()
    {
    
    }
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArray.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCustomCell", for: indexPath ) as! CommentsCustomCell
        let commentBO =  self.commentsArray[indexPath.row] 

        
        // connect objects with our information from arrays
        cell.nameLabel.text = commentBO.user.username
        cell.commentsTextView.text = commentBO.comment

             return cell
    }
}

