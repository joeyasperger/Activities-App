//
//  FriendsViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import "FriendsViewController.h"
#import "ProfileViewController.h"

@interface FriendsViewController ()

@property NSArray *friends;
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
    PFQuery *query = [[[PFUser currentUser] relationForKey:@"friends"] query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:222/256.0 blue:80/256.0 alpha:1.0]];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    PFUser *user = self.friends[indexPath.row];
    cell.textLabel.text = user[@"displayName"];
    cell.imageView.image = [UIImage imageNamed:@"greybox.jpg"];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ShowProfile" sender:tableView];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowProfile"]){
        ProfileViewController * dest = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        dest.user = self.friends[indexPath.row];
        dest.isCurrentUser = FALSE;
    }
}


@end
