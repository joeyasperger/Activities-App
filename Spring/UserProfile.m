//
//  UserProfile.m
//  Spring
//
//  Created by Joseph Asperger on 9/8/14.
//
//

#import "UserProfile.h"

@implementation UserProfile

+(BOOL) loggedIn{
    return YES;
}

+(NSString*) userName{
    return @"Joey Asperger";
}

+(NSString*) email{
   return @"joeyasperger@gmail.com";
}


@end
