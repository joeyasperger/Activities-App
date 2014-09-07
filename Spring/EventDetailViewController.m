//
//  EventDetailViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import "EventDetailViewController.h"
#import "Event.h"

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleInterestedLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *eventTitleLabel;

@end

@implementation EventDetailViewController

@synthesize userLabel = _userLabel;
@synthesize activityLabel = _activityLabel;
@synthesize messageLabel = _messageLabel;
@synthesize peopleInterestedLabel = _peopleInterestedLabel;
@synthesize eventTitleLabel = _eventTitleLabel;
@synthesize event = _event;

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
    self.userLabel.text = [NSString stringWithFormat:@"Creator: %@", self.event.userName];
    self.activityLabel.text = [NSString stringWithFormat:@"Type: %@", self.event.activityName];
    self.messageLabel.text = [NSString stringWithFormat:@"Message: %@", self.event.message];
    self.peopleInterestedLabel.text = [NSString stringWithFormat:@"%i people interested", self.event.numberInterested];
    self.eventTitleLabel.title = self.event.eventName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
