
import Foundation
import UIKit
import AVOSCloud
extension Date {
 
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
class ProductDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView : UIScrollView!
    var productBO : Product!
    var commentsArray : [Comments] = []
    @IBOutlet weak var progressBar : UIActivityIndicatorView!

    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var favoriteBtn : UIButton!
    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var priceSizeNameTextView : UITextView!
    @IBOutlet weak var sellingPriceLabel : UILabel!
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var daysAgoLabel : UILabel!
    @IBOutlet weak var likesLabel : UILabel!
    @IBOutlet weak var cartCountLabel : UILabel!

    @IBOutlet weak var cartBtn : UIButton!
    @IBOutlet weak var allCartBtn : UIButton!

    @IBOutlet weak var descriptonView : UIView!
    @IBOutlet weak var scrollBtn : UIButton!
    
    @IBOutlet weak var commentsBtn : UIButton!
    @IBOutlet weak var productDescriptionBtn : UIButton!
    @IBOutlet weak var thirdViewBtn : UIButton!

    @IBOutlet weak var commentsBtnView : UIView!
    @IBOutlet weak var productDescriptionBtnView : UIView!
    @IBOutlet weak var thirdViewBtnView : UIView!
    @IBOutlet var constraintForViewidth : NSLayoutConstraint!



    @IBOutlet weak var descriptonTextView : UITextView!
    @IBOutlet weak var colorMaterialTextView : UITextView!

    
    @IBOutlet weak var commentsView : UIView!
    @IBOutlet weak var commentsTableView : UITableView!


    @IBOutlet weak var policyView : UIView!
    @IBOutlet weak var policyTextView : UITextView!

    var isFoundIncart : Bool = false
    var messageForCart : String = String ()
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    @IBOutlet weak var horizontalScrolView : UIScrollView!
    var relation: AVRelation = AVRelation()
    
    override func viewDidLoad() {
     //   let backImg: UIImage = (UIImage(named: "back_btn")
       self.navigationController?.navigationBar.isHidden = true
        self.updateProductDetails()
        self.cartBtn.isHidden = true

        scrollView.delegate = self
        self.addShadow(button: productDescriptionBtn)
        self.addShadow(button: thirdViewBtn)
        self.addShadow(button: commentsBtn)
        self.relation =  (AVUser.current()?.relation(forKey: "userCart"))!
        self.commentsTableView.allowsSelection = true
        
        self.commentsTableView.estimatedRowHeight = 70
        self.commentsTableView.rowHeight = UITableViewAutomaticDimension
        self.progressBar.isHidden = true

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateCount(relation: self.relation)

    }

    
    func checkIfItemIsInCart()
    {
    
        
        let query: AVQuery = self.relation.query()
        query.whereKey("objectId", equalTo: self.productBO.objectId!)
        query.getFirstObjectInBackground { (object, error) in
            self.progressBar.isHidden = true

            if(error == nil)
            {
              if(object != nil)
                {
                //item in the cart assetes update required
                   // self.removeFromCartAction()
                    self.isFoundIncart = true

                    self.cartBtn.isHidden = false
                }
                else
                {
                    self.isFoundIncart = false
                //not in the cart assets update required
                    //self.addToCartAction()
                    self.cartBtn.isHidden = true

                }
            }
            else
            {
               
                self.isFoundIncart = false

                //self.addToCartAction()
                self.cartBtn.isHidden = true

                //show error mesage
            }
        }
        
    }
    func removeFromCartAction()
    {
        messageForCart = " removed from cart."
    
       relation.remove(self.productBO as AVObject)
    }
    
    func addToCartAction()
    {
        messageForCart = " added to cart."

       relation.add(self.productBO as AVObject)

    }
    override func viewDidAppear(_ animated: Bool) {
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        horizontalScrolView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: horizontalScrolView.frame.size.height)
        
        
            self.showDescriptionView(sender: "" as AnyObject)
        
    }
    func updateProductDetails()
    {
        
        if let profileImage = self.productBO.user.value(forKey: "profileImage")
        {
        let parseFile = profileImage as! AVFile
            parseFile.getDataInBackground({ (data, error) in
                self.userImage.image = UIImage.init(data: data!)
                 self.userImage.layer.cornerRadius =  self.userImage.frame.size.width/2
                 self.userImage.clipsToBounds = true
            })
            print("file exists");
        }
        favoriteBtn.isSelected = productBO.favorite
        likesLabel.text = "\(productBO.productLikes)"
        productNameLabel.text = productBO.brand
        userNameLabel.text = "@" + (AVUser.current()?.username!)!


									self.produceAttributedText(string: "\(productBO.name) \nSize \(productBO.size) \nEst. Retail ¥ \(productBO.priceRetail)", textView:  priceSizeNameTextView)

		
					
					var textFieldText = "¥ \(productBO.sellingPrice)"
					let attributedString = NSMutableAttributedString(string: textFieldText)
					attributedString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, textFieldText.characters.count))
					
					sellingPriceLabel.attributedText = attributedString

          var sdWebImageSource = [InputSource]()
        for url in self.productBO.productImagesArray
        {
        sdWebImageSource.append(SDWebImageSource(urlString: url.absoluteString)!)
        }
    
        if  Date().days(from: self.productBO.updatedAtValue) > 0
        
        {
            daysAgoLabel.text =   "Updated \(Date().days(from:  self.productBO.updatedAtValue))d ago"

        }
        else
        {
            daysAgoLabel.isHidden = false
        }
        slideshow.slideshowInterval = 5.0
       // slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleToFill
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // try out other sources such as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(sdWebImageSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
					
					
    }
	func produceAttributedText(string: String, textView : UITextView)
	{
		
		let attributedString = NSMutableAttributedString(string:string)
		attributedString.addAttribute(NSFontAttributeName , value: UIFont(name: "Avenir", size: CGFloat(10))!,range: NSMakeRange(0, attributedString.length))
		
		let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 0.55
		paragraphStyle.maximumLineHeight = 11 // change line spacing between each line like 30 or 40

		paragraphStyle.alignment = NSTextAlignment.left
		
		attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 182.0/255.0, green: 182.0/255.0, blue: 182.0/255.0, alpha: 1.0), range: NSMakeRange(0, attributedString.length))
		
		attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
		textView.attributedText=attributedString
		
	}
    func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    
    
    func addShadow(button : UIButton)
    {
              
        
       // let shadowPath = UIBezierPath(rect: button.bounds).cgPath
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset =  CGSize(width: 0, height: 4)

        button.layer.shadowOpacity = 0.2
        //button.layer.masksToBounds = false
       // button.layer.shadowPath = shadowPath
        button.layer.cornerRadius = 0.5
        
    }
   
    
    func loadComments()
    {
        
        self.productBO.queryObj.includeKey("user")

       self.productBO.queryObj.findObjectsInBackground { (objects, error) in
            
            if(error == nil)
            {
                for obj in objects!
                {
                let commentBO:Comments = obj as! Comments
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

    func postComment(index : Int)
    {
        let indexPath = IndexPath(row: 0, section: 0)

        let cell: PostCommentsCustomCell = self.commentsTableView.cellForRow(at: indexPath) as! PostCommentsCustomCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;

        let comment = Comments()
        comment.setObject(AVUser.current()!, forKey: "user")
        comment.setObject(cell.inputTextField.text, forKey: "comment")
        comment.saveInBackground  { (objects, error) in
            let commentRelation =  self.productBO.relation(forKey: "comments")
            commentRelation.add(comment)
            
            self.productBO.saveInBackground { (objects, error) in
                
                if(error == nil)
                {
                    cell.inputTextField.text  = ""
                    self.loadComments()
                }
                else
                {
                    //show error mesage
                }
            }
            

        }
        
        }
 
    @IBAction func addToCart(sender : AnyObject)
    {
        if(isFoundIncart)
        {
        self.removeFromCartAction()
        }
        else
        {
            self.addToCartAction()
        }
        self.addToCartAction(message: messageForCart)
    }
    
    func updateCount(relation : AVRelation)
    {
        progressBar.isHidden = false
        relation.query().countObjectsInBackground{(objects, error) in
            
            if(error == nil)
            {
                print (objects)
                if( objects > 0 )
                {
                //self.cartCountLabel.text = "\(objects)"
                    self.allCartBtn.isHidden = false
                    self.allCartBtn.setTitle("\(objects)", for: .normal)
                }
                else
                {
                    self.allCartBtn.isHidden = true
                }
                self.checkIfItemIsInCart()
            }
            else
            {
                //show error mesage
            }
        }
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.descriptonView.frame = CGRect(x: 0, y: self.descriptonView.frame.origin.y, width:UIScreen.main.bounds.width    , height: self.descriptonView.frame.height )
        
        self.commentsView.frame = CGRect(x: UIScreen.main.bounds.width, y: self.descriptonView.frame.origin.y, width:UIScreen.main.bounds.width    , height: self.commentsView.frame.height )
        
        self.commentsTableView.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width    , height: self.commentsView.frame.height )
        
      

        self.policyView.frame = CGRect(x: UIScreen.main.bounds.width * 2, y: self.policyView.frame.origin.y, width:UIScreen.main.bounds.width  , height: self.policyView.frame.height )
        
          self.policyTextView.frame = CGRect(x: 20, y: 0, width:UIScreen.main.bounds.width - 40    , height: self.policyTextView.frame.height )
        
    
      
        
        
       
    }
    
    
    @IBAction func backBtnAction(sender : AnyObject)
    {
    self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showDescriptionView(sender : AnyObject)
    {

        self.horizontalScrolView.setContentOffset(CGPoint(x: 0,y : 0 ), animated: true)
        commentsBtn.isHidden = true
        productDescriptionBtn.isHidden = false
        thirdViewBtn.isHidden = true
        
        policyView.isHidden = true;
					 descriptonView.isHidden = false;
        commentsView.isHidden = true;
    self.view.bringSubview(toFront: productDescriptionBtnView)
        descriptonTextView.text = self.productBO.prodcut_description
					
					self.produceAttributedText(string: "Color: \(productBO.color) \nMaterial: \(productBO.size) \nCondition: \(productBO.condition)", textView: colorMaterialTextView)

    }
    
    @IBAction func showCommentsView(sender : AnyObject)
    {
        self.horizontalScrolView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y : 0 ), animated: true)

        commentsBtn.isHidden = false
        productDescriptionBtn.isHidden = true
        thirdViewBtn.isHidden = true
        self.view.bringSubview(toFront: commentsBtnView)

        
        descriptonView.isHidden = true;
        commentsView.isHidden = false;
        policyView.isHidden = true;

        self.loadComments()
    }
    @IBAction func showPolicyView(sender : AnyObject)
    {
        self.view.bringSubview(toFront: thirdViewBtnView)

        self.horizontalScrolView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width*2,  y : 0 ), animated: true)
        commentsBtn.isHidden = true
        productDescriptionBtn.isHidden = true
        thirdViewBtn.isHidden = false
        self.view.layoutIfNeeded()

        descriptonView.isHidden = true;
        commentsView.isHidden = true;
        policyView.isHidden = false;
      
    }
    func updateConstraints()
    {
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    func addToCartAction(message: String)
    {
       
        
        AVUser.current()?.saveInBackground { (objects, error) in
            
            if(error == nil)
            {
                self.updateCount(relation: self.relation)
                Constants.showAlert(message: self.productBO.name + message,view: self)
            }
            else
            {
            //show error mesage
            }
        }
        

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)

        if(scrollView == self.horizontalScrolView)
        {
        if(scrollView.contentOffset.x == 0)
        {
            self.showDescriptionView(sender: UIButton())
        }
        else if (scrollView.contentOffset.x ==  UIScreen.main.bounds.width)
        {
            self.showCommentsView(sender: UIButton())
        }
        else if (scrollView.contentOffset.x ==  UIScreen.main.bounds.width*2)
        {
            self.showPolicyView(sender: UIButton())
        }
        }
        else if(scrollView.contentOffset.y < (self.scrollView.contentSize.height - self.scrollView.bounds.size.height)/2)
        {
     //       scrollBtn.isHidden = false;

        }
        else
        {
       //     scrollBtn.isHidden = true;

        }
//        if(scrollView.contentOffset.y >= 50)
//        {
//        constraintForViewHeight.constant = constraintForViewHeight.constant  - 1        }
//      else
//        {
//            constraintForViewHeight.constant = constraintForViewHeight.constant  + 1
//
//        }
    }
    
    @IBAction func moveToScrollBottom()
    {
        scrollBtn.isHidden = true;
        self.scrollView.setContentOffset(CGPoint(x: 0, y :  self.scrollView.contentSize.height - self.scrollView.bounds.size.height), animated: true)

    }
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArray.count  + 1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == 0)
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentsCustomCell", for: indexPath ) as! PostCommentsCustomCell

            cell.delegate = self;
            cell.postBtn.tag  = indexPath.row
        return cell
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCustomCell", for: indexPath ) as! CommentsCustomCell
        let commentBO =  self.commentsArray[indexPath.row - 1]

        
        
        // connect objects with our information from arrays
        cell.nameLabel.text = commentBO.user.username
        cell.commentsTextView.text = commentBO.comment
             return cell
        }
    }
}

