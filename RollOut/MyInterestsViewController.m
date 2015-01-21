//
//  MyInterestsViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/11/14.
//
//

#import "MyInterestsViewController.h"
#import "Activity.h"
#import "CategoryViewController.h"

@interface MyInterestsViewController ()

@property NSMutableArray *activities;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property BOOL inEditMode;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addActivitiesButton;
@property NSMutableArray *activitiesToDelete;

@end

@implementation MyInterestsViewController

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
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"activities"];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // There was an error
        } else {
            for (PFObject *object in objects){
                Activity *activity = [Activity new];
                activity.name = object[@"name"];
                activity.categoryName = object[@"categoryName"];
                activity.activityID = object[@"objectID"];
                activity.object = object;
                [self.activities addObject:activity];
            }
            [self.tableView reloadData];
        }
    }];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:222/256.0 blue:80/256.0 alpha:1.0]];
}

- (IBAction)editPressed:(id)sender {
    if (!self.inEditMode){
        [self startEditing];
    }else{
        [self doneEditing];
    }
}

-(void) startEditing{
    [self.tableView setEditing:YES animated:YES];
    self.inEditMode = YES;
    [self.editButton setTitle:@"Done"];
    self.activitiesToDelete = [NSMutableArray array];
}

-(void) doneEditing{
    [self.tableView setEditing:NO animated:YES];
    self.inEditMode = NO;
    [self.editButton setTitle:@"Edit"];
    if (self.activitiesToDelete.count > 0){
        PFUser *currentUser = [PFUser currentUser];
        PFRelation *relation = [currentUser relationForKey:@"activities"];
        for (Activity *activity in self.activitiesToDelete){
            [relation removeObject:activity.object];
        }
        [currentUser saveInBackground];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Activity activitySubtitleCell:self.activities[indexPath.row] tableView:tableView];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.activitiesToDelete addObject:[self.activities objectAtIndex:indexPath.row]];
        [self.activities removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated{
    if (self.inEditMode){
        [self doneEditing];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddActivities"]) {
        UINavigationController *destNavController = segue.destinationViewController;
        CategoryViewController *destViewController = [destNavController.viewControllers objectAtIndex:0];
        destViewController.userActivities = self.activities;
    }
}


@end
