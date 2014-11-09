//
//  EventViewController.h
//  Spring
//
//  Created by Joseph Asperger on 11/8/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property PFObject *event;

@end
