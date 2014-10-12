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
#import "Event.h"
#import "ServerInfo.h"

@interface FeedViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *events;
@end

@implementation FeedViewController
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[ServerInfo alleventsURL]]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];*/
    
    self.events = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query includeKey:@"creator"];
    [query includeKey:@"activity"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                Event *event = [Event new];
                event.name = object[@"name"];
                event.object = object;
                PFUser *user = object[@"creator"];
                event.userName = user[@"displayName"];
                event.eventID = object[@"objectid"];
                [self.events addObject:event];
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.events count];
    
}

// got this from tutorial here http://www.appcoda.com/use-storyboards-to-build-navigation-controller-and-table-view/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EventCell";
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    //cell.textLabel.text = [events objectAtIndex:indexPath.row];
    cell.userLabel.text = ((Event*)self.events[row]).userName;
    cell.nameLabel.text = ((Event*)self.events[row]).name;
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EventDetailViewController *destViewController = segue.destinationViewController;
        destViewController.event = [self.events objectAtIndex:indexPath.row];
    }
}

@end
