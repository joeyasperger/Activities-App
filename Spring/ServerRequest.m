//
//  ServerRequest.m
//  Spring
//
//  Created by Joseph Asperger on 9/15/14.
//
//

#import "ServerRequest.h"
#import "ServerInfo.h"

@implementation ServerRequest

@synthesize type = _type;

-(id) initWithType:(NSInteger)type{
    if (self = [super init]){
        self.type = _type;
    }
    return self;
}

@end
