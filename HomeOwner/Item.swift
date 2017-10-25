
import UIKit

class Item: NSObject, NSCoding
{
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(serial, forKey: "serial")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(imageKey, forKey: "imageKey")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as! String
        value = aDecoder.decodeDouble(forKey: "value")
        serial = aDecoder.decodeObject(forKey: "serial") as! String?
        date = aDecoder.decodeObject(forKey: "date") as! Date
        imageKey = aDecoder.decodeObject(forKey: "imageKey") as! String
        super.init()
    }
    
    var name: String
    var value: Double
    var serial: String?
    var date: Date
    var imageKey: String
    
    init (_ name: String, _ value: Double = 0.00, _ serial: String? = "", _ date: Date = Date())
    {
        self.name = name
        self.value = value
        self.serial = serial
        self.date = date
        
        imageKey = UUID().uuidString
        
        super.init()
    }
    
    convenience init( _ random: Bool = false)
    {
      if random
      {
       let adjectives = ["Fluffy", "Rusty", "Shiny"]
       let nouns = ["Bear", "Spork", "Mac"]
       var idx = arc4random_uniform(UInt32( adjectives.count))
       let randomAdjective = adjectives[Int(idx)]
       idx = arc4random_uniform(UInt32(nouns.count))
       let randomNoun = nouns[Int(idx)]
       let randomName = "\(randomAdjective) \(randomNoun)"
       let randomValue = Double(arc4random_uniform(100))
       let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
       
       self.init(randomName, randomValue, randomSerialNumber)
        
      }
      else
      {
        self.init("")
      }
    }
    
}
