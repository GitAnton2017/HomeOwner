import UIKit
import CoreData

class Items
{
 //let itemsArchiveURL: URL
 //var itemsList: [Item]
    
 var itemsListMO = [NSManagedObject]()

 init()
 {
    /*
    
    let fm = FileManager.default
    let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
    itemsArchiveURL = urls.first!.appendingPathComponent("items.archive")
    itemsList = NSKeyedUnarchiver.unarchiveObject(withFile: itemsArchiveURL.path) as? [Item] ?? [Item]()
     
     */
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let moc = delegate.MOC
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HomeOwnerItem")
    
    do
    {
        let fetchResult = try moc.fetch(request)
        itemsListMO = fetchResult as! [NSManagedObject]
    }
    catch
    {
        let e = error as NSError
        print ("Unresolved error \(e) \(e.userInfo)")
    }
    
 }
 
 /*func addNewItem() -> Item
 {
   let item = Item()
   itemsList.append(item)
   return item
 }*/
 
 func addNewItemMO() ->  NSManagedObject
 {
  let delegate = UIApplication.shared.delegate as! AppDelegate
  let moc = delegate.MOC
  let descr = NSEntityDescription.entity(forEntityName: "HomeOwnerItem", in: moc)
  let item = NSManagedObject(entity: descr!, insertInto: moc)
  //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HomeOwnerItem")
    
  item.setValue(Date(), forKey: "date")
  item.setValue(" ", forKey: "name")
  item.setValue(" ", forKey: "serial")
  item.setValue(0.0, forKey: "value")
  item.setValue(nil, forKey: "photo")
    
  itemsListMO.append(item)
    
  /*delegate.saveContext()
    
  do
  {
   let fetchResult = try moc.fetch(request)
   itemsListMO = fetchResult as! [NSManagedObject]
  }
  catch
  {
   let e = error as NSError
   print ("Unresolved error \(e) \(e.userInfo)")
  }*/
    
  return item
    
 }
    
 func deleteItemMO(item : NSManagedObject)
 {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let moc = delegate.MOC
    if let ind = itemsListMO.index(of: item)
    {
        itemsListMO.remove(at: ind)
    }
    moc.delete(item)
 }
 
}
