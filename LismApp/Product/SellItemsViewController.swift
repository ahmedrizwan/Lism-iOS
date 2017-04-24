
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
    
    @IBOutlet weak var sellButtonReference : UIButton!

    @IBOutlet weak var tabBar : UITabBar!
    @IBOutlet weak var selectedTabBarItem : UITabBarItem!

    @IBOutlet weak var  productsTableView : UITableView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    var  refresher = UIRefreshControl()
    
    var items : [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(getProductList), for: .valueChanged)
        self.productsTableView!.addSubview(refresher)
        
        //if no items posted for sale so far then we will show no items details view
    tabBar.selectedItem = selectedTabBarItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProductList()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.progressView.isHidden = true

    }
    

    func updateNoItemsDetailsView()
    {
    noItemForSalesView.isHidden = false
    noItemForSalesHeading.text = Constants.sell_is_more
    noItemForSalesSubHeading.text = Constants.sell_with_us_it_s_easy
    noItemForSalesP1Heading.text = Constants.selling_is_fast_and_easy
    noItemForSalesP2Heading.text = Constants.you_earn_more
    noItemForSalesP1DetailsView.text = Constants.selling_description
    noItemForSalesP2DetailsView.text = Constants.earn_more_description

    
    }
   func getProductList()
    {
        
        
        
        let query: AVQuery = (AVUser.current()?.relation(forKey: "sellProducts").query())!
        query.includeKey("user")
        self.progressView.isHidden = false
        query.findObjectsInBackground { (objects, error) in
            self.progressView.isHidden = true
            self.refresher.endRefreshing()
            
            if(error == nil)
            {
                for obj in objects!
                {
                    let productObj:Product =  obj as! Product
                    
                    
                    productObj.ProductInintWithDic(dict: obj as! AVObject)
                    self.items.append(productObj)
                }
                if(self.items.count>0)
                {
                    
                self.sellButtonReference.setTitle("Sell More", for: .application)
                self.productsTableView.reloadData()
                }
                else
                {
                    self.updateNoItemsDetailsView()
                }
            }
            
            
        }
        
    }
    
    
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellItemsCustomCell", for: indexPath ) as! SellItemsCustomCell
        let productObj = self.items[indexPath.item]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        self.produceAttributedText(string: "\(productObj.name)\n\(productObj.brand)\nSize \(productObj.size) \n¥ \(productObj.sellingPrice)", textView: cell.sizeAndPriceTextView)
        if(productObj.productImageUrl != nil)
        {
            cell.productImageView.sd_setImage(with: productObj.productImageUrl, placeholderImage: nil)
        }
        cell.productStatusLabel.text = productObj.status
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
    
        
        
        return cell
    }


    func produceAttributedText(string: String, textView : UITextView)
    {
        
        let attributedString = NSMutableAttributedString(string:string)
        attributedString.addAttribute(NSFontAttributeName , value: UIFont(name: "Avenir", size: CGFloat(14))!,range: NSMakeRange(0, attributedString.length))
        
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.maximumLineHeight = 15 // change line spacing between each line like 30 or 40
        
        paragraphStyle.alignment = NSTextAlignment.left
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(colorLiteralRed: 182.0/255.0, green: 182.0/255.0, blue: 182.0/255.0, alpha: 1.0), range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        textView.attributedText=attributedString
        
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item",item.tag)
        
        if(item.tag == 0)
        {
            //load new view
            self.performSegue(withIdentifier: "SellToProductView", sender: self)
        }
        //This method will be called when user changes tab.
    }
    
}
