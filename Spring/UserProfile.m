//
//  UserProfile.m
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import "UserProfile.h"

static NSString* email;
static NSInteger userID;
static BOOL loggedIn;
static NSString* name;

@implementation UserProfile

+(BOOL) loggedIn{
    return YES;
}

+(NSString*) userName{
    return name;
}

+(NSString*) email{
   return email;
}

+(NSInteger) userID{
    return userID;
}

+(void) setEmail:(NSString *)userEmail{
    email = userEmail;
}

+(void) setID:(NSInteger)userid{
    userID = userid;
}

+(void) setLoggedIn:(BOOL)userLoggedIn{
    loggedIn = userLoggedIn;
}

+(void) setName:(NSString *)username{
    name = username;
}

+(void) logout{
    [self setEmail:@""];
    [self setLoggedIn:NO];
    [self setID:0];
    [self setName:@""];
}


@end
