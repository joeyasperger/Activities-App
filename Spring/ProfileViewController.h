//
//  ProfileViewController.h
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController

@property BOOL isCurrentUser;
@property PFUser *user;

- (void) loadData;

@end
