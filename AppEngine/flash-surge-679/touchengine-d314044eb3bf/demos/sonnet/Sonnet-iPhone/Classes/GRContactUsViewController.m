//
//  GRContactUsViewController.m
//  Sonnet
//
//  Created by Jonathan Saggau on 11/16/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import "GRContactUsViewController.h"
#import "GRUtils.h"

@interface GRContactUsViewController (Private)

- (void)loadHtml;
- (void) updateRotation:(UIInterfaceOrientation)toInterfaceOrientation;

@end


@implementation GRContactUsViewController
@synthesize webView;
@synthesize button;
@synthesize toolbar;

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [self updateRotation: self.interfaceOrientation];
    [self loadHtml];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self updateRotation: self.interfaceOrientation];
    [self loadHtml];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self updateRotation: self.interfaceOrientation];
    [self loadHtml];
}

-(IBAction)dismiss;
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)loadHtml
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *contactHTMLPath = [resourcePath stringByAppendingPathComponent:@"contact.html"];
    NSURL *baseURL = [NSURL fileURLWithPath:contactHTMLPath isDirectory:NO];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:baseURL
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:2.0];
    [self.webView loadRequest:theRequest];
}

- (void) updateRotation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect toolbarFrame = self.toolbar.frame;
    self.button.width = toolbarFrame.size.width - 12.0;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration; // Notification of rotation beginning.
{
    [self updateRotation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //It's a modal view... and the web view doesn't like to auto rotate for some reason.
    return (NO);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{

    NSURL *theUrl = request.URL;
    if ([theUrl isFileURL]) // we're loading from the bundle
    {
        return YES;
    }
    else
    {
        //opens the URL in safari
        [[UIApplication sharedApplication] openURL:theUrl];
        return NO;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [toolbar release]; toolbar = nil;
    [button release]; button = nil;
    [webView release]; webView = nil;
    [super dealloc];
}


@end
