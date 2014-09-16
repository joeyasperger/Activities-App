//
//  AddActivitiesNavController.m
//  Spring
//
//  Created by Joseph Asperger on 9/15/14.
//
//

#import "AddActivitiesNavController.h"
#import "UserProfile.h"
#import "Activity.h"

@interface AddActivitiesNavController ()

@end

@implementation AddActivitiesNavController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) finishAddingActivities:(NSMutableArray*)activities{
    if (activities.count > 0){
        NSMutableString *postString = [NSMutableString stringWithFormat:@"userID=%ld",[UserProfile userID]];
        for (Activity *activity in activities){
            [postString appendString:[NSString stringWithFormat:@"&add=%ld", activity.activityID]];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
