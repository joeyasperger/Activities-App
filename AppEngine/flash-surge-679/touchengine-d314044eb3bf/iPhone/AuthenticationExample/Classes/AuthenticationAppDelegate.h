//
//  AuthenticationAppDelegate.h
//  Authentication
//
//  Created by jonathan on 9/10/10.
//  Copyright Sounds Broken inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthenticationViewController;

@interface AuthenticationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AuthenticationViewController *viewController;
    UINavigationController *rootNav;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AuthenticationViewController *viewController;

@end

