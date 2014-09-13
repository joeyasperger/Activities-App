//
//  CategoryViewController.h
//  Spring
//
//  Created by Joseph Asperger on 9/12/14.
//
//

#import <UIKit/UIKit.h>
#import "TableDownloader.h"


@interface CategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, TableDownloaderDelegate>

@property NSMutableArray *userActivities;

@end
