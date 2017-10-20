import UIKit

class ItemCell: UITableViewCell
{
 @IBOutlet var nameLabel: UILabel!
 @IBOutlet var serialLabel: UILabel!
 @IBOutlet var valueLabel: UILabel!
    
 override func awakeFromNib()
 {
    super.awakeFromNib()
    nameLabel.adjustsFontForContentSizeCategory = true
    serialLabel.adjustsFontForContentSizeCategory = true
    valueLabel.adjustsFontForContentSizeCategory = true

 }
   
}
