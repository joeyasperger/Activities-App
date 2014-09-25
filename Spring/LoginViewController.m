//
//  LoginViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import "LoginViewController.h"
#import "ServerInfo.h"
#import "UserProfile.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property NSMutableData *responseData;
@property id sender;
@property (weak, nonatomic) IBOutlet FBLoginView *facebookLoginView;

@end

@implementation LoginViewController

@synthesize sender = _sender;
@synthesize emailField = _emailField;
@synthesize passwordField = _passwordField;
@synthesize responseData = _responseData;
@synthesize errorLabel = _errorLabel;
@synthesize facebookLoginView = _facebookLoginView;

- (IBAction)Login:(id)sender {
    self.sender = sender;
    [self sendLoginRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.errorLabel.text = @"";
    self.facebookLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

-(void)sendLoginRequest{
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[ServerInfo loginURL:self.emailField.text password:self.passwordField.text]]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %ld bytes of data",(long)[self.responseData length]);
    NSString* pliststr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", pliststr);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathString = [documentsDirectory stringByAppendingPathComponent:@"userinfo.plist"];
    
    [pliststr writeToFile:pathString atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *userplist = [NSDictionary dictionaryWithContentsOfFile:pathString];
    if ([[userplist valueForKey:@"error"]  isEqual: @"none"]){
        [UserProfile setLoggedIn:YES];
        [UserProfile setEmail:[userplist valueForKey:@"email"]];
        [UserProfile setID:[[userplist valueForKey:@"id"] integerValue]];
        [UserProfile setName:[userplist valueForKey:@"username"]];
        [self performSegueWithIdentifier:@"LoginSegue" sender:self.sender];
    }
    else{
        self.errorLabel.text = [userplist valueForKey:@"error"];
    }
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
