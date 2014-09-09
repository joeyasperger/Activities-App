//
//  ServerInfo.m
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import "ServerInfo.h"

static NSString *host = @"http://192.168.1.134:8080";

@implementation ServerInfo

+(NSString*) alleventsURL{
    return [NSString stringWithFormat:@"%@/allevents",host];
}

+(NSString*) friendsURL:(NSInteger)userID{
    return [NSString stringWithFormat:@"%@/listfriends?id=%ld", host, userID];
}

+(NSString*) loginURL:(NSString *)email password:(NSString *)password{
    return [NSString stringWithFormat:@"%@/login?email=%@&password=%@", host, email, password];
}

@end
