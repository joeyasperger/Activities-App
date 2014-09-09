//
//  AuthenticationViewController.m
//  Authentication
//
//  Created by jonathan on 9/10/10.
//  Copyright Sounds Broken inc 2010. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "GoogleAppEngineAuth.h"
#import "CaptchaViewController.h"

@interface AuthenticationViewController ()
-(void)login;
-(void)login:(id)sender;
-(void)cancel;
-(void)cancel:(id)sender;

@property(nonatomic, retain)UIBarButtonItem *loginButton;
@property(nonatomic, retain)UIBarButtonItem *cancelButton;
@property(nonatomic, retain)CaptchaViewController *captchaVC;

@end

@implementation AuthenticationViewController
-(id) initWithNibName:(NSString *)nibName bundle:nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self != nil) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!loginButton) 
    {
        loginButton = [[UIBarButtonItem alloc] initWithTitle:@"login"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(login:)];
    }
    
    if(!cancelButton)
    {
        cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"cancel"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(cancel:)];
    }
    
    [[self navigationItem] setRightBarButtonItem:loginButton animated:animated];
    [[self navigationItem] setLeftBarButtonItem:cancelButton animated:animated];
    
    [usernameField setText:@""];
    [passwordField setText:@""];
    
    [cancelButton setEnabled:NO];
    [loginButton setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:usernameField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:passwordField];
    
    [usernameField setDelegate:self];
    [passwordField setDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [usernameField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:usernameField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:passwordField];
}

-(void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload 
{
	// Release any retained subviews of the main view.
    [self setUsernameField:nil];
    [self setPasswordField:nil];
}

#pragma mark login delegate
-(void)authSucceeded:(NSString *)authKey;
{
    loggingIn = NO;
    if (delegate && [delegate respondsToSelector:@selector(authenticationViewControllerDidLogin:)])
    {
        [delegate authenticationViewControllerDidLogin:self];
    }
}

-(void)authFailed:(NSString *)error;
{
    loggingIn = NO;
    if (delegate && [delegate respondsToSelector:@selector(authenticationViewController:didFailLoginWithErrorMessage:)]) 
    {
        [delegate authenticationViewController:self didFailLoginWithErrorMessage:error];
    }

}

-(void)authCaptchaTestNeededFor:(NSString *)captchaToken withCaptchaURL:(NSURL *)captchaURL;
{
    loggingIn = NO;
    CaptchaViewController *vc = [[CaptchaViewController alloc] initWithToken:captchaToken withUrl:captchaURL];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self setCaptchaVC:vc];
    [vc setDelegate:self];
    [vc release];
    
    [self.navigationController presentModalViewController:navC animated:YES];
    [navC autorelease];
}

#pragma mark CaptchaViewControllerDelegate

-(void)captchaViewController:(CaptchaViewController *)vc didFinishWithString:(NSString *)capString;
{
    NSString *token = [vc token];
    [auth authWithUsername:[usernameField text]
               andPassword:[passwordField text]
                andCaptcha:capString
           andCaptchaToken:token
                withSource:@"com.soundsbroken.authTest"];
     
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self setCaptchaVC:nil];
}

#pragma mark login

-(void)login
{
    NSAssert(nil != [self remoteURL], @"We need a remote URL to login");
    if (loggingIn) 
    {
        return;
    }
    
    [passwordField resignFirstResponder];
    [usernameField resignFirstResponder];
    [cancelButton setEnabled:NO];
    [loginButton setEnabled:NO];
    if (!auth) {
        NSURL *url = [NSURL URLWithString:[self remoteURL]];
        auth = [[GoogleAppEngineAuth alloc] initWithDelegate:self
                                                   andAppURL:url];
    }
    
    loggingIn = YES;
    [auth authWithUsername:[usernameField text]
               andPassword:[passwordField text]
                withSource:@"com.soundsbroken.authTest"];
}

-(void)login:(id)sender
{
    [self login];
    [passwordField resignFirstResponder];
    [usernameField resignFirstResponder];
}

-(void)cancel
{
    [passwordField resignFirstResponder];
    [usernameField resignFirstResponder];
    [cancelButton setEnabled:NO];
}

-(void)cancel:(id)sender
{
    [self cancel];
}

#pragma mark UITextField stuff

-(void)textFieldChanged:(NSNotification *)note
{
    BOOL shouldEnableLogin = ([[passwordField text] length] > 0 
                              && [[usernameField text] length] > 0);
    [loginButton setEnabled:shouldEnableLogin];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField;              
// called when 'return' key pressed. return NO to ignore.
{
    NSString *string = [textField text];
    if(string && [string length] > 0)
    {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField;          
// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    return ([[textField text] length] > 1);
}


-(void)textFieldDidBeginEditing:(UITextField *)textField;
// became first responder//
{
    [cancelButton setEnabled:YES];
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//-(BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
//-(void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

#pragma mark accessors
@synthesize remoteURL;
@synthesize usernameField;
@synthesize passwordField;
@synthesize loginButton;
@synthesize cancelButton;
@synthesize captchaVC;
@synthesize delegate;

-(void)dealloc {
    delegate = nil;
    [remoteURL release]; remoteURL = nil;
    
    [usernameField setDelegate:nil];
    [usernameField release]; usernameField = nil;
    
    [passwordField setDelegate:nil];
    [passwordField release]; passwordField = nil;
    
    [loginButton release]; loginButton = nil;
    [cancelButton release]; cancelButton = nil;
    
    [captchaVC release]; captchaVC = nil;
    
    [super dealloc];
}

@end
