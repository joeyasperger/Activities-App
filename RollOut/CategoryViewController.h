//
//  CategoryViewController.h
//  Spring
//
//  Created by Joseph Asperger on 9/12/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface CategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *userActivities;

-(void) finishAddingActivities;

@end
