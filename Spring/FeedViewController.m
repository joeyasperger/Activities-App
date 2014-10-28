//
//  FeedViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import "FeedViewController.h"
#import "EventTableViewCell.h"
#import "EventDetailViewController.h"

@interface FeedViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *events;
@end

@implementation FeedViewController
{

}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Event";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:@"creator"];
    [query includeKey:@"activity"];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"EventCell";
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    PFUser *user = object[@"creator"];
    cell.userLabel.text = user[@"displayName"];
    cell.nameLabel.text = object[@"name"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EventDetailViewController *destViewController = segue.destinationViewController;
        destViewController.event = [self.objects objectAtIndex:indexPath.row];
    }
}

@end
