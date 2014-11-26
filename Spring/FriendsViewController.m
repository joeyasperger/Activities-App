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
@property NSMutableArray *filteredFriends;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


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
    // initialize arrays
    self.friends = [NSMutableArray array];
    self.filteredFriends = [NSMutableArray array];
    // start query for friends
    PFQuery *query = [[[PFUser currentUser] relationForKey:@"friends"] query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    // set UI color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:222/256.0 blue:80/256.0 alpha:1.0]];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self filterResultsForString:searchText];
}

- (void) filterResultsForString:(NSString*) searchText{
    // filter names based on the text in the searchbar and put in self.filteredFriends
    [self.filteredFriends removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayName contains[c] %@", searchText];
    self.filteredFriends = [NSMutableArray arrayWithArray:[self.friends filteredArrayUsingPredicate:predicate]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return self.filteredFriends.count;
    }else{
        return self.friends.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        user = self.filteredFriends[indexPath.row];
    }else{
        user = self.friends[indexPath.row];
    }
    
    static NSString *simpleTableIdentifier = @"FriendTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = user[@"displayName"];
    cell.imageView.image = [UIImage imageNamed:@"greybox.jpg"];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ShowProfile" sender:tableView];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowProfile"]){
        UITableView *senderTableView = sender;
        ProfileViewController * dest = [segue destinationViewController];
        NSIndexPath *indexPath = [senderTableView indexPathForSelectedRow];
        if (senderTableView == self.tableView){
            dest.user = self.friends[indexPath.row];
        }else{
            dest.user = self.filteredFriends[indexPath.row];
        }
        dest.isCurrentUser = FALSE;
    }
}


@end
