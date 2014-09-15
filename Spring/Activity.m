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

@end
