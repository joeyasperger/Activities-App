//
//  ProfileViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end

@implementation ProfileViewController

- (IBAction)logOut:(id)sender {
    
}


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
    if (self.user == nil){
        self.isCurrentUser = YES;
        self.user = [PFUser currentUser];
    }
    [self loadData];
}

-(void) loadData{
    self.nameLabel.text = self.user[@"displayName"];
    if (!self.isCurrentUser){
        self.logoutButton.enabled = NO;
        self.logoutButton.title = @"";
        self.navigationItem.title = self.user[@"displayName"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"LogoutSeque"]) {
        [PFUser logOut];
    }
}


@end
