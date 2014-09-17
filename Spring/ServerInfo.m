//
//  ServerInfo.m
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import "ServerInfo.h"

static NSString *host = @"http://192.168.1.134:8080";
// static NSString *host = @"http://flash-surge-679.appspot.com";
// static NSString *host = @"http://10.0.1.117:8080";

@implementation ServerInfo

+(NSString*) alleventsURL{
    return [NSString stringWithFormat:@"%@/allevents",host];
}

+(NSString*) friendsURL:(NSInteger)userID{
    return [NSString stringWithFormat:@"%@/listfriends?id=%ld", host, userID];
}

+(NSString*) interestsURL:(NSInteger)userID{
    return [NSString stringWithFormat:@"%@/interests/show?id=%ld", host, userID];
}

+(NSString*) loginURL:(NSString *)email password:(NSString *)password{
    return [NSString stringWithFormat:@"%@/login?email=%@&password=%@", host, email, password];
}

+(NSString*) allactivitesURL{
    return [NSString stringWithFormat:@"%@/allactivities",host];
}

+(NSString*) addInterestsURL{
    return [NSString stringWithFormat:@"%@/interests/add", host];
}

+(NSString*) deleteInterestsURL{
    return [NSString stringWithFormat:@"%@/interests/delete", host];
}

@end
