//
//  SonnetAppDelegate.h
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SonnetAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

