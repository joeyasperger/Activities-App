//
//  SecondViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import "MoreViewController.h"

@interface MoreViewController ()

@property NSArray *moreCells;

@end

@implementation MoreViewController

@synthesize moreCells = _moreCells;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.moreCells = [NSArray arrayWithObjects:@"My Interests", @"Friends", @"Notification Settings", @"Credits", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}

// got this from tutorial here http://www.appcoda.com/use-storyboards-to-build-navigation-controller-and-table-view/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MoreTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    long row = [indexPath row];
    
    //cell.textLabel.text = [events objectAtIndex:indexPath.row];
    cell.textLabel.text = self.moreCells[row];
    
    return cell;
}

@end
