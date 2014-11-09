//
//  SignUpViewController.m
//  Spring
//
//  Created by Joseph Asperger on 10/9/14.
//
//

#import "SignUpViewController.h"
#import "CurrentUserRelations.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation SignUpViewController


- (IBAction)signup:(id)sender {
    [self signupUser];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) signupUser{
    if ([self fieldsValid]){
        PFUser *user = [PFUser user];
        user.username = self.emailField.text;
        user.password = self.passwordField.text;
        user[@"displayName"] = self.usernameField.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [CurrentUserRelations downloadRelations];
                [self performSegueWithIdentifier:@"SignupSegue" sender:self];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                self.errorLabel.text = errorString;
            }
        }];
    }
}

-(BOOL) fieldsValid{
    if (self.emailField.text.length == 0){
        self.errorLabel.text = @"Email address missing";
        return NO;
    }
    if (self.usernameField.text.length < 4 || self.usernameField.text.length > 20){
        self.errorLabel.text = @"Username must be 4 to 20 characters";
        return NO;
    }
    if (self.passwordField.text.length < 8 || self.passwordField.text.length > 20){
        self.errorLabel.text = @"Password must be 8 to 20 characters";
        return NO;
    }
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]){
        self.errorLabel.text = @"Passwords do not match";
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [self.usernameField becomeFirstResponder];
    }
    else if (textField == self.usernameField){
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [self.confirmPasswordField becomeFirstResponder];
    }
    else if (textField == self.confirmPasswordField) {
        [self.confirmPasswordField resignFirstResponder];
        [self signupUser];
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.errorLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
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
