//
//  QuickFetchViewController.m
//  Authentication
//
//  Created by jonathan on 9/11/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import "QuickFetchViewController.h"
#import "GTMHTTPFetcher.h"

extern NSString *kTestAuthenticationAppURL;

@implementation QuickFetchViewController

- (id) init
{
    self = [super initWithNibName:@"QuickFetchViewController" bundle:nil];
    if (self != nil) {
        
    }
    return self;
}


-(void)fetcher:(GTMHTTPFetcher *)aFetcher finishedWithData:(NSData *)data error:(NSError *)error;
{
    if (error) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed downloading from %@", kTestAuthenticationAppURL]
                                                        message:@"The page failed to download."
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSString *incoming = @"No string came down, sorry";
        
        if (data && [data length] > 0) 
        {
            incoming = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        }
        
        [self.textView setText:incoming];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (fetcher) 
    {
        [fetcher setDelegate:nil];
        [fetcher stopFetching];
        [fetcher release]; fetcher = nil;
    }
    
    // if we're logged - in we'll get "Hello %username%"
    NSURL *url = [NSURL URLWithString:kTestAuthenticationAppURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    fetcher = [[GTMHTTPFetcher alloc] initWithRequest:request];
    [fetcher setCookieStorageMethod:kGTMHTTPFetcherCookieStorageMethodSystemDefault];
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(fetcher:finishedWithData:error:)];
    
}

-(void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setTextView:nil];
}

@synthesize textView;
@synthesize token;

-(void)dealloc 
{
    [textView release]; textView = nil;
    [token release]; token = nil;
    [super dealloc];
}


@end
