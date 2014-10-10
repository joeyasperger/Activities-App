//
//  UserProfile.h
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserProfile : NSObject

+(BOOL) loggedIn;
+(NSString*) userName;
+(NSString*) email;
+(NSInteger) userID;
+(PFUser*) user;
+(void) setUser:(PFUser*)userObject;
+(void) setID:(NSInteger)userid;
+(void) setName:(NSString*)username;
+(void) setEmail:(NSString*)userEmail;
+(void) setLoggedIn:(BOOL)userLoggedIn;

+ (void) logout;

@end
