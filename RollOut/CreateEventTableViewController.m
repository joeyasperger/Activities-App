//
//  CreateEventTableViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/25/14.
//
//

#import "CreateEventTableViewController.h"
#import "SelectActivitiyViewController.h"
#import "SelectEventLocationViewController.h"
#import "RollOut-Swift.h"
#import "Activity.h"
#import <CoreLocation/CoreLocation.h>

@interface CreateEventTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventNameField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property Activity *activity;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property NSString *privacyType;
@property NSDate *eventDate;
@property CLLocationCoordinate2D eventLocation;
@property CLLocationManager *locationManager;
@property BOOL locationSet;
@end

@implementation CreateEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    self.doneButton.enabled = NO;
    [self.eventNameField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    self.privacyType = @"Anyone";
    self.privacyLabel.text = self.privacyType;
    NSDate* currentDate = [NSDate date];
    self.eventDate = [self nextHourDate:currentDate];
    [self updateDateLabel];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:222/256.0 blue:80/256.0 alpha:1.0]];
    [self getCurrentLocation];
}

- (void) getCurrentLocation{
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        // only works on iOS 8
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([CLLocationManager locationServicesEnabled]){
        NSLog(@"Location Enabled");
    }
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 20; // meters
    [self.locationManager startUpdatingLocation];
}

 -(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
 NSLog(@"Error: %@",error.description);
 }
 
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!self.locationSet){
        CLLocation *location = [locations lastObject];
        self.eventLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        self.locationLabel.text = @"Current Location";
        self.locationSet = YES;
    }
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"name"] = self.eventNameField.text;
    event[@"creator"] = [PFUser currentUser];
    event[@"location"] = [PFGeoPoint geoPointWithLatitude:self.eventLocation.latitude longitude:self.eventLocation.longitude];
    if (self.activity){
        event[@"activity"] = self.activity.object;
    }
    if (self.eventDate){
        event[@"time"] = self.eventDate;
    }
    if (self.descriptionTextView.text.length > 0){
        event[@"description"] = self.descriptionTextView.text;
    }
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            // succeeded
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
        }
    }];
    
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

-(void) textFieldDidChange:(UITextField*)textField{
    if (textField.text.length == 0){
        self.doneButton.enabled = NO;
    }
    else{
        self.doneButton.enabled = YES;
    }
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

/* rounds the time to the next hour */
- (NSDate*) nextHourDate:(NSDate*)inDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSEraCalendarUnit|NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate: inDate];
    [comps setHour: [comps hour]+1]; // Here you may also need to check if it's the last hour of the day
    return [calendar dateFromComponents:comps];
}

- (void) updateDateLabel{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.timeLabel.text = [dateFormatter stringFromDate:self.eventDate];
}

- (void) recieveDate:(NSDate *)date{
    self.eventDate = date;
    [self updateDateLabel];
}

- (void) recievePrivacySettings:(NSString*)privacyType{
    self.privacyType = privacyType;
    self.privacyLabel.text = self.privacyType;
}

-(void) recieveLocation:(CLLocationCoordinate2D)location{
    self.eventLocation = location;
    NSLog(@"%f, %f", location.latitude, location.longitude);
    self.locationLabel.text = @"Location of marker";
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectEventTime"]){
        SelectTimeViewController *destViewController = [segue destinationViewController];
        destViewController.delegate = self;
        destViewController.date = self.eventDate;
    }
    if ([segue.identifier isEqualToString:@"SelectEventPrivacy"]){
        PrivacyPickerViewController *destViewController = [segue destinationViewController];
        destViewController.delegate = self;
        destViewController.initialSelection = self.privacyType;
    }
    if ([segue.identifier isEqualToString:@"SelectEventLocation"]){
        SelectEventLocationViewController *destViewController = [segue destinationViewController];
        destViewController.delegate = self;
        destViewController.location = self.eventLocation;
        destViewController.passedLocation = YES;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
