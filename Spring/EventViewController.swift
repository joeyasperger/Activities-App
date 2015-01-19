//
//  EventViewController.swift
//  Spring
//
//  Created by Joseph Asperger on 1/18/15.
//
//

import UIKit

class EventViewController: UITableViewController, UITextFieldDelegate {
    
    let headerSection = 0
    let interestSection = 1
    let writePostSection = 2
    let displayPostsSection = 3
    
    var event: PFObject!
    var posts = []
    var didLoadPosts = false
    var isWritingPost = false
    
    var interestLabel: UILabel!
    var joinButton: UIButton!
    var postField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = event["displayName"] as? String
        loadPosts()
    }
    
    func joinButtonPressed() {
        joinButton.setImage(UIImage(named: "Checkmark"), forState: UIControlState.Normal)
        joinButton.setTitle("Joined", forState: UIControlState.Normal)
        joinButton.userInteractionEnabled = false
    }
    
    func loadPosts() {
        var postsQuery = PFQuery(className: "EventPost")
        postsQuery.whereKey("event", equalTo: self.event)
        postsQuery.includeKey("user")
        postsQuery.orderByDescending("createdAt")
        postsQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil){
                self.posts = objects
                self.didLoadPosts = true
                self.tableView.reloadData()
            }
        }
    }
    
    func submitPost(postText: String){
        var eventPost = PFObject(className: "EventPost")
        eventPost["user"] = PFUser.currentUser()
        eventPost["event"] = event
        eventPost["content"] = postText
        eventPost.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if (succeeded){
                self.loadPosts()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        submitPost(textField.text)
        self.isWritingPost = false
        textField.resignFirstResponder()
        textField.text = ""
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: writePostSection)], withRowAnimation: UITableViewRowAnimation.Automatic)
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == writePostSection){
            if (!isWritingPost){
                isWritingPost = true
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (didLoadPosts){
            return 4
        }
        else{
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == displayPostsSection){
            return posts.count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == headerSection){
            return 163
        }
        else if (indexPath.section == interestSection){
            return 44
        }
        else if (indexPath.section == writePostSection){
            if (self.isWritingPost){
                return 70
            }
            else{
                return 44
            }
        }
        else{
            return 82 // TODO: implement size to fit
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == headerSection){
            var cell = tableView.dequeueReusableCellWithIdentifier("EventHeaderCell", forIndexPath: indexPath) as EventHeaderCell
            var creator = event["creator"] as PFUser
            var activity = event["activity"] as PFObject
            var date = self.event["time"] as NSDate
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            cell.timeLabel.text = dateFormatter.stringFromDate(date)
            cell.creatorNameLabel.text = creator["displayName"] as? String
            cell.activityButton.setTitle(activity["name"] as? String, forState: UIControlState.Normal)
            return cell
        }
        else if (indexPath.section == interestSection){
            var cell = tableView.dequeueReusableCellWithIdentifier("EventInterestCell", forIndexPath: indexPath) as EventInterestCell
            joinButton = cell.joinButton
            interestLabel = cell.interestLabel
            interestLabel.text = String(format:"%d People Interested", event["numberInterested"] as Int)
            self.joinButton.addTarget(self, action: "joinButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
        else if (indexPath.section == writePostSection){
            if (!self.isWritingPost){
                var cell = tableView.dequeueReusableCellWithIdentifier("EventPostButtonCell", forIndexPath: indexPath) as UITableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
                return cell
            }
            else{
                var cell = tableView.dequeueReusableCellWithIdentifier("EventWritePostCell", forIndexPath: indexPath) as EventWritePostCell
                postField = cell.postField
                postField.delegate = self
                postField.becomeFirstResponder()
                return cell
            }
        }
        else{ // is display post cell
            var cell = tableView.dequeueReusableCellWithIdentifier("EventPostCell", forIndexPath: indexPath) as EventPostCell
            var post = posts[indexPath.row] as PFObject
            cell.postLabel.text = post["content"] as? String
            return cell
        }
    }
}

class EventPostCell: UITableViewCell {
    
    @IBOutlet weak var postLabel: UILabel!
}

class EventWritePostCell: UITableViewCell {
    
    @IBOutlet weak var postField: UITextField!
    
}

class EventHeaderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
}

class EventInterestCell: UITableViewCell {
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var interestLabel: UILabel!
    
}


