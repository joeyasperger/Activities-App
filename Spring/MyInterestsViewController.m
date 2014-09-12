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

@interface MyInterestsViewController ()

@property NSMutableArray *activities;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyInterestsViewController

@synthesize activities = _activities;

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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.activities count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = ((Activity*)self.activities[indexPath.row]).name;    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
