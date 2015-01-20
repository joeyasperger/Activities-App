//
//  SelectCategoryViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/25/14.
//
//

#import "SelectCategoryViewController.h"
#import "Activity.h"
#import "SelectActivitiyViewController.h"

@interface SelectCategoryViewController ()

@property NSMutableArray *activities;
@property NSMutableArray *categoryNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.categoryNames = [NSMutableArray array];
    self.activities = [NSMutableArray array];
    /*TableDownloader *downloader = [[TableDownloader alloc] initWithURL:[ServerInfo allactivitesURL] type:ACTIVITY_DOWNLOADER saveFile:@"allactivities.plist"];
    downloader.delegate = self;*/
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                Activity *activity = [Activity new];
                activity.name = object[@"name"];
                activity.categoryName = object[@"categoryName"];
                activity.activityID = object[@"objectid"];
                activity.object = object;
                [self.activities addObject:activity];
                self.categoryNames = [Activity uniqueCategoryNamesFromActivities:self.activities];
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categoryNames count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Activity categoryCell:self.categoryNames[indexPath.row] tableView:tableView];
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"SelectEventActivity" sender:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

- (BOOL) canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SelectEventActivity"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SelectActivitiyViewController *destViewController = segue.destinationViewController;
        NSString *categoryName = [self.categoryNames objectAtIndex:indexPath.row];
        NSMutableArray *categoryActivities = [Activity activitiesForCategory:categoryName activities:self.activities];
        destViewController.activities = categoryActivities;
        destViewController.categoryName = categoryName;
    }
}


@end
