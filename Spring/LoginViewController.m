//
//  LoginViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property NSMutableData *responseData;
@property id sender;
@property (weak, nonatomic) IBOutlet FBLoginView *facebookLoginView;

@end

@implementation LoginViewController

- (IBAction)Login:(id)sender {
    self.sender = sender;
    [self sendLoginRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.errorLabel.text = @"";
    self.emailField.text = @"joeyasperger@gmail.com";  //just for faster testing
    self.facebookLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

-(void)sendLoginRequest{
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier:@"LoginSegue" sender:self.sender];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            self.errorLabel.text = errorString;
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordField) {
        self.sender = nil;
        [self sendLoginRequest];
    } else if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    }
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}


- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginSegue"]) {
        
    }
}

@end
