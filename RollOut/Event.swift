//
//  Event.swift
//  RollOut
//
//  Created by Joseph Asperger on 2/12/15.
//
//

import Foundation

class Event {
    
    class func getEventImageFile(event: PFObject) -> PFFile? {
        var imageFile: PFFile? = nil
        var creator: PFUser = event["creator"] as PFUser
        // not sure has to unwrap this bool better
        var hasEventImage: Bool
        if event["hasEventImage"] != nil{
            hasEventImage = event["hasEventImage"].boolValue
        }
        else{
            hasEventImage = false
        }
        if (hasEventImage){
            //nothing for now
        }
        else{
            // use creator's profile pick
            // not sure has to unwrap this bool better
            var hasProfilePic : Bool
            if creator["hasProfilePic"] != nil{
                hasProfilePic = creator["hasProfilePic"].boolValue
            }
            else{
                hasProfilePic = false
            }
            if (hasProfilePic){
                imageFile = creator["profilePic"] as? PFFile
            }
        }
        return imageFile
    }
    
}