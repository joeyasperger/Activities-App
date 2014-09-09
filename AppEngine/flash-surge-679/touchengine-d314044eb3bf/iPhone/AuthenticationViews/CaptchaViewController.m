//
//  CaptchaViewController.m
//  Authentication
//
//  Created by jonathan on 9/11/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import "CaptchaViewController.h"
#import "GTMHTTPFetcher.h"

@interface CaptchaViewController ()

@property(nonatomic, readwrite, retain)GTMHTTPFetcher *fetcher;
@property(nonatomic, readwrite, retain)NSURL *url;
@property(nonatomic, readwrite, copy)NSString *token;

-(void)done:(id)sender;
-(void)downloadImage;
-(void)fetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error;

@end

@implementation CaptchaViewController

-(id)initWithToken:(NSString *)aToken withUrl:(NSURL *)aUrl;
{
    self = [super initWithNibName:@"CaptchaViewController" bundle:nil];
    if (self != nil) {
        [self setToken:aToken];
        [self setUrl:aUrl];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!doneButton)
    {
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                   target:self
                                                                   action:@selector(done:)];
    }
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    [doneButton setEnabled:NO];
    [captchaField setDelegate:self];
    [self downloadImage];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.captchaField setDelegate:self];   
}

-(void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload 
{
    [super viewDidUnload];
    [self setImageView:nil];
    [self setCaptchaField:nil];
    [self setImageView:nil];
}

#pragma mark downloading

-(void)fetcher:(GTMHTTPFetcher *)aFetcher finishedWithData:(NSData *)data error:(NSError *)error;
{
    NSAssert(fetcher == self.fetcher, @"We are not supposed to be the delegate of a fetcher other than our own");
    if (nil != error) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed downloading"
                                                        message:@"The captcha image failed to download."
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if (nil != data && [data length] > 0)
    {
        UIImage *image = [UIImage imageWithData:data];
        NSAssert(nil != image, @"Bad image data");
        [self.imageView setImage:image];
        [captchaField setEnabled:YES];
        [captchaField setDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:captchaField];
    }
    else 
    {
        NSAssert(NO, @"There should be an error or a populated data object");
    }
}

-(void)downloadImage
{
    if (fetcher) 
    {
        [fetcher setDelegate:nil];
        [fetcher stopFetching];
        [self setFetcher:nil];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self url]];
    GTMHTTPFetcher *aFetcher = [[GTMHTTPFetcher alloc] initWithRequest:request];
    [aFetcher beginFetchWithDelegate:self
                   didFinishSelector:@selector(fetcher:finishedWithData:error:)];
    [self setFetcher:aFetcher];
    [aFetcher release];
}

-(void)done:(id)sender
{
    //-(void)captchaViewController:(CaptchaViewController *)vc didFinishWithString:(NSString *)string;

    if (delegate && [delegate respondsToSelector:@selector(captchaViewController:didFinishWithString:)]) 
    {
        [delegate captchaViewController:self didFinishWithString:[[self captchaField] text]];
    }
    [captchaField setEnabled:NO];
    [captchaField setDelegate:nil];
}
                     
#pragma mark UITextFieldDelegate

-(void)textFieldChanged:(NSNotification *)note
{
    if ([[captchaField text] length] > 1) 
    {
        [doneButton setEnabled:YES];
    }
}
                     
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField;          
// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    return ([[textField text] length] > 0);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField;              
// called when 'return' key pressed. return NO to ignore.
{
    return ([[textField text] length] > 0);
}

-(void)textFieldDidEndEditing:(UITextField *)textField;             
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    [doneButton setEnabled:YES];
}
//
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
//-(void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
//-(BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)

#pragma mark accessors

@synthesize delegate;
@synthesize imageView;
@synthesize captchaField;
@synthesize url;
@synthesize fetcher;
@synthesize token;

-(void)dealloc 
{
    delegate = nil;
    
    [captchaField release]; captchaField = nil;
    [imageView release]; imageView = nil;
    [doneButton release]; doneButton = nil;
    
    [url release]; url = nil;
    [token release]; token = nil;
    [fetcher setDelegate:nil]; 
    [fetcher stopFetching]; 
    [fetcher release]; fetcher = nil;
    
    [super dealloc];
}


@end
