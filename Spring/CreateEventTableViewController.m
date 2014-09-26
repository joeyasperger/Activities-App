//
//  CreateEventTableViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/25/14.
//
//

#import "CreateEventTableViewController.h"
#import "SelectActivitiyViewController.h"
#import "Activity.h"

@interface CreateEventTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventNameField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property Activity *activity;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property NSDate *eventDate;

@end

@implementation CreateEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    
}

-(void) hideKeyboard{
    [self.descriptionTextView resignFirstResponder];
    [self.eventNameField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) unwindFromSelectActivity: (UIStoryboardSegue*) segue{
    SelectActivitiyViewController *source = [segue sourceViewController];
    self.activity = source.selectedActivity;
    self.activityLabel.text = self.activity.name;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 1){
        [self performSegueWithIdentifier:@"SelectEventCategory" sender:nil];
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        [self performSegueWithIdentifier:@"SelectEventLocation" sender:nil];
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        [self performSegueWithIdentifier:@"SelectEventTime" sender:nil];
    }
    else if (indexPath.section == 1 && indexPath.row == 2){
        [self performSegueWithIdentifier:@"SelectEventPrivacy" sender:nil];
    }
}

- (void) recieveDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.eventDate = date;
    self.timeLabel.text = [dateFormatter stringFromDate:date];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectEventTime"]){
        SelectTimeViewController *destViewController = [segue destinationViewController];
        destViewController.delegate = self;
        if (self.eventDate != nil){
            destViewController.date = self.eventDate;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
