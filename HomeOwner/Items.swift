class Items
{
 var itemsList = [Item]()
 @discardableResult func createItem()->Item
 {
   let newItem = Item(true)
   itemsList.append(newItem)
   return newItem
 }
 
 func removeItem (_ item: Item)
 {
  if let ind = itemsList.index(of: item)
  {
   itemsList.remove(at: ind)
  }
 }
    
 init (_ count: Int = 0)
 {
  for _ in 0..<count
  {
   createItem()
  }
 }
}
