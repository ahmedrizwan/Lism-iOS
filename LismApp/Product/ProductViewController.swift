
import UIKit
import AVOSCloud

class ProductViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UITabBarControllerDelegate,UICollectionViewDelegateFlowLayout{
    static let ITEM_LIMIT = 10
    
    var items : [Product] = []
    var favoritesList : [Product] = []
    var selectedIndex : Int!
    @IBOutlet weak var totalItemsLabel : UILabel!
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var productsCollectionView : UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      //  self.navigationController?.isNavigationBarHidden = true

        self.getProductList()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationController?.navigationBar.backItem?.title = ""
        
        navigationController?.navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item",item.tag)

        if(item.tag == 0)
        {
       
        }
        //This method will be called when user changes tab.
    }

    func getProductList()
    {
        
        let query: AVQuery = AVQuery(className: "Product")
        query.includeKey("images")
        query.includeKey("user")
        query.includeKey("userLikes")
        query.limit = ProductViewController.ITEM_LIMIT
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
                for obj in objects!
                {
                    let productObj:Product =  Product()
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.items.append(productObj)
                }
            
            self.loadFavoritesList()
            }

        }
    }
    
    func loadFavoritesList()
    {

        let query: AVQuery = (AVUser.current()?.relation(forKey: "favorites").query())!
        query.findObjectsInBackground { (objects, error) in
            if(error == nil)
            {
            for obj in objects!
            {
                let productObj:Product =  Product()
                productObj.ProductInintWithDic(dict: obj as! AVObject)
                self.favoritesList.append(productObj)
            }
            self.comapreToUpdateFavoriteProductsList()
            }
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
        self.productsCollectionView.reloadData()
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
                let productObj:Product =  Product()
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
        cell.nameLabel.text = productObj.name
        if(productObj.productImageUrl != nil)
        {
        cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }
        cell.priceLabel.text = "¥ \(productObj.sellingPrice)" ;

        cell.retailPriceTextView.text = "Size \(productObj.size) \n  Est. Retail ¥ \(productObj.priceRetail)"

        if (indexPath.row + 1 == self.items.count )
        {
            self.getMoreProductList(size: self.items.count)
        }
        cell.likeButton.isSelected = productObj.favorite
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: collectionView.bounds.width/2 - 20, height: 240)
        
    }
    // MARK: - UICollectionViewDelegate protocol
    @IBAction func filterBtnAction(sender: AnyObject)
    {
    
    
    }
    @IBAction func listBtnAction(sender: AnyObject)
    {
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
        
        let scrollPos = self.productsCollectionView.contentOffset.y ;
        print(scrollPos)
          if(scrollPos >= 5  ){
        
        UIView.animate(withDuration: 0.5, animations: {
            //
            //write a code to hide
            self.productsCollectionView.frame = CGRect(x: self.productsCollectionView.frame.origin.x, y: 60, width:  self.productsCollectionView.frame.size.width, height:  self.productsCollectionView.frame.size.height)
        }, completion: nil)
          }
        else if (scrollPos <= 0)
            {
                
                UIView.animate(withDuration: 0.5, animations: {
                    //
                    //write a code to hide
                    self.productsCollectionView.frame = CGRect(x: self.productsCollectionView.frame.origin.x, y: 105, width:  self.productsCollectionView.frame.size.width, height:  self.productsCollectionView.frame.size.height)
                }, completion: nil)
            }
        
        
        if(scrollPos >= 60 ){
            //Fully hide your toolbar
     
            UIView.animate(withDuration: 0.5, animations: {
                //
                //write a code to hide
                self.topView.frame = CGRect(x: self.topView.frame.origin.x, y: 0, width:  self.topView.frame.size.width, height:  self.topView.frame.size.height)
              
            }, completion: nil)
        } else  if(scrollPos <= 0 ){
            //Slide it up incrementally, etc.
            UIView.animate(withDuration: 0.5, animations: {
                //
              self.topView.frame = CGRect(x: self.topView.frame.origin.x, y: 65, width:  self.topView.frame.size.width, height:  self.topView.frame.size.height)
            }, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        selectedIndex = indexPath.item
        self.performSegue(withIdentifier: "ProductViewToProductDetailsVC", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ProductViewToProductDetailsVC") {
            let viewController:ProductDetailViewController = segue.destination as! ProductDetailViewController
            viewController.productBO = items[selectedIndex]
            navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)


            // pass data to next view
        }
    }
}

