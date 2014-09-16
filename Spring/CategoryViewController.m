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

@synthesize activities = _activities;
@synthesize categoryNames = _categoryNames;
@synthesize tableView =_tableView;
@synthesize userActivities = _userActivities;
@synthesize activitiesToAdd = _activitiesToAdd;


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
    TableDownloader *downloader = [[TableDownloader alloc] initWithURL:[ServerInfo allactivitesURL] type:ACTIVITY_DOWNLOADER saveFile:@"allactivities.plist"];
    downloader.delegate = self;
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
    static NSString *simpleTableIdentifier = @"CategoryTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = (NSString*)self.categoryNames[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ShowActivitiesForCategory" sender:nil];
}

-(void) downloadCompleted:(NSMutableArray *)array{
    // put all the unique category names into an self.categoryNames
    for (int i = 0; i < [array count]; i++){
        NSString *categoryName = ((Activity*)array[i]).categoryName;
        BOOL alreadyExists = NO;
        for (NSString *string in self.categoryNames){
            if ([string isEqual:categoryName]){
                alreadyExists = YES;
            }
        }
        if (alreadyExists == NO){
            [self.categoryNames addObject:categoryName];
        }
        
        // also fill activities array
        [self.activities addObject:array[i]];
    }
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
        
        //get activities for selected category
        NSMutableArray *categoryActivities = [NSMutableArray array];
        NSString *categoryName = [self.categoryNames objectAtIndex:indexPath.row];
        for (Activity *activity in self.activities){
            if ([categoryName isEqual:activity.categoryName]){
                [categoryActivities addObject:activity];
            }
        }
        destViewController.activities = categoryActivities;
        destViewController.categoryName = categoryName;
        destViewController.userActivities = self.userActivities;
        destViewController.activitiesToAdd = self.activitiesToAdd;
    }
}


@end
