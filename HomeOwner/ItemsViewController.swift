import UIKit

class ItemsViewController: UITableViewController
{
    
 let items = Items()
 let images = imagesCache()
    
 let filters :  [(Item)->Bool] = [{Int($0.value)>=50}, {Int($0.value)<50}]
 let headers  = ["Items >= $50", "Items < $50"]
 let footers  = ["End of section >= $50", "End of section <$50"]
    
    @IBAction func addItem(_ sender: UIBarButtonItem)
    {
        let newItem = items.createItem()
        let s = newItem.value>=50 ? 0 : 1
        
        if let ind = items.itemsList.filter(filters[s]).index(of: newItem)
        {
         
          let ip = IndexPath(row: ind, section: s)
          tableView.insertRows(at: [ip], with: .automatic)
          tableView.reloadData()
        }
    }
    
   /* @IBAction func toggleEditMode(_ sender: UIBarButtonItem)
    {
     setEditing(!isEditing, animated: true)
     sender.title = isEditing ? "Done" : "Edit"
    
    }*/
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let inset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.rowHeight = 65
        
   
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell

        let its = items.itemsList.filter(filters[indexPath.section])/*.sorted(by: {$0.value<$1.value})*/
        newCell.nameLabel.text = its[indexPath.row].name
        newCell.valueLabel.text = "$\(its[indexPath.row].value)"
        newCell.serialLabel.text = its[indexPath.row].serial
        return newCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return filters.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    
        return items.itemsList.filter(filters[section]).count
        
       //return items.itemsList.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
      if editingStyle == .delete
      {
        let itemToDel = items.itemsList.filter(filters[indexPath.section])/*.sorted(by: {$0.value<$1.value})*/[indexPath.row]
        print(indexPath.section, itemToDel.value, itemToDel.name)
        if let ind = items.itemsList.index(of: itemToDel)
        {
         items.itemsList.remove(at: ind)
         tableView.deleteRows(at: [indexPath], with: .fade)
        
        }
    
      }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let cnt = items.itemsList.filter(filters[section]).count
        return cnt > 0 ? "Total number of items: \(cnt)" : nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        let it = items.itemsList.filter(filters[section])
        return it.count > 0 ? "Subtotal:  $\(it.reduce(0, {$0 + $1.value}))" : nil
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if sourceIndexPath.section == destinationIndexPath.section {return}
        tableView.moveRow(at: destinationIndexPath, to: sourceIndexPath)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
       
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE")
        {_,indexPath in
            let itemToDel = self.items.itemsList.filter(self.filters[indexPath.section])[indexPath.row]
            let deleteAC = UIAlertController(title: "\(itemToDel.name) - \(itemToDel.value)", message: "Are you sure you want to delete this item?", preferredStyle: UIAlertControllerStyle.alert)
            
            let delAction = UIAlertAction(title: "DELETE", style: .destructive)
            {_ in
             if let ind = self.items.itemsList.index(of: itemToDel)
             {
                print(indexPath.section, itemToDel.value, itemToDel.name)
                self.items.itemsList.remove(at: ind)
                self.images.deleteImage(forKey: itemToDel.imageKey)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
             }
            }
            
            let cnxAction = UIAlertAction(title: "CANCEL", style: .cancel)
            {_ in
               print ("action cancelled by user")
            }
            
            deleteAC.addAction(delAction)
            deleteAC.addAction(cnxAction)
            deleteAC.preferredAction = cnxAction
            
            self.present(deleteAC, animated: true, completion: nil)
            
            
        }
        let editAction = UITableViewRowAction(style: .normal, title: "EDIT")
        {_,indexPath
            
            in
            
            guard let EditItemVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController
                else
            {
                return
            }
            self.navigationController?.pushViewController(EditItemVC, animated: true)
            let item_edit = self.items.itemsList.filter(self.filters[indexPath.section])[indexPath.row]
            EditItemVC.editedItem = item_edit
            EditItemVC.images = self.images
        }
        
        editAction.backgroundColor = UIColor.green
        return [editAction, deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
     if let segID = segue.identifier, segID == "showItem", let ip = tableView.indexPathForSelectedRow
     {
       let item_edit = items.itemsList.filter(filters[ip.section])[ip.row]
       (segue.destination as! DetailViewController).editedItem = item_edit
       (segue.destination as! DetailViewController).images = images
     }
    }
    
    /*override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        return .insert ;
    }*/
}


