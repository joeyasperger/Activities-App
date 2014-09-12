//
//  ServerInfo.h
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import <Foundation/Foundation.h>

@interface ServerInfo : NSObject

+(NSString*) alleventsURL;
+(NSString*) friendsURL:(NSInteger)userID;
+(NSString*) interestsURL:(NSInteger)userID;
+(NSString*) loginURL:(NSString*)email password:(NSString*)password;

@end
