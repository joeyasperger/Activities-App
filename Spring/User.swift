//
//  User.swift
//  Spring
//
//  Created by Joseph Asperger on 1/19/15.
//
//

import Foundation

var events = []

class User {
    
    private struct ClassVars {
        // using a struct to store class variables until apple implements them
        static var eventsJoined: [String] = []
        static var eventsCreated: [String] = []
        static var eventsLoaded = false
    }
    
    // download and store IDs of all events user created or joined for faster loading
    class func loadEvents() {
        ClassVars.eventsJoined = []
        ClassVars.eventsCreated = []
        var query = PFQuery(className: "Event")
        query.whereKey("creator", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error != nil){
                if let errorString = error.userInfo?["error"] as? String {
                    NSLog(errorString)
                }
            }
            else{
                for object in objects as [PFObject] {
                    self.ClassVars.eventsCreated.append(object.objectId)
                }
            }
        }
        var eventsJoinedRelation = PFUser.currentUser().relationForKey("eventsJoined")
        query = eventsJoinedRelation.query()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error != nil){
                if let errorString = error.userInfo?["error"] as? String {
                    NSLog(errorString)
                }
            }
            else{
                for object in objects as [PFObject] {
                    self.ClassVars.eventsJoined.append(object.objectId)
                }
            }
        }
        ClassVars.eventsLoaded = true
    }
    
    class func eventsJoined() -> [String] {
        return ClassVars.eventsJoined
    }
    
    class func eventsCreated() -> [String] {
        return ClassVars.eventsCreated
    }
    
    class func addEventJoined(eventID: String){
        ClassVars.eventsJoined.append(eventID)
    }
    
    class func addEventCreated(eventID: String){
        ClassVars.eventsCreated.append(eventID)
    }
}
