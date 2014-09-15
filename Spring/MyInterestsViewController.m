//
//  MyInterestsViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/11/14.
//
//

#import "MyInterestsViewController.h"
#import "ServerInfo.h"
#import "UserProfile.h"
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

@synthesize editButton = _editButton;
@synthesize activities = _activities;
@synthesize inEditMode = _inEditMode;
@synthesize addActivitiesButton = _addActivitiesButton;
@synthesize activitiesToDelete = _activitiesToDelete;

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
    TableDownloader *downloader = [[TableDownloader alloc] initWithURL:[ServerInfo interestsURL:[UserProfile userID]] type:ACTIVITY_DOWNLOADER saveFile:@"myinterests.plist"];
    downloader.delegate = self;
}

-(void) downloadCompleted:(NSMutableArray *)array{
    self.activities = array;
    [self.tableView reloadData];
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
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InterestsTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    Activity *activity = self.activities[indexPath.row];
    cell.textLabel.text = activity.name;
    cell.detailTextLabel.text = activity.categoryName;
    return cell;
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
        CategoryViewController *destViewController = segue.destinationViewController;
        destViewController.userActivities = self.activities;
    }
}


@end
