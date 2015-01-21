//
//  SelectTimeViewController.h
//  Spring
//
//  Created by Joseph Asperger on 9/25/14.
//
//

#import <UIKit/UIKit.h>

@protocol DateTimeDelegate

- (void) recieveDate:(NSDate*)date;

@end

@interface SelectTimeViewController : UITableViewController

@property id<DateTimeDelegate> delegate;
@property NSDate *date;

@end
