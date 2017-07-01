
import UIKit
import AVOSCloud
extension UIImageView {
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
    }
}
class ProductViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    static let ITEM_LIMIT = 10
    
    var items : [Product] = []
    var itemsBackUpArray : [Product] = []

    var favoritesList : [Product] = []
    var selectedIndex : Int!
    var isShowing = false
    var isHiding = false
    var isPopulated = false
    var colors :[String] = []
    var isloadingFav = false
    var isShowingTopbar = false
    var isHidingTopbar = false
    var totalItems : Int = 0
    @IBOutlet weak var totalItemsLabel : UILabel!
    @IBOutlet weak var searchBar : UISearchBar!

    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var sortingView : UIView!
    @IBOutlet weak var mainSortingView : UIView!

    @IBOutlet weak var allCartBtn : UIButton!
    @IBOutlet weak var sortingTableView : UITableView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
     @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!

    @IBOutlet weak var productsCollectionView : UICollectionView!
    var lastScrollPos : CGPoint!
    var  refresher = UIRefreshControl()
    var selectedIndexForSorting = 0
    var textToSearch = ""

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
        searchBar.showsCancelButton = true

        navigationItem.titleView = imageView
        self.navigationController?.navigationBar.isHidden = true
        
        self.productsCollectionView!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.red
        self.addShadowToView()
        self.automaticallyAdjustsScrollViewInsets = false
        if(!self.isloadingFav)
        {
        tabBar.selectedItem = selectedTabBarItem
            refresher.addTarget(self, action: #selector(getProductList), for: .valueChanged)
            self.productsCollectionView!.addSubview(refresher)
            self.getProductList(indexToSort: selectedIndexForSorting)


        }
        else
        {
            refresher.addTarget(self, action: #selector(loadFavoritesList), for: .valueChanged)
            self.productsCollectionView!.addSubview(refresher)
            self.loadFavoritesList()
            self.topView.isHidden = true
            
            
            tabBar.selectedItem = tabBar.items?[2]

        }
        colors = ["Newest First".localized(using: "Main"), "Most <3".localized(using: "Main"), "Price: Low - High".localized(using: "Main"), "Price: High -Low".localized(using: "Main")]
     //   self.mainSortingView.layer.cornerRadius = 10
       // self.mainSortingView.layer.masksToBounds = true

    }
    override func viewWillAppear(_ animated: Bool) {
        self.getProductsCount()
        self.getCartCount()
        self.productsCollectionView.reloadData() //to sync favorite info
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
    
    func getCartCount()
    {
        (AVUser.current()!.relation(forKey: "userCart")).query().countObjectsInBackground{(objects, error) in
            
            if(error == nil)
            {
                
                if(objects > 0)
                {
                    self.allCartBtn.isHidden = false
                    self.allCartBtn.setTitle("\(objects)", for: .normal)
                }
                else
                {
                    self.allCartBtn.isHidden = true
                }
            }
        }

    }
    
    @IBAction func sortingViewClose(sneder : AnyObject)
    {
    sortingView.isHidden = true
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
        
        else if(item.tag == 3)
        {
            //load new view
            isloadingFav = true
            self.items = self.favoritesList
            self.comapreToUpdateFavoriteProductsList()
            self.topView.isHidden = true
            refresher.addTarget(self, action: #selector(loadFavoritesList), for: .valueChanged)

        }
        else
        {
            isloadingFav = false

            self.topView.isHidden = false
            self.items = self.itemsBackUpArray
            self.productsCollectionView.reloadData()

            refresher.addTarget(self, action: #selector(getProductList), for: .valueChanged)

        }
        
        
        //This method will be called when user changes tab.
    }
    
    @IBAction func searchBtnClicked()
    {
    searchBar.isHidden = false
        
    }
    func getProductsCount()
    {
        
        let query: AVQuery = AVQuery(className: "Product")
        query.countObjectsInBackground { (count, error) in
            //update count infor
            self.totalItems = count ;
            self.totalItemsLabel.text = "\("Total items".localized(using: "Main")) \(count)"
        }
    }
  
    func getProductList(indexToSort : Int )
    {
        
        
        
        var query: AVQuery = AVQuery(className: "Product")
        if(textToSearch != "")
        {
            print("textToSearch",textToSearch)
            query.whereKey("brand", contains: textToSearch)
            let nameQuery: AVQuery = AVQuery(className: "Product")
            nameQuery.whereKey("name", contains: textToSearch)
            query =   AVQuery.orQuery(withSubqueries: [nameQuery,query])//AVQuery.or(Arrays.asList(parseQuery, nameQuery));
            
        // query.whereKey("brand", matchesRegex: textToSearch, modifiers: "i")
          //  query.whereKey("name", matchesRegex: textToSearch, modifiers: "i")

        }

        query.includeKey("images")
        query.includeKey("user")
        query.includeKey("userLikes")
        query.includeKey("buyingUser")
     
        
       
        
        switch indexToSort
        {
        case 1:
            query.order(byDescending: "productLikes")
            break;
        case 2:
            query.order(byAscending: "priceSelling")

            break;

        case 3:
            query.order(byDescending: "priceSelling")

            break;

        default: //newest first
            query.order(byDescending: "createdAt")

            break;
  
        }

        query.limit = ProductViewController.ITEM_LIMIT
        self.progressView.isHidden = false

        query.findObjectsInBackground { (objects, error) in
             self.items.removeAll()
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
            Constants.showAlert(message: ("Unable to load products.").localized(using: "Main"), view: self)
            }
            if(!self.isPopulated)
            {
                self.isPopulated = true

                self.itemsBackUpArray = self.items
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
                 self.favoritesList.removeAll()
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.favoritesList.append(productObj)
                }
                if(self.isloadingFav)
                {
                self.items = self.favoritesList
                }
                Constants.favoritesList = self.favoritesList
                self.comapreToUpdateFavoriteProductsList()
            }
            else
            {
                Constants.showAlert(message: ("Unable to load products.").localized(using: "Main"), view: self)

            }
            self.progressView.isHidden = true

            
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textToSearch = searchBar.text!
        perform(#selector(self.searchRequest), with: searchText, afterDelay: 0.15)

    }
    
    func searchRequest()
    {
        if(textToSearch.characters.count > 0)
        {            self.isPopulated = true

            self.getProductList(indexToSort: selectedIndexForSorting)
            
        }
        else
        {
            self.items =   itemsBackUpArray
            self.isPopulated = false

            self.productsCollectionView.reloadData()
            
        }
    
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        self.view.endEditing( true)
      self.items =   itemsBackUpArray
        textToSearch = ""
        isPopulated = false;
        self.productsCollectionView.reloadData()
        
    }
    
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
      
       textToSearch = searchBar.text!
        
        
        
        if(textToSearch.characters.count > 0)
        {
            self.isPopulated = true
        self.getProductList(indexToSort: selectedIndexForSorting)
        
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
                    objFavorite.favorite = true
                }
            }
            
        }

        self.productsCollectionView.reloadData()
        
    }
    func getMoreProductList(size: Int,indexToSort : Int)
    {
        
       
    
                let query: AVQuery = AVQuery(className: "Product")
                query.includeKey("images")
                query.includeKey("user")
                query.includeKey("userLikes")
                query.limit = ProductViewController.ITEM_LIMIT
                query.skip = size
        if(textToSearch != "")
        {
            
            query.whereKey("brand", contains: textToSearch)
            
        }

        switch indexToSort
        {
        case 1:
            query.order(byDescending: "productLikes")
            break;
        case 2:
            query.order(byAscending: "priceSelling")
            
            break;
            
        case 3:
            query.order(byDescending: "priceSelling")
            
            break;
            
        default: //newest first
            query.order(byDescending: "createdAt")
            
            break;
            
        }

        
        query.findObjectsInBackground { (objects, error) in
                    if(error == nil)
                    {
                        for obj in objects!
                        {
                            let productObj:Product =  obj as! Product
                            productObj.ProductInintWithDic(dict: obj as! AVObject)
                            self.items.append(productObj)
                        }
                            self.comapreToUpdateFavoriteProductsList()

                        
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
        if (indexPath.row + 1 == self.items.count  && !isloadingFav && self.items.count < totalItems)
        {
            self.getMoreProductList(size: self.items.count,indexToSort: selectedIndexForSorting)
        }
        cell.likeButton.isSelected = productObj.favorite
        cell.likeButton.tag = indexPath.row
        cell.likeButtonForInteraction.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/2 - 20 , height: collectionView.bounds.width/2 + 60)
        
    }
    // MARK: - UICollectionViewDelegate protocol
    @IBAction func filterBtnAction(sender: AnyObject)
    {
        
       // sortingView.isHidden = false
        //sortingTableView.reloadData()
        
    }
    
    func perfomrFiltering(action: UIAlertAction) {
        if(action.title == colors[0])
        {
        selectedIndexForSorting = 0
        }
        else if(action.title == colors[1])
        {
            selectedIndexForSorting = 1

        }
        else if(action.title == colors[2])
        {
            selectedIndexForSorting = 2
            
        }
        else if(action.title == colors[3])
        {
            selectedIndexForSorting = 3
            
        }
        self.getProductList(indexToSort: selectedIndexForSorting)
        //Use action.title
    }
    
    @IBAction func listBtnAction(sender: AnyObject)
    {
        
        
        let alert = UIAlertController(title: "Sort Items".localized(using: "Main"),
                                      message: "",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        // let image = UIImage(named: "cart_remove")
        var action = UIAlertAction(title: colors[0], style: .default, handler: perfomrFiltering)
        // action.setValue(image, forKey: "image")
        
        alert .addAction(action)
        action = UIAlertAction(title:  colors[1], style: .default, handler: perfomrFiltering)
        // action.setValue(image, forKey: "image")
        
        alert .addAction(action)
        action = UIAlertAction(title:  colors[2], style: .default, handler: perfomrFiltering)
        // action.setValue(image, forKey: "image")
        
        alert .addAction(action)
        action = UIAlertAction(title:  colors[3], style: .default, handler: perfomrFiltering)
        // action.setValue(image, forKey: "image")
        
        alert .addAction(action)
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        alert.view.tintColor = UIColor.gray
        self.present(alert, animated: true, completion: nil)
        
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
       
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.sortingView.isHidden = true
        let currentCellValue = tableView.cellForRow(at: indexPath)! as! ColorsCustomCell
        
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
                self.productsCollectionView.frame = CGRect(x: self.productsCollectionView.frame.origin.x, y: 55, width:  self.productsCollectionView.frame.size.width, height:  self.productsCollectionView.frame.size.height)
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
                self.productsCollectionView.frame = CGRect(x: self.productsCollectionView.frame.origin.x, y: 93, width:  self.productsCollectionView.frame.size.width, height:  self.productsCollectionView.frame.size.height)
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
                self.topView.frame = CGRect(x: self.topView.frame.origin.x, y: 56, width:  self.topView.frame.size.width, height:  self.topView.frame.size.height)
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
    func addToFavoriteButtonAction(index : Int)
    {
        let productObj = self.items[index]
        productObj.favorite = !productObj.favorite
        self.progressView.isHidden = false
        self.progressView.startAnimating()
        if(productObj.favorite )
        {
            productObj.setObject(productObj.productLikes + 1, forKey: "productLikes")
            AVUser.current()?.relation(forKey: "favorites").add(productObj)
        }
        else
        {
            if((productObj.productLikes-1) >= 0)
            {
            productObj.setObject(productObj.productLikes - 1, forKey: "productLikes")
            }
            AVUser.current()?.relation(forKey: "favorites").remove(productObj)
            

        }
        productObj.saveInBackground()
        AVUser.current()?.saveInBackground { (status, error) in
            if(productObj.favorite )
            {
                self.favoritesList.append(productObj)
            }
            else
            {
                let index = self.favoritesList.index(of : productObj)
                if (index != nil)
                {
                self.favoritesList.remove(at: index!)
                }
                if(self.isloadingFav)
                {
                self.items = self.favoritesList
                }
            }
            
            self.comapreToUpdateFavoriteProductsList()
            self.progressView.isHidden = true
            self.progressView.stopAnimating()
        }
        
    
    
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ProductViewToProductDetailsVC") {
            let viewController:ProductDetailViewController = segue.destination as! ProductDetailViewController
            viewController.productBO = items[selectedIndex]
            
            // pass data to next view
        }
    }
    
    
}

