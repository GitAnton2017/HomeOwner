import UIKit
import CoreData

class DateViewController : UIViewController
{
   var editedItem: Item!
   {
    didSet
    {
      navigationItem.title = DetailViewController.dateFormat.string(from: editedItem.date)
    }
   }
    
    var editedItemMO: NSManagedObject!
    {
     didSet
     {
       navigationItem.title = DetailViewController.dateFormat.string(from: editedItemMO.value(forKey: "date") as! Date)
     }
    }
    
    @IBOutlet weak var ItemDatePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //ItemDatePicker.date = editedItem.date
        ItemDatePicker.date = editedItemMO.value(forKey: "date") as! Date
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        //editedItem.date = ItemDatePicker.date
        editedItemMO.setValue(ItemDatePicker.date, forKey: "date")
        
    }
}
