//
//  RootViewController.m
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import "RootViewController.h"
#import "SonnetAppDelegate.h"
#import "GRSonnetRootTableCell.h"
#import "GRSonnetViewController.h"
#import "GRContactUsViewController.h"
#import "GRPlistController.h"
#import "GRPlistModel.h"
#import "GRSonnet.h"
#import "GRUtils.h"

#define MAIN_FONT_SMALL (9)
#define MAIN_FONT_LARGE (12)

#define LABEL_FONT_SMALL (11)
#define LABEL_FONT_LARGE (14)

#define PORTRAIT_ROW_HEIGHT (120.0)
#define LANDSCAPE_ROW_HEIGHT (146.0)

static NSString *fallbackPositionPlistPath = @"SonnetsDefault.plist";

@interface RootViewController (private)

-(void) updateSonnets;
-(void) inspectSonnet:(GRSonnet *)sonnet;
-(void) updateSonnetsFromModel;
-(void) updateRotation:(UIInterfaceOrientation)toInterfaceOrientation;

@end

@implementation RootViewController

@synthesize sonnets;
@synthesize sonnetsController;
@synthesize updatingSonnets;
@synthesize sonnetViewController;
@synthesize contactUsViewController;

+ (NSString *)defaultURL
{
    NSString *defaultURL = [NSString stringWithString:APPENGINE_URL];
    defaultURL =  [defaultURL stringByAppendingString:@"plists/sonnets"];
    return defaultURL;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    NSString *rootURL = [[self class] defaultURL];
    self.sonnetsController = [[[GRPlistController alloc] initWithRemoteURL:[NSURL URLWithString:rootURL]] autorelease];
    self.sonnetsController.delegate = self;
    
    [self.sonnetsController updateDataFromDisk];
    self.sonnets = nil;
    
    //pull info from disk
    [self updateSonnetsFromModel];
    
    //Put the little "contact the dev" icon up... 
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithTitle:@"Info." style:UIBarButtonItemStylePlain target:self action:@selector(showInfoView:)];
    self.navigationItem.rightBarButtonItem = composeItem;  
    [composeItem release];
    [self.tableView setSeparatorColor:[UIColor grayColor]];
    //hit the web for new information
    [self updateSonnets];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self updateRotation: self.interfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self updateRotation: self.interfaceOrientation];
}

-(IBAction)showInfoView:(id)sender;
{
    if (self.contactUsViewController == nil) {
        GRContactUsViewController *viewController = [[GRContactUsViewController alloc] initWithNibName:@"GRContactUsViewController" bundle:nil];
        self.contactUsViewController = viewController;
        [viewController release];
    }
    [self.navigationController presentModalViewController:self.contactUsViewController animated:YES];
}

-(void) inspectSonnet:(GRSonnet *)sonnet;
{
    //NSLog(@"Sonnet to inspect = %@", sonnet);
    // Create the detail view lazily
    if (sonnetViewController == nil) {
        GRSonnetViewController *viewController = [[GRSonnetViewController alloc] initWithNibName:@"GRSonnetViewController" bundle:nil];
        self.sonnetViewController = viewController;
        [viewController release];
    }
    self.sonnetViewController.sonnet = sonnet;
    [self.navigationController pushViewController:self.sonnetViewController animated:YES];
}

-(void) updateSonnets;
{
    if (self.updatingSonnets)
    {
        [self.sonnetsController cancelDownload];
    }
    self.updatingSonnets = YES;
    [self.sonnetsController download];
}

#pragma mark GRPlistController Delegate methods
- (BOOL)listControllerShouldDownloadRemoteData:(GRPlistController *)listController;
{
    return YES;
}

// if the data from the server has changed...
- (void)listControllerDataWillChange:(GRPlistController *)listController;
{
    //    LogMethod();
}

- (void)loadSonnetsFromArray:(NSArray *)sonnetsArray
{
    NSMutableArray *newSonnetsArray = [NSMutableArray arrayWithCapacity:[sonnetsArray count]];
    GRSonnet *currentSonnet;
    for (NSArray *sonnetArray in sonnetsArray) {
        currentSonnet = [[GRSonnet alloc] init];
        currentSonnet.romanNumeral = [sonnetArray objectAtIndex:0];
        currentSonnet.text = [sonnetArray objectAtIndex:1];
        [newSonnetsArray addObject:currentSonnet];
        [currentSonnet release];
    }
    self.sonnets = [NSArray arrayWithArray:newSonnetsArray];
}

- (void)loadSonnetsFromBundle
{
    //LogMethod();
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fallbackPositionPlistPath];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *sonnetsArray = [plistDict valueForKeyPath:@"verses"];
    [self loadSonnetsFromArray:sonnetsArray];
}

- (void)updateSonnetsFromModel
{
    NSArray *sonnetsArray = [self.sonnetsController.model valueForKeyPath:@"verses"];
    if (!IsEmpty(sonnetsArray))
    {
        [self loadSonnetsFromArray:sonnetsArray];
        //LogMethod();
    }
    else 
    {
        [self loadSonnetsFromBundle];
    }
}

- (void)listControllerDataDidChange:(GRPlistController *)listController;
{
    //LogMethod();
    [self updateSonnetsFromModel];
    [self.tableView reloadData];
}

- (void)listController:(GRPlistController *)listController downloadDidFailWithError:(NSError *)err;
{
    //LogMethod();
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
        return;
    }
    // other errors are connection failures.  If the sonnets array is empty the UI will be empty.
    // we'll err here to keep from totally confusing the user.
    if (IsEmpty(self.sonnets))
    {
        if (self.sonnetsController.remoteHostStatus <= 0)
        {
            NSDictionary *uInfo = [err userInfo];
            NSString *url = [uInfo valueForKey:@"url"];        
            NSString *msg = [NSString stringWithFormat:@"Could not connect to %@", url];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failure" message:msg
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];    
            [alert release];
            return;
        }
    }
}


#pragma mark UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.sonnets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"GRRootTableCell";
    GRSonnetRootTableCell *viewCell = (GRSonnetRootTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (viewCell == nil) {
        viewCell = [[[GRSonnetRootTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    int sonnetIndex = indexPath.row;
    GRSonnet *sonnetAtIndex = [self.sonnets objectAtIndex: sonnetIndex];
    viewCell.sonnet = sonnetAtIndex;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        viewCell.sonnetTextFont = [UIFont fontWithName:@"Zapfino" size:MAIN_FONT_SMALL];
        viewCell.leftSideLabelFont = [UIFont fontWithName:@"Zapfino" size:LABEL_FONT_SMALL];
    } else
    {
        viewCell.sonnetTextFont = [UIFont fontWithName:@"Zapfino" size:MAIN_FONT_LARGE];
        viewCell.leftSideLabelFont = [UIFont fontWithName:@"Zapfino" size:LABEL_FONT_LARGE];
    }
    return viewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
	int sonnetIndex = indexPath.row;
    GRSonnet *sonnetAtIndex = [self.sonnets objectAtIndex: sonnetIndex];
    [self inspectSonnet:sonnetAtIndex];
}

#pragma mark Rotation
- (void) updateRotation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //For some reason, it seems [tableview reloadData] is not refreshing cells on screen
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        [self.tableView setRowHeight:PORTRAIT_ROW_HEIGHT];
    } else
    {
        [self.tableView setRowHeight:LANDSCAPE_ROW_HEIGHT];
    }
    [self.tableView reloadData];

    NSArray *vizCells = [self.tableView visibleCells];
    for (GRSonnetRootTableCell *viewCell in vizCells) {
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
        {
            viewCell.sonnetTextFont = [UIFont fontWithName:@"Zapfino" size:MAIN_FONT_SMALL];
            viewCell.leftSideLabelFont = [UIFont fontWithName:@"Zapfino" size:LABEL_FONT_SMALL];
            [self.tableView setRowHeight:PORTRAIT_ROW_HEIGHT];
        } else
        {
            viewCell.sonnetTextFont = [UIFont fontWithName:@"Zapfino" size:MAIN_FONT_LARGE];
            viewCell.leftSideLabelFont = [UIFont fontWithName:@"Zapfino" size:LABEL_FONT_LARGE];
            [self.tableView setRowHeight:LANDSCAPE_ROW_HEIGHT];
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration; // Notification of rotation beginning.
{
    [self updateRotation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait | 
            UIDeviceOrientationLandscapeRight | 
            UIDeviceOrientationLandscapeLeft);
}

#pragma mark Accessors

//=========================================================== 
//  sonnets 
//=========================================================== 
- (NSArray *)sonnets
{    
    return sonnets; 
}
- (void)setSonnets:(NSArray *)aPlists
{
    if (self.updatingSonnets)
    {
        [self.sonnetsController cancelDownload];
    }
    
    if (sonnets != aPlists) {
        [aPlists retain];
        [sonnets release];
        sonnets = aPlists;
    }
    [self.tableView reloadData];
}

//=========================================================== 
//  plistController 
//=========================================================== 
- (GRPlistController *)sonnetsController
{
    //NSLog(@"in -plistController, returned plistController = %@", plistController);
    
    return sonnetsController; 
}
- (void)setSonnetsController:(GRPlistController *)aPlistController
{
    //NSLog(@"in -setPlistController:, old value of plistController: %@, changed to: %@", plistController, aPlistController);
    
    if (sonnetsController != aPlistController) 
    {
        [aPlistController retain];
        [sonnetsController release];
        sonnetsController = aPlistController;
    }
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{

    [sonnets release]; sonnets = nil;
    [sonnetsController release]; sonnetsController = nil;
    [sonnetViewController release]; sonnetViewController = nil;
    [contactUsViewController release]; contactUsViewController = nil;
    [super dealloc];
}

@end

