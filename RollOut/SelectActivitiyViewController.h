//
//  SelectActivitiyViewController.h
//  Spring
//
//  Created by Joseph Asperger on 9/25/14.
//
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface SelectActivitiyViewController : UIViewController

@property NSMutableArray *activities;
@property NSString *categoryName;
@property Activity *selectedActivity;

@end
