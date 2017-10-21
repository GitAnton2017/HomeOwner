import UIKit
class DateViewController : UIViewController
{
   var editedItem: Item!
   {
    didSet
    {
        navigationItem.title = DetailViewController.dateFormat.string(from: editedItem.date)
    }
   }
    
    
    
    @IBOutlet weak var ItemDatePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        ItemDatePicker.date = editedItem.date
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        editedItem.date = ItemDatePicker.date
        
    }
}
