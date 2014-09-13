//
//  ActivityViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/13/14.
//
//

#import "ActivityViewController.h"
#import "Activity.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

@synthesize activities = _activities;
@synthesize userActivities = _userActivities;

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
    self.title = self.categoryName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.activities count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AddActivityTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Activity *activity = self.activities[indexPath.row];
    cell.textLabel.text = activity.name;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button setUserInteractionEnabled:NO];
    cell.accessoryView = button;
    
    //check if it is one of the user's interests
    BOOL isInterest = NO;
    for (Activity *userActivity in self.userActivities){
        if (userActivity.activityID == activity.activityID){
            isInterest = YES;
        }
    }
    if (isInterest){
        NSLog(@"%@", activity.name);
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
        cell.detailTextLabel.enabled = NO;
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}*/


@end
