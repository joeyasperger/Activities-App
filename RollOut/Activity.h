//
//  Activity.h
//  Spring
//
//  Created by Joseph Asperger on 9/11/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Activity : NSObject

@property NSString *name;
@property NSString *activityID;
@property NSString *categoryName;
@property PFObject *object;

/* returns a table cell for an activity that displays the name of the activity and
 * the category name as a subtitle
 */
+ (UITableViewCell*) activitySubtitleCell:(Activity*)activity tableView:(UITableView*)tableView;

// returns a cell displaying the category name and a disclosure icon
+ (UITableViewCell*) categoryCell:(NSString*)categoryName tableView:(UITableView*)tableView;

+ (NSMutableArray*) uniqueCategoryNamesFromActivities:(NSArray*)activities;

+ (NSMutableArray*) activitiesForCategory:(NSString*)categoryName activities:(NSArray*)activities;

@end
