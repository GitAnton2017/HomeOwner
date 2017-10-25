import UIKit
class Items
{
 let itemsArchiveURL: URL
 var itemsList: [Item]

 init()
 {
    let fm = FileManager.default
    let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
    itemsArchiveURL = urls.first!.appendingPathComponent("items.archive")
    itemsList = NSKeyedUnarchiver.unarchiveObject(withFile: itemsArchiveURL.path) as? [Item] ?? [Item]()
 }
 
 func addNewItem() -> Item
 {
   let item = Item()
   itemsList.append(item)
   return item
 }
}
