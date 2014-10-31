//
//  RequestsViewController.m
//  Spring
//
//  Created by Joseph Asperger on 10/31/14.
//
//

#import "RequestsViewController.h"

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
    PFUser *user = self.pendingFriends[indexPath.row];
    cell.textLabel.text = user[@"displayName"];
    cell.imageView.image = [UIImage imageNamed:@"greybox.jpg"];
    
    return cell;
}

@end
