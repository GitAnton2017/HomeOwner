import UIKit

class ItemsViewController: UITableViewController
{
    
 let items = Items()
    
 let filters :  [(Item)->Bool] = [{Int($0.value)>=50}, {Int($0.value)<50}]
 let headers  = ["Items >= $50", "Items < $50"]
 let footers  = ["End of section >= $50", "End of section <$50"]
    
    @IBAction func addItem(_ sender: UIButton)
    {
        let newItem = items.createItem()
        let s = newItem.value>=50 ? 0 : 1
        
        if let ind = items.itemsList.filter(filters[s]).index(of: newItem)
        {
         
          let ip = IndexPath(row: ind, section: s)
          tableView.insertRows(at: [ip], with: .middle)
          tableView.reloadData()
        }
    }
    
    @IBAction func toggleEditMode(_ sender: UIButton)
    {
     setEditing(!isEditing, animated: true)
     sender.setTitle(isEditing ? "Done" : "Edit", for: .normal)
    
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let inset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        
   
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        let its = items.itemsList.filter(filters[indexPath.section])/*.sorted(by: {$0.value<$1.value})*/
        newCell.textLabel?.text = its[indexPath.row].name
        newCell.detailTextLabel?.text = String(its[indexPath.row].value)
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
         tableView.reloadData()
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
        let addAction = UITableViewRowAction(style: .normal, title: "ADD", handler: {_,_ in })
        addAction.backgroundColor = UIColor.green
        return [addAction, deleteAction]
    }
    
    /*override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        return .insert ;
    }*/
}


