//
//  FirstViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import "FirstViewController.h"
#import "EventTableViewCell.h"
#import "EventDetailViewController.h"
#import "Event.h"

@interface FirstViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FirstViewController
{
    NSMutableArray *events;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *userNames = [NSArray arrayWithObjects:@"Joey Asperger", @"Alex Pinon", @"Jake Zelek", @"Luke Asperger", @"Katie Wardlaw", @"Rachel Hoang", nil];
    NSArray *eventNames = [NSArray arrayWithObjects:@"Wiffleball Game", @"Soccer", @"Football", @"Baseball Game", @"Soccer", @"Basketball Game", nil];
    NSArray *activityNames = [NSArray arrayWithObjects:@"Wiffleball", @"Soccer", @"Football", @"Baseball", @"Soccer", @"Basketball", nil];
    NSArray *messages = [NSArray arrayWithObjects:@"Anyone want to play some wiffle ball?", @"Who wants to play soccer?", @"I want to play some football", @"I am a total loser", @"Anyone up for some soccer", @"Who's down to play some basketball", nil];
    NSArray *numbersInterested = [NSArray arrayWithObjects:@14, @11, @8, @0, @12, @7, nil];
    events = [NSMutableArray new];
    for (int i = 0; i < 6; i++){
        Event *event = [Event new];
        event.ID = i;
        event.userName = [userNames objectAtIndex:i];
        event.eventName = [eventNames objectAtIndex:i];
        event.activityName = [activityNames objectAtIndex:i];
        event.message = [messages objectAtIndex:i];
        event.numberInterested = [numbersInterested objectAtIndex:i];
        [events addObject:event];
    }
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
