//
//  EventDetailViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleInterestedLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *eventTitleLabel;

@end

@implementation EventDetailViewController

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
    PFUser *creator = self.event[@"creator"];
    PFObject *activity = self.event[@"activity"];
    self.userLabel.text = creator[@"displayName"];
    self.activityLabel.text = [NSString stringWithFormat:@"Type: %@", activity[@"name"]];
    self.descriptionLabel.text = self.event[@"description"];
    //self.peopleInterestedLabel.text = [NSString stringWithFormat:@"%ld people interested", (long)self.event.numberInterested];
    self.eventTitleLabel.title = self.event[@"name"];
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
