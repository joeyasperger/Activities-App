//
//  UserInterface.swift
//  RollOut
//
//  Created by Joseph Asperger on 1/22/15.
//
//

import Foundation
import UIKit

@objc class UserInterface {
    
    class func setTransparentTableView(tableView: UITableView, navBar: UINavigationBar) {
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tableView.opaque = false
        tableView.backgroundView = UIImageView(image: UIImage(named: "free-wallpaper-19.jpg"))
        
        navBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        navBar.shadowImage = UIImage()
        navBar.translucent = true
        
        var rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor(white: 1, alpha: 0.8).CGColor)
        CGContextFillRect(context, rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
    }
    
    class func setTableViewBackground(tableView: UITableView){
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tableView.opaque = false
        tableView.backgroundView = UIImageView(image: UIImage(named: "free-wallpaper-19.jpg"))
    }
    
    class func setTransparentNavBar(navBar: UINavigationBar){
        navBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        navBar.shadowImage = UIImage()
        navBar.translucent = true
        
        var rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor(white: 1, alpha: 0.8).CGColor)
        CGContextFillRect(context, rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
    }
    
}