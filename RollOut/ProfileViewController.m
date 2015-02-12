//
//  ProfileViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import "ProfileViewController.h"
#import "RollOut-Swift.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation ProfileViewController

- (IBAction)addFriendPressed:(id)sender {
    self.addFriendButton.userInteractionEnabled = NO;
    if ([self.addFriendButton.titleLabel.text isEqualToString:@"Add Friend"]){
        [PFCloud callFunctionInBackground:@"sendFriendRequest" withParameters:@{@"recipientID": self.user.objectId} block:^(id object, NSError *error) {
            if (!error) {
                // this is where you handle the results and change the UI.
                [self.addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
                [User addOutgoingFriendRequest:self.user.objectId];
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
                [User addFriend:self.user.objectId];
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

- (IBAction)changePhoto:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = image;
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *fileName = [NSString stringWithFormat:@"ProfilePic%@.png", self.user.objectId];
    PFFile *file = [PFFile fileWithName:fileName data:imageData];
    self.user[@"profilePic"] = file;
    self.user[@"hasProfilePic"] = @YES;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            NSLog(@"Profile pic uploaded successfully");
        }
        else{
            NSLog(@"Error uploading profile pic");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:222/256.0 blue:80/256.0 alpha:1.0]];
}

// checks if the user profile to be displayed has any relation to the logged in user
// and adjusts the interface accordingly
- (BOOL) searchForRelations{
    for (NSString *userid in [User friends]){
        if ([userid isEqualToString:self.user.objectId]){
            [self.addFriendButton setTitle:@"Friends" forState:UIControlStateNormal];
            self.addFriendButton.userInteractionEnabled = NO;
            return YES;
        }
    }
    for (NSString *userid in [User incomingFriendRequests]){
        if ([userid isEqualToString:self.user.objectId]){
            [self.addFriendButton setTitle:@"Accept Request" forState:UIControlStateNormal];
            return YES;
        }
    }
    for (NSString *userid in [User outgoingFriendRequests]){
        if ([userid isEqualToString:self.user.objectId]){
            [self.addFriendButton setTitle:@"Request Sent" forState:UIControlStateNormal];
            self.addFriendButton.userInteractionEnabled = NO;
            return YES;
        }
    }
    return NO;
}

-(void) loadData{
    self.nameLabel.text = self.user[@"displayName"];
    if ([self.user[@"hasProfilePic"] boolValue]){
        PFFile *imageFile = self.user[@"profilePic"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error){
                UIImage *profileImage = [UIImage imageWithData:data];
                // update image view on main thread
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.profileImageView.image = profileImage;
                    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
                }];
            }
            else{
                NSLog(@"Error retrieving image");
            }
        }];
    }
    if (self.isCurrentUser){
        self.addFriendButton.userInteractionEnabled = NO;
        [self.addFriendButton setTitle:@"" forState:UIControlStateNormal];
    }
    else{
        [self searchForRelations];
        self.logoutButton.enabled = NO;
        self.logoutButton.title = @"";
        self.navigationItem.title = self.user[@"displayName"];
        self.changePhotoButton.enabled = NO;
        [self.changePhotoButton setTitle:@"" forState:UIControlStateNormal];
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
        [User clearRelations];
    }
}


@end
