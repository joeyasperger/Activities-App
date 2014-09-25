//
//  Activity.m
//  Spring
//
//  Created by Joseph Asperger on 9/11/14.
//
//

#import "Activity.h"

@implementation Activity

@synthesize name = _name;
@synthesize activityID = _activityID;
@synthesize categoryID = _categoryID;
@synthesize categoryName = _categoryName;

- (NSComparisonResult)compare:(Activity*)otherObject{
    return [self.name compare:otherObject.name];
}

+ (UITableViewCell*) activitySubtitleCell:(Activity *)activity tableView:(UITableView *)tableView{
    static NSString *simpleTableIdentifier = @"InterestsTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = activity.name;
    cell.detailTextLabel.text = activity.categoryName;
    return cell;
}

+ (UITableViewCell*) categoryCell:(NSString *)categoryName tableView:(UITableView *)tableView{
    static NSString *simpleTableIdentifier = @"CategoryTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = (NSString*)categoryName;
    return cell;
}

+ (NSMutableArray*) uniqueCategoryNamesFromActivities:(NSArray *)activities{
    NSMutableArray *categoryNames = [NSMutableArray array];
    for (int i = 0; i < [activities count]; i++){
        NSString *categoryName = ((Activity*)activities[i]).categoryName;
        BOOL alreadyExists = NO;
        for (NSString *string in categoryNames){
            if ([string isEqual:categoryName]){
                alreadyExists = YES;
            }
        }
        if (alreadyExists == NO){
            [categoryNames addObject:categoryName];
        }
    }
    return categoryNames;
}

+ (NSMutableArray*)activitiesForCategory:(NSString *)categoryName activities:(NSArray *)activities{
    NSMutableArray *categoryActivities = [NSMutableArray array];
    for (Activity *activity in activities){
        if ([categoryName isEqual:activity.categoryName]){
            [categoryActivities addObject:activity];
        }
    }
    return categoryActivities;
}

@end
