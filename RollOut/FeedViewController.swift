//
//  FeedViewController.swift
//  Spring
//
//  Created by Joseph Asperger on 12/30/14.
//  Copyright 2014
//

import UIKit


class FeedViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    //@IBOutlet var tableView: UITableView!
    
    var events = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 222.0/256, blue: 80.0/256, alpha: 0)
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.clearColor()
        refreshControl?.tintColor = UIColor.blackColor()
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.layer.zPosition += 1
        
        loadData()
    }
    
    func loadData() {
        var query = PFQuery(className:"Event")
        query.includeKey("creator")
        query.includeKey("activity")
        query.orderByDescending("time")
        query.cachePolicy = kPFCachePolicyNetworkElseCache
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil){
                self.events = objects
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
            else{
                NSLog("%@", error)
                self.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow()?{
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as EventTableViewCell
        var event: PFObject = events[indexPath.section] as PFObject
        var creator: PFUser = event["creator"] as PFUser
        cell.userLabel.text = creator["displayName"] as? String
        cell.nameLabel.text = event["name"] as? String
        var imageFile = Event.getEventImageFile(event)
        imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if (error == nil){
                var image = UIImage(data: data)
                //update imageview on main thread
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    cell.imageView.image = image
                    cell.imageView.contentMode = UIViewContentMode.ScaleAspectFill
                })
            }
            else{
                println("Error retrieving image for feed")
            }
        })
        if (imageFile == nil){
            cell.imageView.image = UIImage(named: "greybox.jpg")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
