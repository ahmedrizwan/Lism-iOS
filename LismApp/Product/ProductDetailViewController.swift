
import Foundation
import UIKit
import AVOSCloud
extension Date {
 
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
	func hour(from date: Date) -> Int {
		return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
	}
	func minute(from date: Date) -> Int {
		return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
	}
	func seconds(from date: Date) -> Int {
		return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
	}
}
class ProductDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var scrollView : UIScrollView!
    var productBO : Product!
    var commentsArray : [Comments] = []
    @IBOutlet weak var progressBar : UIActivityIndicatorView!
	   @IBOutlet weak var heightConstraint : NSLayoutConstraint!
	@IBOutlet weak var heightConstraintForInnerView : NSLayoutConstraint!
	@IBOutlet weak var heightConstraintForSeller : NSLayoutConstraint!
	@IBOutlet weak var heightConstraintForLike : NSLayoutConstraint!

	var selectedPorudct : Product!
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
	@IBOutlet weak var descriptionLabel : UILabel!

    @IBOutlet weak var commentsBtn : UIButton!
    @IBOutlet weak var productDescriptionBtn : UIButton!
    @IBOutlet weak var thirdViewBtn : UIButton!

    @IBOutlet weak var commentsBtnView : UIView!
    @IBOutlet weak var productDescriptionBtnView : UIView!
    @IBOutlet weak var thirdViewBtnView : UIView!
	@IBOutlet weak var checkoutBtnsView : UIView!

    @IBOutlet var constraintForViewidth : NSLayoutConstraint!
	var favoritesList : [Product] = []
	var items : [Product] = []

	var moreByThisSellerItems : [Product] = []

	@IBOutlet weak var  youMayLikeColectionView : UICollectionView!
	@IBOutlet weak var moreBySellerCollectionView : UICollectionView!
	@IBOutlet weak var noLikedLabel : UILabel!
	@IBOutlet weak var noMoreSellerLabel : UILabel!

	
	@IBOutlet weak var youMayAlsoLikeLabel : UILabel!
	@IBOutlet weak var sellerLabel : UILabel!
	
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
	let PLACEHOLDER_TEXT = "write comment to post".localized(using: "Main")

    override func viewDidLoad() {
     //   let backImg: UIImage = (UIImage(named: "back_btn")
       self.navigationController?.navigationBar.isHidden = true
        self.updateProductDetails()
        self.cartBtn.isHidden = true

        scrollView.delegate = self
        Constants.addShadow(button: productDescriptionBtn)
        Constants.addShadow(button: thirdViewBtn)
        Constants.addShadow(button: commentsBtn)
        self.commentsTableView.allowsSelection = true
        
        self.commentsTableView.estimatedRowHeight = 70
        self.commentsTableView.rowHeight = UITableViewAutomaticDimension
        self.progressBar.isHidden = true
					descriptionLabel.text = "Description".localized(using: "Main")
					self.getProductListByThisSeller()
					self.getProductYouMayLike()
					self.hideKeyboardWhenTappedAround()
    }
	
    
    override func viewWillAppear(_ animated: Bool) {
					self.relation =  (AVUser.current()!.relation(forKey: "userCart"))

        self.updateCount(relation: self.relation)
					heightConstraint.constant = 788
					heightConstraintForInnerView.constant  = 788
					
					noLikedLabel.text = "No Items Found...".localized(using: "Main")
					noMoreSellerLabel.text = "No Items Found...".localized(using: "Main")
					sellerLabel.text = "From The Same Seller".localized(using: "Main")
					youMayAlsoLikeLabel.text = "You May Also Like".localized(using: "Main")

    }

	
    func checkIfItemIsInCart()
    {
    
        
        let query: AVQuery = (AVUser.current()!.relation(forKey: "userCart")).query()
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
        messageForCart = (" removed from cart.").localized(using: "Main")
    
       (AVUser.current()!.relation(forKey: "userCart")).remove(self.productBO!)
					self.addToCartAction(message: messageForCart)

    }
	
    func addToCartAction()
    {
					messageForCart = (" added to cart.").localized(using: "Main")

       (AVUser.current()!.relation(forKey: "userCart")).add(self.productBO! )
					self.addToCartAction(message: messageForCart)


    }
    override func viewDidAppear(_ animated: Bool) {
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1300)
        horizontalScrolView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: horizontalScrolView.frame.size.height + 60)
					
        
            self.showDescriptionView(sender: "" as AnyObject)
        
    }
    func updateProductDetails()
    {
        if(self.productBO.user.value(forKey: "profileImage") != nil)
								{
        if let profileImage = self.productBO.user.value(forKey: "profileImage")
        {
        let parseFile = profileImage as! AVFile
            parseFile.getDataInBackground({ (data, error) in
													if(data != nil)
													{
                self.userImage.image = UIImage.init(data: data!)
                 self.userImage.layer.cornerRadius =  self.userImage.frame.size.width/2
                 self.userImage.clipsToBounds = true
													}
													})
            print("file exists");
        }
					}
        favoriteBtn.isSelected = productBO.favorite
        likesLabel.text = "\(productBO.productLikes)"
        productNameLabel.text = productBO.brand
					if(productBO.user.username != nil)
					{
        userNameLabel.text = "@" + (productBO.user.username!)
					}

									self.produceAttributedText(string: "\(productBO.name) \n\("Size".localized(using: "Main")) \(productBO.size) \n\("Est. Retail ¥".localized(using: "Main")) \(productBO.priceRetail)", textView:  priceSizeNameTextView)

					
					if(productBO.status == Constants.sent || productBO.status == Constants.waiting_to_be_sent) || AVUser.current()!.username! == self.productBO.user!.username!

					{
						checkoutBtnsView.isHidden = true
					}
					
					var textFieldText = "¥ \(productBO.sellingPrice)"
					let attributedString = NSMutableAttributedString(string: textFieldText)
					attributedString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, textFieldText.characters.count))
					
					sellingPriceLabel.attributedText = attributedString

					let updatedValue = "Updated".localized(using: "Main")
          var sdWebImageSource = [InputSource]()
					
					  if(self.productBO.productImageUrl != nil && self.productBO.productImagesArray.count <= 0)
							{
					
								sdWebImageSource.append(SDWebImageSource(urlString: self.productBO.productImageUrl.absoluteString)!)
					  }
					for url in self.productBO.productImagesArray
					{
						sdWebImageSource.append(SDWebImageSource(urlString: url.absoluteString)!)
					}
					sdWebImageSource = sdWebImageSource.reversed()
        if  Date().days(from: self.productBO.updatedAt!) > 0
        
        {
            daysAgoLabel.text =   "\(updatedValue) \(Date().days(from:  self.productBO.updatedAt!)) \("d ago".localized(using: "Main"))"

        }
        else if  Date().hour(from: self.productBO.updatedAt!) > 0
        {
           // daysAgoLabel.isHidden = false
									
									
       daysAgoLabel.text =   "\(updatedValue) \(Date().hour(from:  self.productBO.updatedAt!)) \("hour ago".localized(using: "Main"))"
					}
else if  Date().minute(from: self.productBO.updatedAt!) > 0
        {
									// daysAgoLabel.isHidden = false
									daysAgoLabel.text =   "\(updatedValue) \(Date().minute(from:  self.productBO.updatedAt!)) \("minute ago".localized(using: "Main"))"
					}
					
					else if  Date().seconds(from: self.productBO.updatedAt!) > 0
					{
						// daysAgoLabel.isHidden = false
						daysAgoLabel.text =   "\(updatedValue) \(Date().seconds(from:  self.productBO.updatedAt!)) \("second ago".localized(using: "Main"))"
					}
        slideshow.slideshowInterval = 0.0
       // slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
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
    
    
	@IBAction func addtoFavoriteBtnAction(sender  : AnyObject)
				{
					self.productBO.favorite = !self.productBO.favorite
					//let btn = sender as! UIButton
					favoriteBtn.isSelected = 	self.productBO.favorite
					if(self.productBO.favorite )
					{
						 self.productBO.productLikes = self.productBO.productLikes + 1
						self.productBO.setObject(self.productBO.productLikes, forKey: "productLikes")
						AVUser.current()?.relation(forKey: "favorites").add(self.productBO)
						self.likesLabel.text = "\(self.productBO.productLikes)"

					}
					else
					{
						if((self.productBO.productLikes - 1) >= 0 )
						{
							self.productBO.productLikes  = self.productBO.productLikes - 1
						self.productBO.setObject(self.productBO.productLikes , forKey: "productLikes")
							self.likesLabel.text = "\(self.productBO.productLikes)"

						}
						AVUser.current()?.relation(forKey: "favorites").remove(self.productBO)
						
					}
					self.productBO.saveInBackground()
					AVUser.current()?.saveInBackground { (status, error) in
					}

	
	}
	
	
    func loadComments()
    {
					
        self.productBO.queryObj.includeKey("user")
					self.commentsArray.removeAll()
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

					self.progressBar.startAnimating()
					self.progressBar.isHidden  = false
					
        let cell: PostCommentsCustomCell = self.commentsTableView.cellForRow(at: indexPath) as! PostCommentsCustomCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
					var avobjectsArray : [AVObject] = []
        let comment = Comments()
        comment.setObject(AVUser.current()!, forKey: "user")
        comment.setObject(cell.inputTextField.text, forKey: "comment")
					
									let notificationLog = 							Constants.getProductNotification(product: self.productBO, type: Constants.NotificationType.TYPE_COMMENT)
					
										avobjectsArray.append(comment)
									avobjectsArray.append(notificationLog)

            AVObject.saveAll(inBackground: avobjectsArray, block: { (objects, error) in
													self.progressBar.stopAnimating()
													self.progressBar.isHidden  = true
                if(error == nil)
                {
																	let commentRelation =  self.productBO.relation(forKey: "comments")
																	commentRelation.add(comment)
																	self.productBO.saveInBackground({ (status, error) in
																		if(error == nil)
																		{

																			AVPush.unsubscribeFromChannel(inBackground: self.productBO.objectId!, block: { (status, error) in
																				if(error == nil)
																				{
																					
																					Constants.sendPushToChannel(vc: self, channelInfo: self.productBO.objectId!, message: "\(AVUser.current()!.username!) commented on \(self.productBO.name)", content: "")
																				}
																			})
																			let delayInSeconds = 3.0
																			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
																				AVPush.subscribeToChannel(inBackground: self.productBO.objectId!)
																				// here code perfomed with delay
																				
																			}

                    cell.inputTextField.text  = ""
                    self.loadComments()
																		}
																		})
																		
                }
                else
                {
                    //show error mesage
                }
													
									})
			
					
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
    }
    
    func updateCount(relation : AVRelation)
    {
        progressBar.isHidden = false
        (AVUser.current()!.relation(forKey: "userCart")).query().countObjectsInBackground{(objects, error) in
            
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

					
        self.descriptonView.frame = CGRect(x: 0, y: self.descriptonView.frame.origin.y, width:UIScreen.main.bounds.width    , height: heightConstraintForInnerView.constant )
        
        self.commentsView.frame = CGRect(x: UIScreen.main.bounds.width, y: self.descriptonView.frame.origin.y, width:UIScreen.main.bounds.width    , height: heightConstraintForInnerView.constant )
        
        self.commentsTableView.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width    , height: self.commentsView.frame.height)
        
      

        self.policyView.frame = CGRect(x: UIScreen.main.bounds.width * 2, y: self.policyView.frame.origin.y, width:UIScreen.main.bounds.width  , height: heightConstraintForInnerView.constant  )
        
          self.policyTextView.frame = CGRect(x: 20, y: 0, width:UIScreen.main.bounds.width - 40    , height: self.policyView.frame.height)
        
    
      
        
        
       
    }
    
    
    @IBAction func backBtnAction(sender : AnyObject)
    {
					_ = navigationController?.popViewController(animated: true)
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
					
					self.produceAttributedText(string: "\("Color:".localized(using: "Main")) \(productBO.color) \n\("Material:".localized(using: "Main")) \(productBO.size) \n\("Condition:".localized(using: "Main")) \(productBO.condition)", textView: colorMaterialTextView)
					if(productBO.status == Constants.sent || productBO.status == Constants.waiting_to_be_sent || AVUser.current()!.username! == self.productBO.user!.username!)
			{
					self.checkoutBtnsView.isHidden = true;
					}
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
					
					self.checkoutBtnsView.isHidden = true;
					
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
				
					self.checkoutBtnsView.isHidden = true;
					
					
    }
	
	
	
	// MARK: - UICollectionViewDataSource protocol
	
	
	func getProductYouMayLike()
	{
		
		
		
		self.view.isUserInteractionEnabled = false
		let query: AVQuery = AVQuery(className: "Product")
  query.includeKey("images")
		query.includeKey("user")
		query.includeKey("userLikes")
		query.includeKey("buyingUser")
		query.whereKey("category", equalTo: self.productBO.category)
		query.whereKey("objectId", notEqualTo: self.productBO.objectId!)
	 query.limit = 2
		
		self.progressBar.isHidden = false
		query.findObjectsInBackground { (objects, error) in
			self.progressBar.isHidden = true
			self.view.isUserInteractionEnabled = true
			if(error == nil)
			{
				self.items.removeAll()
				for obj in objects!
				{
					let productObj:Product =  obj as! Product
					
					
					productObj.ProductInintWithDic(dict: obj as! AVObject)
					self.items.append(productObj)
				}
				if(self.items.count <= 0)
				{
						self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.scrollView.contentSize.height - 	self.heightConstraintForLike.constant)
					self.heightConstraintForLike.constant = 20

					self.noLikedLabel.isHidden = false
				}
				else
				{
					self.loadFavoritesList(listToUpdate: self.items , viewToLoad : self.youMayLikeColectionView)
				}
			}
			else
			{
				Constants.showAlert(message: "Unable to load products.".localized(using: "Main"), view: self)
				
			}
			
			
		}
		
		
	}
	
	func getProductListByThisSeller()
	{
		
		
		
		self.view.isUserInteractionEnabled = false
		let query: AVQuery = AVQuery(className: "Product")
  query.includeKey("images")
		query.includeKey("user")
		query.includeKey("userLikes")
		query.includeKey("buyingUser")
		query.whereKey("user", equalTo: self.productBO.user)
		query.whereKey("objectId", notEqualTo: self.productBO.objectId!)

	 query.limit = 2
		self.progressBar.isHidden = false
		query.findObjectsInBackground { (objects, error) in
			self.progressBar.isHidden = true
			self.view.isUserInteractionEnabled = true
			if(error == nil)
			{
				self.moreByThisSellerItems.removeAll()
				for obj in objects!
				{
					let productObj:Product =  obj as! Product
					
					
					productObj.ProductInintWithDic(dict: obj as! AVObject)
					self.moreByThisSellerItems.append(productObj)
				}
				if(self.moreByThisSellerItems.count <= 0)
				{
					self.noMoreSellerLabel.isHidden = false
					self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.scrollView.contentSize.height - 	self.heightConstraintForSeller.constant)
					self.heightConstraintForSeller.constant = 20

				}
				else
				{
				self.loadFavoritesList(listToUpdate: self.moreByThisSellerItems , viewToLoad : self.moreBySellerCollectionView)
				}
			}
			else
			{
				Constants.showAlert(message: "Unable to load products.".localized(using: "Main"), view: self)
				
			}
			
			
		}
		
		
	}
	
	func loadFavoritesList(listToUpdate : [Product],viewToLoad : UICollectionView)
	{
		self.favoritesList =   Constants.favoritesList
		self.comapreToUpdateFavoriteProductsList(listToUpdate : listToUpdate , viewToLoad  : viewToLoad)

			}
	
	func comapreToUpdateFavoriteProductsList(listToUpdate : [Product],viewToLoad : UICollectionView)

	{
		for productObj in listToUpdate
		{
			for objFavorite in self.favoritesList
			{
				if(productObj.objectId == objFavorite.objectId)
				{
					productObj.favorite = true
				}
			}
			
		}
		viewToLoad.reloadData()
	}
	
	// tell the collection view how many cells to make
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if(collectionView == youMayLikeColectionView)
		{
		return self.items.count
		}
		else
		{
		return self.moreByThisSellerItems.count
		}
	}
	
	// make a cell for each cell index path
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// get a reference to our storyboard cell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "prodcutsCustomCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
		var productObj  = Product()
		if(collectionView == youMayLikeColectionView)
		{
		 productObj = self.items[indexPath.item]
		}
		else
		{
			productObj = self.moreByThisSellerItems[indexPath.item]

		}
			// Use the outlet in our custom class to get a reference to the UILabel in the cell
		cell.nameLabel.text = productObj.brand.uppercased()
		
		if(productObj.productImageUrl != nil)
		{
			cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
		}
		cell.priceLabel.text = "¥\(productObj.sellingPrice)" ;
		
		if(productObj.status == Constants.sent || productObj.status == Constants.waiting_to_be_sent)
		{
			cell.soldBannerImageView.isHidden = false
		}
		else
		{
			cell.soldBannerImageView.isHidden = true
			
		}
		
		//cell.retailPriceTextView.text = "Size\(productObj.size) \n  Est. Retail ¥ \(productObj.priceRetail)"
		
		if(productObj.size != "")
		{
			Constants.produceAttributedText(string: "\("Size".localized(using: "Main")) \(productObj.size) \n  \("Est. Retail¥".localized(using: "Main")) \(productObj.priceRetail)", textView: cell.retailPriceTextView)
		}
		else
		{
			Constants.produceAttributedText(string: "\("Est. Retail¥".localized(using: "Main")) \(productObj.priceRetail)", textView: cell.retailPriceTextView)
		}
		
		cell.likeButton.isSelected = productObj.favorite
		cell.likeButton.tag = indexPath.row
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: collectionView.bounds.width/2 - 20 , height: collectionView.bounds.width/2 + 60)
		
	}

    func updateConstraints()
    {
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    func addToCartAction(message: String)
    {
					
        AVUser.current()!.saveInBackground { (objects, error) in
									
            if(error == nil)
            {
                self.updateCount(relation: (AVUser.current()!.relation(forKey: "userCart")))
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
									 cell.postBtn.setTitle("POST COMMENT".localized(using: "Main"), for: .application)
									cell.inputTextField.delegate = self
										cell.inputTextField.layer.borderWidth = 1.0
										cell.inputTextField.layer.borderColor = UIColor.lightGray.cgColor
									if(cell.inputTextField.text.characters.count == 0)
									{
									applyPlaceholderStyle(aTextview: cell.inputTextField, placeholderText: PLACEHOLDER_TEXT.localized(using: "Main"))
									}

        return cell
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCustomCell", for: indexPath ) as! CommentsCustomCell
        let commentBO =  self.commentsArray[indexPath.row - 1]

        
        
        // connect objects with our information from arrays
        cell.nameLabel.text = "@\(commentBO.user.username!)"
        cell.commentsTextView.text = commentBO.comment
             return cell
        }
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
		if aTextView.text == PLACEHOLDER_TEXT
		{
			// move cursor to start
			//moveCursorToStart(aTextView: aTextView)
			aTextView.text = ""
		}
		return true
	}
	func moveCursorToStart(aTextView: UITextView)
	{
		aTextView.text = ""
		aTextView.selectedRange = NSMakeRange(0, 0);
		
	}
	func textViewDidChangeSelection(_ textView: UITextView) {
		
	}
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		
		let newLength = textView.text.utf16.count + text.utf16.count - range.length
		if newLength > 0 // have text, so don't show the placeholder
		{
			// check if the only text is the placeholder and remove it if needed
			// unless they've hit the delete button with the placeholder displayed
			if textView.text == PLACEHOLDER_TEXT
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
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// handle tap events
		//print("You selected cell #\(indexPath.item)!")
		if(collectionView == moreBySellerCollectionView)
		{
		selectedPorudct = moreByThisSellerItems [indexPath.item]
		}
		else
		{
			selectedPorudct = items [indexPath.item]
	
		}
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
		vc.productBO = selectedPorudct
		self.navigationController!.pushViewController(vc, animated: true)

	//	self.performSegue(withIdentifier: "ThisProductDetailsVC", sender: self)
		
	}
	
	//
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "ProductUserToProfileViewController") {
			let viewController:ProfileViewController = segue.destination as! ProfileViewController
			viewController.userObj = self.productBO.user
			// pass data to next view
		}
		else   if (segue.identifier == "ThisProductDetailsVC") {
			let viewController:ProductDetailViewController = segue.destination as! ProductDetailViewController
			viewController.productBO = selectedPorudct
			// pass data to next view
		}

	}
	


}



