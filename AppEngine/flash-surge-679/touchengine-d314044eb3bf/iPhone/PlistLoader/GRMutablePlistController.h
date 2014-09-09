//
//  GRMutablePlistController.h
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRPlistController.h"

//this is the version that sends changes back to the server -- not implemented
@interface GRMutablePlistController : GRPlistController {
    BOOL promiscuous;
}

@property(nonatomic, getter=isPromiscuous)BOOL promiscuous;

@end
