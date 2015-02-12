//
//  PrivacyPickerViewController.m
//  Spring
//
//  Created by Joseph Asperger on 10/2/14.
//
//

#import "PrivacyPickerViewController.h"
#import "PrivacyPickerTableViewCell.h"
#import "RollOut-Swift.h"

@interface PrivacyPickerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *pickerData;
@property UIPickerView *pickerView;
@property BOOL didSetupPicker;

@end

@implementation PrivacyPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pickerData = @[@"Anyone", @"Friends", @"Group", @"Invite Only"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0){
        static NSString *simpleTableIdentifier = @"PrivacyPickerCell";
        
        PrivacyPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        self.pickerView = cell.pickerView;
        cell.pickerView.delegate = self;
        cell.pickerView.dataSource = self;
        if (!self.didSetupPicker){
            [cell.pickerView selectRow:self.initialSelection inComponent:0 animated:NO];
            self.didSetupPicker = YES;
        }
        
        return cell;
    }
    else{
        static NSString *simpleTableIdentifier = @"CategoryTableCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        return cell;
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.delegate recievePrivacySettings:(NSString*)self.pickerData[[self.pickerView selectedRowInComponent:0]]];
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
