import UIKit

class imagesCache
{
    let cache = NSCache<NSString, UIImage>()
    
    func setImage (_ image: UIImage, forKey image_key: String)
    {
     cache.setObject(image, forKey: image_key as NSString)
    }
    
    func getImage (forKey image_key: String) -> UIImage?
    {
      return cache.object(forKey: image_key as NSString)
    }
    
    func deleteImage (forKey image_key: String)
    {
      cache.removeObject(forKey: image_key as NSString)
    }
}
