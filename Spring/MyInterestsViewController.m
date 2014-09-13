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

@end

@implementation MyInterestsViewController

@synthesize editButton = _editButton;
@synthesize activities = _activities;
@synthesize inEditMode = _inEditMode;
@synthesize addActivitiesButton = _addActivitiesButton;

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
    self.addActivitiesButton.enabled = NO;
    [self.addActivitiesButton.customView setAlpha:0.0];
}

-(void) downloadCompleted:(NSMutableArray *)array{
    self.activities = array;
    [self.tableView reloadData];
}

- (IBAction)editPressed:(id)sender {
    if (!self.inEditMode){
        [self.tableView setEditing:YES animated:YES];
        self.inEditMode = YES;
        [sender setTitle:@"Done"];
        [UIView animateWithDuration:0.2 animations:^{
            [self.addActivitiesButton.customView setAlpha:1.0];
        }];
        self.addActivitiesButton.enabled = YES;
    }else{
        [self.tableView setEditing:NO animated:YES];
        self.inEditMode = NO;
        [sender setTitle:@"Edit"];
        [UIView animateWithDuration:0.2 animations:^{
            [self.addActivitiesButton.customView setAlpha:0.0];
        }];
        self.addActivitiesButton.enabled = NO;
    }
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
