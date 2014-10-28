//
//  FriendsViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import "FriendsViewController.h"
#import "Friend.h"

@interface FriendsViewController ()

@property NSMutableArray *friends;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation FriendsViewController

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
    self.friends = [NSMutableArray new];
    /*TableDownloader *downloader = [[TableDownloader alloc] initWithURL:[ServerInfo friendsURL:[UserProfile userID]] type:FRIEND_DOWNLOADER saveFile:@"myfriends.plist"];
    downloader.delegate = self;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friends count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = ((Friend*)self.friends[indexPath.row]).name;
    cell.imageView.image = [UIImage imageNamed:@"greybox.jpg"];
    
    return cell;
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
