//
//  RequestsViewController.m
//  Spring
//
//  Created by Joseph Asperger on 10/31/14.
//
//

#import "RequestsViewController.h"
#import "ProfileViewController.h"

@interface RequestsViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *pendingFriends;

@end

@implementation RequestsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pendingFriends = [NSMutableArray new];
    PFRelation *requestsFrom = [[PFUser currentUser] relationForKey:@"recievedRequests"];
    PFQuery *query = [requestsFrom query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
        }
        else{
            self.pendingFriends = objects;
            [self.tableView reloadData];
        }
    }];
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
    return [self.pendingFriends count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    PFUser *user = self.pendingFriends[indexPath.row];
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
        dest.user = self.pendingFriends[indexPath.row];
        dest.isCurrentUser = FALSE;
        //[dest loadData];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
