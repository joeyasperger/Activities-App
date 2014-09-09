//
//  GRMutablePlistController.m
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import "GRMutablePlistController.h"


@implementation GRMutablePlistController

- (id) init
{
    self = [super init];
    if (self != nil) {
        NSAssert(NO, @"Not implemented");
    }
    return self;
}


//=========================================================== 
//  promiscuous 
//=========================================================== 
- (BOOL)promiscuous
{
    //NSLog(@"in -promiscuous, returned promiscuous = %@", promiscuous ? @"YES": @"NO" );
    
    return promiscuous;
}
- (void)setPromiscuous:(BOOL)flag
{
    //NSLog(@"in -setPromiscuous, old value of promiscuous: %@, changed to: %@", (promiscuous ? @"YES": @"NO"), (flag ? @"YES": @"NO") );
    
    promiscuous = flag;
}


@end
