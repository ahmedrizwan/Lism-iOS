

import Foundation
import UIKit

class PostCommentsCustomCell: UITableViewCell {
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    var delegate : ProductDetailViewController!
    @IBAction func postBtnAction (sender : UIButton)
    {
    delegate.postComment(index: sender.tag)
        
    }
    
    
    
}