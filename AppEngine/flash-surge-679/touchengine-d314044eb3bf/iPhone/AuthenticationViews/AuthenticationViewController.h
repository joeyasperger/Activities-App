//
//  AuthenticationViewController.h
//  Authentication
//
//  Created by jonathan on 9/10/10.
//  Copyright Sounds Broken inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleClientLogin.h"
#import "CaptchaViewController.h"

//debugging on the GAE sym
#define ALLOW_EMPTY_PASSWORD (1)

@class AuthenticationViewController;
@protocol AuthenticationViewControllerDelegate <NSObject> ;

@optional
-(void)authenticationViewControllerDidLogin:(AuthenticationViewController *)authVC;
@optional
-(void)authenticationViewController:(AuthenticationViewController *)authVC didFailLoginWithErrorMessage:(NSString *)error;

@end


@class GoogleAppEngineAuth;

@interface AuthenticationViewController : UIViewController <UITextFieldDelegate, GoogleClientLoginDelegate, CaptchaViewControllerDelegate> {
    NSString *remoteURL;
    UITextField *usernameField;
    UITextField *passwordField;
    id <AuthenticationViewControllerDelegate> delegate;
@private
    UIBarButtonItem *loginButton;
    UIBarButtonItem *cancelButton;
    GoogleAppEngineAuth *auth;
    BOOL loggingIn;
    CaptchaViewController *captchaVC;
}

@property(nonatomic, assign)id <AuthenticationViewControllerDelegate> delegate;
@property(nonatomic, copy)NSString *remoteURL;
@property(nonatomic, retain)IBOutlet UITextField *usernameField;
@property(nonatomic, retain)IBOutlet UITextField *passwordField;

@end

