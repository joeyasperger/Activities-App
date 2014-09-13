//
//  FirstViewController.m
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

@end

@implementation FeedViewController
{
    NSMutableArray *events;
}

@synthesize responseData = _responseData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[ServerInfo alleventsURL]]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    events = [NSMutableArray new];
    //[self loadTestEvents];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %ld bytes of data",(long)[self.responseData length]);
    
    NSString* pliststr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", pliststr);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathString = [documentsDirectory stringByAppendingPathComponent:@"myFile"];
    
    [pliststr writeToFile:pathString atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *plistEvents = [NSArray arrayWithContentsOfFile:pathString];
    for (int i = 0; i < [plistEvents count]; i++){
        NSDictionary *eventDict = [plistEvents objectAtIndex:i];
        Event *newEvent = [Event new];
        newEvent.ID = [[eventDict valueForKey:@"ID"] integerValue];
        newEvent.userName = [eventDict valueForKey:@"username"];
        newEvent.activityName = [eventDict valueForKey:@"activity"];
        newEvent.eventName = [eventDict valueForKey:@"eventName"];
        newEvent.message = [eventDict valueForKey:@"description"];
        newEvent.numberInterested = [[eventDict valueForKey:@"numberInterested"] integerValue];
        [events addObject:newEvent];
    }
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [events count];
    
}

// got this from tutorial here http://www.appcoda.com/use-storyboards-to-build-navigation-controller-and-table-view/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EventCell";
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    //cell.textLabel.text = [events objectAtIndex:indexPath.row];
    cell.userLabel.text = ((Event*)events[row]).userName;
    cell.messageLabel.text = ((Event*)events[row]).message;
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EventDetailViewController *destViewController = segue.destinationViewController;
        destViewController.event = [events objectAtIndex:indexPath.row];
    }
}

@end
