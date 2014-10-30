//
//  AddFriendsViewController.m
//  Spring
//
//  Created by Joseph Asperger on 10/28/14.
//
//

#import "AddFriendsViewController.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface AddFriendsViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *users;

@end

@implementation AddFriendsViewController


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

    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchString = searchBar.text;
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"displayName" matchesRegex:searchString modifiers:@"i"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.users = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    PFObject *user = self.users[indexPath.row];
    cell.textLabel.text = user[@"displayName"];
    cell.imageView.image = [UIImage imageNamed:@"greybox.jpg"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showProfile" sender:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProfile"]){
        ProfileViewController * dest = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        dest.user = self.users[indexPath.row];
        dest.isCurrentUser = FALSE;
        //[dest loadData];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
