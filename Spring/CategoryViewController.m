//
//  CategoryViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/12/14.
//
//

#import "CategoryViewController.h"
#import "Activity.h"
#import "ServerInfo.h"
#import "ActivityViewController.h"
#import "AddActivitiesNavController.h"

@interface CategoryViewController ()

@property NSMutableArray *activities;
@property NSMutableArray *categoryNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *activitiesToAdd;

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activities = [NSMutableArray array];
    self.categoryNames = [NSMutableArray array];
    self.activitiesToAdd = [NSMutableArray array];
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
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
    //TableDownloader *downloader = [[TableDownloader alloc] initWithURL:[ServerInfo allactivitesURL] type:ACTIVITY_DOWNLOADER saveFile:@"allactivities.plist"];
    //downloader.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(id)sender {
    [(AddActivitiesNavController*)self.parentViewController finishAddingActivities:self.activitiesToAdd];
}

-(void) finishAddingActivities{
    [self dismissViewControllerAnimated:YES completion:nil];
    [(AddActivitiesNavController*)self.parentViewController finishAddingActivities:self.activitiesToAdd];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categoryNames count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Activity categoryCell:self.categoryNames[indexPath.row] tableView:tableView];
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ShowActivitiesForCategory" sender:nil];
}

-(void) downloadCompleted:(NSMutableArray *)array{
    self.categoryNames = [Activity uniqueCategoryNamesFromActivities:array];
    self.activities = array;
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowActivitiesForCategory"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ActivityViewController *destViewController = segue.destinationViewController;
        NSString *categoryName = [self.categoryNames objectAtIndex:indexPath.row];
        NSMutableArray *categoryActivities = [Activity activitiesForCategory:categoryName activities:self.activities];
        destViewController.activities = categoryActivities;
        destViewController.categoryName = categoryName;
        destViewController.userActivities = self.userActivities;
        destViewController.activitiesToAdd = self.activitiesToAdd;
    }
}


@end
