//
//  RootViewController.h
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRPlistController.h"

@class MainViewController;
@class FlipsideViewController;

@interface RootViewController : UIViewController <GRPlistControllerDelegate> {

    UIButton *infoButton;
    MainViewController *mainViewController;
    FlipsideViewController *flipsideViewController;
    UINavigationBar *flipsideNavigationBar;
    
@private
    GRPlistController *plistController;
}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UINavigationBar *flipsideNavigationBar;
@property (nonatomic, retain) FlipsideViewController *flipsideViewController;

- (IBAction)toggleView;

@end
