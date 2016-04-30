//

import Foundation
import CoreData
import Firebase
class Organization {
    var name:String
    var type:String
    var location:String
    var phoneNumber:String?
    var image:NSData?
    var isVisited:Bool//NSNumber?
    var rating:String?
//    let ref = Firebase?
    convenience init(name:String, type: String, location:String, phoneNumber:String?, image:NSData?, isVisited: Bool?, rating:String?)
    {
        self.init(name: name, type: type, location: location, phoneNumber: phoneNumber, image: image, isVisited: isVisited, rating: rating)
    }
    init(snap:FDataSnapshot) {
         name = (snap.value.objectForKey("name") as? String)!
         type = (snap.value.objectForKey("type") as? String)!
         location = (snap.value.objectForKey("location") as? String)!
         phoneNumber = snap.value.objectForKey("phoneNumber") as? String
         let imageString = snap.value.objectForKey("image") as? String
         image = NSData(base64EncodedString: imageString!, options: NSDataBase64DecodingOptions(rawValue: 0))
        //                    let decodedImage = NSData(base64EncodedString: imageString!, options: NSDataBase64DecodingOptions(rawValue: 0))
         isVisited = (snap.value.objectForKey("isVisited") as? Bool)!
         rating = snap.value.objectForKey("rating") as? String

    }
}

