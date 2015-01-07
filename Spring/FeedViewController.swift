//
//  FeedViewController.swift
//  Spring
//
//  Created by Joseph Asperger on 12/30/14.
//
//

import UIKit


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var events = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 222.0/256, blue: 80.0/256, alpha: 0)
        
        var query = PFQuery(className:"Event")
        query.includeKey("creator")
        query.includeKey("activity")
        query.orderByDescending("createdAt")
        query.cachePolicy = kPFCachePolicyNetworkElseCache
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil){
                self.events = objects
                self.tableView.reloadData()
            }
            else{
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow()?{
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as EventTableViewCell
        var event: PFObject = events[indexPath.section] as PFObject
        var user: PFUser = event["creator"] as PFUser
        cell.userLabel.text = user["displayName"] as? String
        cell.nameLabel.text = event["name"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowEvent", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowEvent"){
            var destViewController: EventViewController = segue.destinationViewController as EventViewController
            destViewController.event = events[tableView.indexPathForSelectedRow()!.section] as PFObject
        }
    }
    

}
