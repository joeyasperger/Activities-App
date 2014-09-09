//
//  CaptchaViewController.h
//  Authentication
//
//  Created by jonathan on 9/11/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CaptchaViewController;
@protocol CaptchaViewControllerDelegate

@optional
-(void)captchaViewController:(CaptchaViewController *)vc didFinishWithString:(NSString *)string;
@end

@class GTMHTTPFetcher;
@interface CaptchaViewController : UIViewController <UITextFieldDelegate> {
    UIImageView *imageView;
    UITextField *captchaField;
    NSObject <CaptchaViewControllerDelegate> *delegate;
    NSURL *url;
    NSString *captchaToken;
@private
    GTMHTTPFetcher *fetcher;
    UIBarButtonItem *doneButton;
}

//Designated init
-(id)initWithToken:(NSString *)token withUrl:(NSURL *)aUrl;

@property(nonatomic, readonly, retain)NSURL *url;
@property(nonatomic, readonly, copy)NSString *token;
@property(nonatomic, retain)IBOutlet UIImageView *imageView;
@property(nonatomic, retain)IBOutlet UITextField *captchaField;
@property(nonatomic, assign)NSObject <CaptchaViewControllerDelegate> *delegate;

@end
