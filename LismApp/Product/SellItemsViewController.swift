
import Foundation
import AVOSCloud

class SellItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITabBarDelegate
{
    @IBOutlet weak var noItemForSalesView : UIView!
    @IBOutlet weak var noItemForSalesHeading : UILabel!
    @IBOutlet weak var noItemForSalesSubHeading : UILabel!
    @IBOutlet weak var noItemForSalesP1Heading : UILabel!
    @IBOutlet weak var noItemForSalesP2Heading : UILabel!
    @IBOutlet weak var noItemForSalesP1DetailsView : UITextView!
    @IBOutlet weak var noItemForSalesP2DetailsView : UITextView!
    @IBOutlet weak var myLessLabel : UILabel!

    @IBOutlet weak var sellButtonReference : UIButton!

    @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!

    @IBOutlet weak var  productsTableView : UITableView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    var  refresher = UIRefreshControl()
    var seelctedProductObj : Product!
    var items : [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(getProductList), for: .valueChanged)
        self.productsTableView!.addSubview(refresher)
        myLessLabel.text = "My Less".localized(using: "Main")
self.sellButtonReference.setTitle("START SELLING".localized(using: "Main"), for: .normal)
        //if no items posted for sale so far then we will show no items details view
    tabBar.selectedItem = selectedTabBarItem
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.updateNoItemsDetailsView()
        self.getProductList()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //   self.progressView.isHidden = true

    }
    

    func updateNoItemsDetailsView()
    {
    noItemForSalesView.isHidden = false
    noItemForSalesHeading.text = Constants.sell_is_more.localized(using: "Main")
    noItemForSalesSubHeading.text = Constants.sell_with_us_it_s_easy.localized(using: "Main")
    noItemForSalesP1Heading.text = Constants.selling_is_fast_and_easy.localized(using: "Main")
    noItemForSalesP2Heading.text = Constants.you_earn_more.localized(using: "Main")
    noItemForSalesP1DetailsView.text = Constants.selling_description.localized(using: "Main")
    noItemForSalesP2DetailsView.text = Constants.earn_more_description.localized(using: "Main")

    
    }
   func getProductList()
    {
        
        
        self.view.isUserInteractionEnabled = false
        let query: AVQuery = (AVUser.current()?.relation(forKey: "sellProducts").query())!
        query.includeKey("user")
        query.whereKey("user", equalTo:  AVUser.current()!)

        self.progressView.isHidden = false
        self.progressView.startAnimating()
        query.findObjectsInBackground { (objects, error) in
            self.progressView.isHidden = true
            self.refresher.endRefreshing()
            self.view.isUserInteractionEnabled = true
            if(error == nil)
            {
                self.progressView.isHidden = true
                self.progressView.stopAnimating()
                self.items.removeAll()
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    
                    
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.items.append(productObj)
                }
                if(self.items.count>0)
                {
                    
                    self.sellButtonReference.setTitle("SELL MORE".localized(using: "Main"), for: UIControlState.normal)
                    self.noItemForSalesView.isHidden = true
    
              //  self.sellButtonReference.setTitle("SELL MORE", for: .normal)
                self.productsTableView.reloadData()
                }
                else
                {
                    self.sellButtonReference.setTitle("START SELLING".localized(using: "Main"), for: .normal)

                    self.updateNoItemsDetailsView()
                }
            }
            else
            {
                Constants.showAlert(message: "Unable to load products.".localized(using: "Main"), view: self)

            }
            
            
        }
        
    }
    
    
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellItemsCustomCell", for: indexPath ) as! SellItemsCustomCell
        let productObj = self.items[indexPath.item]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        Constants.produceAttributedTextForItems(string: "\(productObj.name)\n\(productObj.brand)\n\("Size".localized(using: "Main")) \(productObj.size) \n¥ \(productObj.sellingPrice)", textView: cell.sizeAndPriceTextView)
        if(productObj.productImageUrl != nil)
        {
            cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }
        cell.tag = indexPath.item
        cell.productStatusLabel.text = productObj.status.localized(using: "Main")
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
    
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        seelctedProductObj = self.items[indexPath.item]
        if(seelctedProductObj.status == Constants.posted_for_sale)
        {
        //get product and move for edit
        self.performSegue(withIdentifier: "SellToEditItemVc", sender: self)
        }
        else
     
        
        {
             self.performSegue(withIdentifier: "WaitingToSentToUpdateViewController", sender: self)
       // Constants.showAlert(message: "You cannot edit sold product", view: self)
        }
        
        
    }


   
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item",item.tag)
        if(item.tag == 2)
        {
            //load new view
            self.performSegue(withIdentifier: "SellToProfileViewcontroller", sender: self)

        }
        else if(item.tag == 4)
        {
            //load new view
            self.performSegue(withIdentifier: "SellToProductView", sender: false)
        }
        
        else if(item.tag == 3)
        {
            //load new view
            self.performSegue(withIdentifier: "SellToProductView", sender: true)
        }
        //SellToProfileViewcontroller
        //This method will be called when user changes tab.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SellToEditItemVc") {
            let viewController:UpdatePostedItemForSaleViewController = segue.destination as! UpdatePostedItemForSaleViewController
            viewController.productObj = seelctedProductObj
            // pass data to next view
        }
        else if (segue.identifier == "WaitingToSentToUpdateViewController") {
            let viewController:UpdateWaitingtoBeSentStatus = segue.destination as! UpdateWaitingtoBeSentStatus
            viewController.productObj = seelctedProductObj
            // pass data to next view
        }
        else if (segue.identifier == "SellToProductView") {
            let viewController:ProductViewController = segue.destination as! ProductViewController
            viewController.isloadingFav = sender as! Bool
            // pass data to next view
        }
    }
    
}
