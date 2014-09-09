//
//  PlistLoaderAppDelegate.h
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class GRPlistController;

@interface PlistLoaderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

