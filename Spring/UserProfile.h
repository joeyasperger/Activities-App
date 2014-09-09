//
//  UserProfile.h
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

+(BOOL) loggedIn;
+(NSString*) userName;
+(NSString*) email;
+(NSInteger) userID;
+(void) setID:(NSInteger)userid;
+(void) setName:(NSString*)username;
+(void) setEmail:(NSString*)userEmail;
+(void) setLoggedIn:(BOOL)userLoggedIn;

@end
