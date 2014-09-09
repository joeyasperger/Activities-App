//
//  RootViewController.h
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GRPlistController;
@class GRSonnetViewController;
@class GRContactUsViewController;

@interface RootViewController : UITableViewController {
    NSArray *sonnets;
    GRPlistController *sonnetsController;
    BOOL updatingSonnets;
    GRSonnetViewController *sonnetViewController;
    GRContactUsViewController *contactUsViewController;
}

@property(nonatomic, retain)NSArray *sonnets;
@property(nonatomic, retain)GRPlistController *sonnetsController;
@property(nonatomic, getter=isUpdatingSonnets)BOOL updatingSonnets;
@property(nonatomic, retain)GRSonnetViewController *sonnetViewController;
@property(nonatomic, retain)GRContactUsViewController *contactUsViewController;

-(IBAction)showInfoView:(id)sender;

@end
