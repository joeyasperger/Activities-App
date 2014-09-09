//
//  ServerInfo.h
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import <Foundation/Foundation.h>

#define ALL_EVENTS "http://192.168.1.134:8080/allevents"

@interface ServerInfo : NSObject

+(NSString*) alleventsURL;
+(NSString*) friendsURL:(NSInteger)userID;
+(NSString*) loginURL:(NSString*)email password:(NSString*)password;

@end
