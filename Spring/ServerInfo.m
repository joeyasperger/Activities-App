//
//  ServerInfo.m
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import "ServerInfo.h"

static NSString *host = @"http://192.168.1.134:8000";


@implementation ServerInfo

+(NSString*) alleventsURL{
    return [NSString stringWithFormat:@"%@/allevents",host];
}

+(NSString*) friendsURL:(NSInteger)userID{
    return [NSString stringWithFormat:@"%@/listfriends?id=%ld", host, userID];
}

@end
