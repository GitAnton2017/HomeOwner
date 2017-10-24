
import UIKit

class Item: NSObject
{
    var name: String
    var value: Double
    var serial: String?
    var date: Date
    var imageKey: String
    
    init (_ name: String, _ value: Double, _ serial: String? = nil, _ date: Date = Date())
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
        self.init("", 0)
        
      }
    }
    
}
