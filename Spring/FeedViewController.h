//
//  FeedViewController.h
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableData *responseData;

@end
