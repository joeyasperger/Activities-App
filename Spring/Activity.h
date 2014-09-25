//
//  Activity.h
//  Spring
//
//  Created by Joseph Asperger on 9/11/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Activity : NSObject

@property NSString *name;
@property NSInteger activityID;
@property NSInteger categoryID;
@property NSString *categoryName;

/* returns a table cell for an activity that displays the name of the activity and
 * the category name as a subtitle
 */
+ (UITableViewCell*) activitySubtitleCell:(Activity*)activity tableView:(UITableView*)tableView;

// returns a cell displaying the category name and a disclosure icon
+ (UITableViewCell*) categoryCell:(NSString*)categoryName tableView:(UITableView*)tableView;

+ (NSMutableArray*) uniqueCategoryNamesFromActivities:(NSArray*)activities;

+ (NSMutableArray*) activitiesForCategory:(NSString*)categoryName activities:(NSArray*)activities;

@end
