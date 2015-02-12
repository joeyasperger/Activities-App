//
//  SelectTimeViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/25/14.
//
//

#import "SelectTimeViewController.h"
#import "RollOut-Swift.h"

@interface SelectTimeViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.date != nil){
        [self.datePicker setDate:self.date];
    }
    [self setDateLabelText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateChanged:(id)sender {
    self.date = self.datePicker.date;
    [self setDateLabelText];
}

- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setDateLabelText{
    NSDate *date = self.datePicker.date;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.delegate recieveDate:self.datePicker.date];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
