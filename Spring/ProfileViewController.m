//
//  ProfileViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import "ProfileViewController.h"
#import "CurrentUserRelations.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end

@implementation ProfileViewController

- (IBAction)addFriendPressed:(id)sender {
    self.addFriendButton.userInteractionEnabled = NO;
    if ([self.addFriendButton.titleLabel.text isEqualToString:@"Add Friend"]){
        [PFCloud callFunctionInBackground:@"sendFriendRequest" withParameters:@{@"recipientID": self.user.objectId} block:^(id object, NSError *error) {
            if (!error) {
                // this is where you handle the results and change the UI.
                [self.addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
                [CurrentUserRelations downloadRelations];
            }
            else{
                NSLog(@"Error sending friend request");
                self.addFriendButton.userInteractionEnabled = YES;
            }
        }];
    }
    else if ([self.addFriendButton.titleLabel.text isEqualToString:@"Accept Request"]){
        [PFCloud callFunctionInBackground:@"friend" withParameters:@{@"friendID": self.user.objectId} block:^(id object, NSError *error) {
            if (!error) {
                // this is where you handle the results and change the UI.
                [self.addFriendButton setTitle:@"Friends" forState:UIControlStateNormal];
                [CurrentUserRelations downloadRelations];
            }
            else{
                NSLog(@"Error sending friend request");
                self.addFriendButton.userInteractionEnabled = YES;
            }
        }];
    }
}

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
    else if ([self.user.objectId isEqualToString:[PFUser currentUser].objectId]){
        self.isCurrentUser = YES;
    }
    
    [self loadData];
}

// checks if the user profile to be displayed has any relation to the logged in user
// and adjusts the interface accordingly
- (BOOL) searchForRelations{
    if ([CurrentUserRelations hasDownloadedRelations]){
        for (NSString *userid in [CurrentUserRelations friends]){
            if ([userid isEqualToString:self.user.objectId]){
                [self.addFriendButton setTitle:@"Friends" forState:UIControlStateNormal];
                self.addFriendButton.userInteractionEnabled = NO;
                return YES;
            }
        }
        for (NSString *userid in [CurrentUserRelations recievedRequests]){
            if ([userid isEqualToString:self.user.objectId]){
                [self.addFriendButton setTitle:@"Accept Request" forState:UIControlStateNormal];
                return YES;
            }
        }
        for (NSString *userid in [CurrentUserRelations sentRequests]){
            if ([userid isEqualToString:self.user.objectId]){
                [self.addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
                self.addFriendButton.userInteractionEnabled = NO;
                return YES;
            }
        }
    }
    return NO;
}

-(void) loadData{
    self.nameLabel.text = self.user[@"displayName"];
    if (self.isCurrentUser){
        self.addFriendButton.userInteractionEnabled = NO;
        [self.addFriendButton setTitle:@"" forState:UIControlStateNormal];
    }
    else{
        [self searchForRelations];
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
