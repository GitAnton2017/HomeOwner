import UIKit

class imagesCache
{
    let cache = NSCache<NSString, UIImage>()
    
    
    func imageURL (forKey image_key: String) -> URL
    {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!.appendingPathComponent(image_key)
        
    }
    
    func setImage (_ image: UIImage, forKey image_key: String)
    {
     cache.setObject(image, forKey: image_key as NSString)
     
     if let imageData = UIImageJPEGRepresentation(image, 0.5)
     {
      try? imageData.write(to: imageURL(forKey: image_key))
     }
    
    }
    
    func getImage (forKey image_key: String) -> UIImage?
    {
      if let cash_image = cache.object(forKey: image_key as NSString)
      {
       return cash_image
      }
      else
      {
       if let archived_image = UIImage(contentsOfFile: imageURL(forKey: image_key).path)
       {
        cache.setObject(archived_image, forKey: image_key as NSString)
        return archived_image
       }
       else
       {
        return nil
       }
      }
    }
    
    func deleteImage (forKey image_key: String)
    {
      cache.removeObject(forKey: image_key as NSString)
      try? FileManager.default.removeItem(at: imageURL(forKey: image_key))
    }
}
