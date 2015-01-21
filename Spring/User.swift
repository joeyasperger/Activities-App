//
//  User.swift
//  Spring
//
//  Created by Joseph Asperger on 1/19/15.
//
//

/*
  This class stores data on the relations of the current user so they can be easily accessed
  without getting data from the server. It stores the id's of the events the current user has 
  created or joined as well as id's of friends and friend requests of the current user

  TODO: add functions to remove objects from the stored arrays, i.e. for when the current
        user accepts a friend request so the friend must be removed from the request list
  TODO: decompose the messy repeated calls to the server to fill the array
*/


import Foundation

var events = []

@objc class User {
    
    private struct ClassVars {
        // using a struct to store class variables until apple implements them
        
        static var eventsJoined: [String] = []
        static var eventsCreated: [String] = []
        
        static var friends: [String] = []
        static var outgoingFriendRequests: [String] = []
        static var incomingFriendRequests: [String] = []
    }
    
    // download and store IDs of all events user created or joined in arrays for faster loading
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
    }
    
    class func loadFriendRelations(){
        ClassVars.friends = []
        ClassVars.outgoingFriendRequests = []
        ClassVars.incomingFriendRequests = []
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
                    self.ClassVars.outgoingFriendRequests.append(object.objectId)
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
                    self.ClassVars.incomingFriendRequests.append(object.objectId)
                }
            }
        }
    }
    
    class func loadAllRelations() {
        loadEvents()
        loadFriendRelations()
    }
    
    class func clearRelations() {
        ClassVars.friends = []
        ClassVars.incomingFriendRequests = []
        ClassVars.outgoingFriendRequests = []
        ClassVars.eventsCreated = []
        ClassVars.eventsJoined = []
    }
    
    class func eventsJoined() -> [String] {
        return ClassVars.eventsJoined
    }
    
    class func eventsCreated() -> [String] {
        return ClassVars.eventsCreated
    }
    
    class func friends() -> [String] {
        return ClassVars.friends
    }
    
    class func outgoingFriendRequests() -> [String] {
        return ClassVars.outgoingFriendRequests
    }
    
    class func incomingFriendRequests() -> [String] {
        return ClassVars.incomingFriendRequests
    }
    
    class func addEventJoined(eventID: String) {
        ClassVars.eventsJoined.append(eventID)
    }
    
    class func addEventCreated(eventID: String) {
        ClassVars.eventsCreated.append(eventID)
    }
    
    class func addFriend(friendID: String) {
        ClassVars.friends.append(friendID)
    }
    
    class func addOutgoingFriendRequest(userID: String) {
        ClassVars.outgoingFriendRequests.append(userID)
    }
    
    class func addIncomingFriendRequest(userID: String) {
        ClassVars.incomingFriendRequests.append(userID)
    }
}
