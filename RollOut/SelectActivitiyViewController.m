//
//  SelectActivitiyViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/25/14.
//
//

#import "SelectActivitiyViewController.h"
#import "Activity.h"
#import "RollOut-Swift.h"

@interface SelectActivitiyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectActivitiyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UserInterface setTableViewBackground:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.activities count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AddActivityTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Activity *activity = self.activities[indexPath.row];
    cell.textLabel.text = activity.name;
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];

    return cell;
}

-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Activity *selectedActivity = self.activities[indexPath.row];
    self.selectedActivity = selectedActivity;
    [self performSegueWithIdentifier:@"UnwindFromSelectActivity" sender:self];
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
