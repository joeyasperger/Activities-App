//
//  RootViewController.m
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "GRPlistController.h"
#import "GRUtils.h"
#import "GRPlistModel.h"

@interface RootViewController ()

@property(nonatomic, retain)GRPlistController *plistController;
@end

@interface RootViewController (private)

- (void)loadFlipsideViewController;
- (void)updateFlipsideViewTextFields;

@end


@implementation RootViewController

@synthesize infoButton;
@synthesize flipsideNavigationBar;
@synthesize mainViewController;
@synthesize flipsideViewController;
@synthesize plistController;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:APPENGINE_URL];
    self.plistController = [[[GRPlistController alloc] initWithRemoteURL:url] autorelease];
    self.plistController.delegate = self;
    //grab data from disk, then try hitting the web
    [self.plistController updateDataFromDisk];
    [self.plistController download];

    MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    self.mainViewController = viewController;
    [viewController release];    
    [self.view insertSubview:mainViewController.view belowSubview:infoButton];
    
    self.mainViewController.urlField.text = self.plistController.remoteURL.absoluteString;
}

-(void)updateFlipsideViewTextFields
{
    if (!flipsideViewController)
        return;
        
    self.flipsideViewController.authorLabel.text = [self.plistController.model valueForKeyPath:@"feed.author"];
    self.flipsideViewController.linkLabel.text = [self.plistController.model valueForKeyPath:@"feed.link"];
    self.flipsideViewController.publisherLabel.text = [self.plistController.model valueForKeyPath:@"feed.publisher"];
    self.flipsideViewController.titleLabel.text = [self.plistController.model valueForKeyPath:@"feed.title"];
    self.flipsideViewController.onlineLabel.text = [self.plistController.lastUpdate description];
}

#pragma mark GRPlistControllerDelegate methods
- (BOOL)listControllerShouldDownloadRemoteData:(GRPlistController *)listController;
{
    LogMethod();
    return YES;
}

// if the data from the server has changed...
- (void)listControllerDataWillChange:(GRPlistController *)listController;
{
    LogMethod();
}

- (void)listControllerDataDidChange:(GRPlistController *)listController;
{
    LogMethod();
    [self updateFlipsideViewTextFields];
}

- (void)listController:(GRPlistController *)listController downloadDidFailWithError:(NSError *)err;
{
    LogMethod();
    GRErrorCode errCode = [err code];

    if (kGRPlistFileFormatFailure == errCode)
    {
        NSDictionary *uInfo = [err userInfo];
        NSString *url = [uInfo valueForKey:@"url"];        
        NSString *msg = [NSString stringWithFormat:@"Could not find / parse a plist at %@", url];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Failure" message:msg
                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];    
        [alert release];
    }
}

- (void)loadFlipsideViewController {
    
    FlipsideViewController *viewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    self.flipsideViewController = viewController;
    [viewController release];
        
    // Set up the navigation bar
    UINavigationBar *aNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    aNavigationBar.barStyle = UIBarStyleBlackOpaque;
    self.flipsideNavigationBar = aNavigationBar;
    [aNavigationBar release];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleView)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"PlistLoader"];
    navigationItem.rightBarButtonItem = buttonItem;
    [flipsideNavigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem release];
    [buttonItem release];
}


- (IBAction)toggleView {    
    /*
     This method is called when the info or Done button is pressed.
     It flips the displayed view from the main view to the flipside view and vice-versa.
     */
    if (flipsideViewController == nil) {
        [self loadFlipsideViewController];
    }

    UIView *mainView = mainViewController.view;
    UIView *flipsideView = flipsideViewController.view;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
    
    if ([mainView superview] != nil) {
        
        NSURL *newURL = [NSURL URLWithString:self.mainViewController.urlField.text];
        if (![[newURL absoluteString] isEqualToString:[[self.plistController remoteURL] absoluteString]])
        {
//            NSLog(@"New URL setting");
            [self.plistController setRemoteURL:newURL];
        }
        [self.plistController updateDataFromDisk];
        [self.plistController download];
        [self updateFlipsideViewTextFields];
        [flipsideViewController viewWillAppear:YES];
        [mainViewController viewWillDisappear:YES];
        [mainView removeFromSuperview];
        [infoButton removeFromSuperview];
        [self.view addSubview:flipsideView];
        [self.view insertSubview:flipsideNavigationBar aboveSubview:flipsideView];
        [mainViewController viewDidDisappear:YES];
        [flipsideViewController viewDidAppear:YES];

    } else {
        self.mainViewController.urlField.text = self.plistController.remoteURL.absoluteString;
    
        [mainViewController viewWillAppear:YES];
        [flipsideViewController viewWillDisappear:YES];
        [flipsideView removeFromSuperview];
        [flipsideNavigationBar removeFromSuperview];
        [self.view addSubview:mainView];
        [self.view insertSubview:infoButton aboveSubview:mainViewController.view];
        [flipsideViewController viewDidDisappear:YES];
        [mainViewController viewDidAppear:YES];
    }
    [UIView commitAnimations];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    plistController.delegate = nil;
    [plistController release];
    [infoButton release];
    [flipsideNavigationBar release];
    [mainViewController release];
    [flipsideViewController release];
    [super dealloc];
}


@end
