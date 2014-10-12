//
//  Event.h
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define PRIVACY_ANYONE 0
#define PRIVACY_FRIENDS 1
#define PRIVACY_GROUP 2
#define PRIVACY_INVITEONLY 3

@class Activity;

@interface Event : NSObject


@property Activity * activity;
@property NSString *eventID;
@property NSString *name;
@property NSString *userName;
@property NSInteger numberInterested;
@property NSString *description;
@property NSString *activityName;
@property NSInteger privacyType;
@property PFObject *object;

@end
