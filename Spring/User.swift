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
        
        static var friends: [String] = []
        static var sentRequests: [String] = []
        static var recievedRequests: [String] = []
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
    
    class func loadFriendRelations(){
        ClassVars.friends = []
        ClassVars.sentRequests = []
        ClassVars.recievedRequests = []
        var query = PFUser.currentUser().relationForKey("friends").query()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error != nil){
                if let errorString = error.userInfo?["error"] as? String {
                    NSLog(errorString)
                }
            }
            else{
                for object in objects as [PFObject] {
                    self.ClassVars.friends.append(object.objectId)
                }
            }
        }
        query = PFUser.currentUser().relationForKey("sentRequests").query()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error != nil){
                if let errorString = error.userInfo?["error"] as? String {
                    NSLog(errorString)
                }
            }
            else{
                for object in objects as [PFObject] {
                    self.ClassVars.sentRequests.append(object.objectId)
                }
            }
        }
        query = PFUser.currentUser().relationForKey("recievedRequests").query()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error != nil){
                if let errorString = error.userInfo?["error"] as? String {
                    NSLog(errorString)
                }
            }
            else{
                for object in objects as [PFObject] {
                    self.ClassVars.recievedRequests.append(object.objectId)
                }
            }
        }
        
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
