//
//  CurrentUserRelations.m
//  Spring
//
//  Created by Joseph Asperger on 10/31/14.
//
//
/* This is kind of a wierd implementation. It should probably be changed at some point
 * so it doesnt' use as many Parse API requests and I should figure out how often this data 
 * should be reloaded
 */
#import "CurrentUserRelations.h"

BOOL hasDownloadedRelations = NO;
static NSMutableArray *friends;
static NSMutableArray *recievedRequests;
static NSMutableArray *sentRequests;

@implementation CurrentUserRelations

+ (void) downloadRelations{
    friends = [NSMutableArray new];
    recievedRequests = [NSMutableArray new];
    sentRequests = [NSMutableArray new];
    PFUser *user = [PFUser currentUser];
    PFQuery *friendQuery = [[user relationForKey:@"friends"] query];
    PFQuery *recievedQuery = [[user relationForKey:@"recievedRequests"] query];
    PFQuery *sentQuery = [[user relationForKey:@"sentRequests"] query];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            for (PFObject *object in objects){
                [friends addObject:object.objectId];
            }
        }
    }];
    [recievedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            for (PFObject *object in objects){
                [recievedRequests addObject:object.objectId];
            }
        }
    }];
    [sentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            for (PFObject *object in objects){
                [sentRequests addObject:object.objectId];
            }
        }
    }];
    hasDownloadedRelations = YES;
}

+ (NSArray*) friends{
    return friends;
}

+ (NSArray*) recievedRequests{
    return recievedRequests;
}

+ (NSArray*) sentRequests{
    return sentRequests;
}

+ (BOOL) hasDownloadedRelations{
    return hasDownloadedRelations;
}

@end
