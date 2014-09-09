//
//  SonnetAppDelegate.m
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import "SonnetAppDelegate.h"
#import "RootViewController.h"


@implementation SonnetAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
