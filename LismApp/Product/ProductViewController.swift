
import UIKit
import AVOSCloud
extension UIImageView {
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
    }
}
class ProductViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate,UICollectionViewDelegateFlowLayout{
    static let ITEM_LIMIT = 10
    
    var items : [Product] = []

    var favoritesList : [Product] = []
    var selectedIndex : Int!
    var isShowing = false
    var isHiding = false

    
    var isShowingTopbar = false
    var isHidingTopbar = false
    @IBOutlet weak var totalItemsLabel : UILabel!
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
     @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!

    @IBOutlet weak var productsCollectionView : UICollectionView!
    var lastScrollPos : CGPoint!
    var  refresher = UIRefreshControl()
    var isLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //  self.navigationController?.isNavigationBarHidden = true
        
        AVPush.subscribeToChannel(inBackground: AVUser.current()!.objectId!)
       // AVInstallation.current().setValue(AVUser.current()?.objectId, forKey: "channels")

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo")
        imageView.image = image
        self.navigationController?.navigationBar.backItem?.title = ""
        
        navigationItem.titleView = imageView
        self.navigationController?.navigationBar.isHidden = true
        
        self.productsCollectionView!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(getProductList), for: .valueChanged)
        self.productsCollectionView!.addSubview(refresher)
        self.addShadowToView()
        self.automaticallyAdjustsScrollViewInsets = false
        tabBar.selectedItem = selectedTabBarItem
        self.getProductList()

    }
    override func viewWillAppear(_ animated: Bool) {
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if( self.isLoaded)
        {
        self.progressView.isHidden = true
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addShadowToView()
    {
        topView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        topView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        topView.layer.shadowOpacity = 1.0
        topView.layer.shadowRadius = 0.0
        topView.layer.masksToBounds = false
        topView.layer.cornerRadius = 4.0
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       // print("Selected item",item.tag)
        
        if(item.tag == 1)
        {
            //load new view
            self.performSegue(withIdentifier: "ProductToSellView", sender: self)
        }
        
      else  if(item.tag == 2)
        {
            //load new view
            self.performSegue(withIdentifier: "ProductToProfileView", sender: self)
        }
        
        
        //This method will be called when user changes tab.
    }
    
  
    func getProductList()
    {
        
        
        
        let query: AVQuery = AVQuery(className: "Product")
        query.includeKey("images")
        query.includeKey("user")
        query.includeKey("userLikes")
        query.includeKey("buyingUser")

        query.limit = ProductViewController.ITEM_LIMIT
        self.progressView.isHidden = false
        DispatchQueue.global(qos: .background).async {

        query.findObjectsInBackground { (objects, error) in
            self.refresher.endRefreshing()
            if(error == nil)
            {
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    
                    
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.items.append(productObj)
                }
                
                self.loadFavoritesList()
            }
            else
            {
            Constants.showAlert(message: "Unable to load products.", view: self)
            }
            
        }
        }
            
    }
    
    func loadFavoritesList()
    {
        
        
        
        let query: AVQuery = (AVUser.current()?.relation(forKey: "favorites").query())!
        query.includeKey("user")
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                self.isLoaded = true
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.favoritesList.append(productObj)
                }
                Constants.favoritesList = self.favoritesList
                self.comapreToUpdateFavoriteProductsList()
            }
            else
            {
                Constants.showAlert(message: "Unable to load products.", view: self)

            }
            self.progressView.isHidden = true

            
        }
        
        
    }
    func comapreToUpdateFavoriteProductsList()
    {
        for productObj in self.items
        {
            for objFavorite in self.favoritesList
            {
                if(productObj.objectId == objFavorite.objectId)
                {
                    productObj.favorite = true
                }
            }
            
        }
        DispatchQueue.main.async {

        self.productsCollectionView.reloadData()
        }
    }
    func getMoreProductList(size: Int)
    {
        
       
    
                let query: AVQuery = AVQuery(className: "Product")
                query.includeKey("images")
                query.includeKey("user")
                query.includeKey("userLikes")
                query.limit = ProductViewController.ITEM_LIMIT
                query.skip = size
                query.findObjectsInBackground { (objects, error) in
                    if(error == nil)
                    {
                        for obj in objects!
                        {
                            let productObj:Product =  obj as! Product
                            productObj.ProductInintWithDic(dict: obj as! AVObject)
                            self.items.append(productObj)
                        }
                        DispatchQueue.main.async(execute: {
                            self.comapreToUpdateFavoriteProductsList()

                        })
                    }
                    
                }
                
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "prodcutsCustomCell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        let productObj = self.items[indexPath.item]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.nameLabel.text = productObj.brand
        if(productObj.productImageUrl != nil)
        {
            cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }
        cell.priceLabel.text = "¥ \(productObj.sellingPrice)" ;

        if(productObj.status == Constants.sent || productObj.status == Constants.waiting_to_be_sent)
        {
            cell.soldBannerImageView.isHidden = false
        }
        else
        {
            cell.soldBannerImageView.isHidden = true

        }
        
        //cell.retailPriceTextView.text = "Size\(productObj.size) \n  Est. Retail ¥ \(productObj.priceRetail)"
        
        Constants.produceAttributedText(string: "Size\(productObj.size) \n  Est. Retail ¥ \(productObj.priceRetail)", textView: cell.retailPriceTextView)
        if (indexPath.row + 1 == self.items.count )
        {
            self.getMoreProductList(size: self.items.count)
        }
        cell.likeButton.isSelected = productObj.favorite
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/2 - 20, height: collectionView.bounds.height/2)
        
    }
    // MARK: - UICollectionViewDelegate protocol
    @IBAction func filterBtnAction(sender: AnyObject)
    {
        
        
    }
    @IBAction func listBtnAction(sender: AnyObject)
    {
        
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastScrollPos =  self.productsCollectionView.contentOffset
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
        
        let scrollPos = self.productsCollectionView.contentOffset.y ;

        if(scrollPos > lastScrollPos.y  ){
            if(!self.isHiding)
            {
                 isHiding = true
            UIView.animate(withDuration:0.35, animations: {
                //
                //write a code to hide
                self.productsCollectionView.frame = CGRect(x: self.productsCollectionView.frame.origin.x, y: 60, width:  self.productsCollectionView.frame.size.width, height:  self.productsCollectionView.frame.size.height)
            }, completion: { _ in
                self.isHiding = false
              //  print("hiding collection")
                //print(self.productsCollectionView.frame.origin.y )

                // completion
                })
            }
        }
        else if (scrollPos <= 60)
        {
            
            if(!self.isShowing)
            {
              //  print("showing collection")

                self.isShowing = true
            UIView.animate(withDuration: 0.35, animations: {
                //
                
                //write a code to hide
                self.productsCollectionView.frame = CGRect(x: self.productsCollectionView.frame.origin.x, y: 105, width:  self.productsCollectionView.frame.size.width, height:  self.productsCollectionView.frame.size.height)
            },  completion: { _ in
                self.isShowing = false
                // completion
                })
            }
        }
        
        
        if(scrollPos  > lastScrollPos.y  + 10 && isHiding ){
            //Fully hide your toolbar
            if(!self.isHidingTopbar )
            {
                print("hiding toolbar")

                self.isHidingTopbar = true
            UIView.animate(withDuration: 0.75, animations: {
                //
                //write a code to hide
                self.topView.frame = CGRect(x: self.topView.frame.origin.x, y: 0, width:  self.topView.frame.size.width, height:  self.topView.frame.size.height)
                
            },  completion: { _ in
                self.isHidingTopbar = false
                // completion
                })
            }
        } else  if(scrollPos <=  lastScrollPos.y )
        {
            //Slide it up incrementally, etc.
            if(!self.isShowingTopbar)
            {
               // print("showding toolbar")

                self.isShowingTopbar = true

            UIView.animate(withDuration: 0.75, animations: {
                //
                self.topView.frame = CGRect(x: self.topView.frame.origin.x, y: 65, width:  self.topView.frame.size.width, height:  self.topView.frame.size.height)
            }, completion: { _ in
                self.isShowingTopbar = false
                // completion
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        //print("You selected cell #\(indexPath.item)!")
        selectedIndex = indexPath.item
        self.performSegue(withIdentifier: "ProductViewToProductDetailsVC", sender: self)
        
    }
    
    @IBAction func minusBtnClickedAction (sender : UIButton)
    {
        sender.imageView?.tintImageColor(color: UIColor.red)
        
        
    }
    
    @IBAction func profileBtnClickedAction (sender : UIButton)
    {
        
    }
    
    @IBAction func heartBtnClickedAction (sender : UIButton)
    {
        
    }
    
    @IBAction func plusBtnClickedAction (sender : UIButton)
    {
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ProductViewToProductDetailsVC") {
            let viewController:ProductDetailViewController = segue.destination as! ProductDetailViewController
            viewController.productBO = items[selectedIndex]
            
            // pass data to next view
        }
    }
    
    
}

