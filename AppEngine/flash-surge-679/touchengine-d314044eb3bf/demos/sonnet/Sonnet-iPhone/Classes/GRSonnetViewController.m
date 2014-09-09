//
//  GRSonnetViewController.m
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#define SONNET_FONT_SMALL (10)
#define SONNET_FONT_LARGE (13)

#import "GRSonnetViewController.h"
#import "GRBackgroundImageView.h"
#import "GRUtils.h"
#include <math.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface GRSonnetViewController (private)

- (void)updateRotation:(UIInterfaceOrientation)toInterfaceOrientation;

@end


@implementation GRSonnetViewController
@synthesize textView;
@synthesize imageView;

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view.
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self updateRotation: self.interfaceOrientation];
//}

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

- (void)updateRotation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        self.imageView.image = [UIImage imageNamed:@"bigBackground.png"];
        [self.textView setFont:[UIFont fontWithName:@"Zapfino" size:SONNET_FONT_SMALL]];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"bigBackgroundRotated.png"];
        [self.textView setFont:[UIFont fontWithName:@"Zapfino" size:SONNET_FONT_LARGE]];

    }
    [self.view setNeedsDisplay];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration; // Notification of rotation beginning.
{
    [self updateRotation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations

    return (interfaceOrientation == UIInterfaceOrientationPortrait | 
                                    UIDeviceOrientationLandscapeRight | 
                                    UIDeviceOrientationLandscapeLeft);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


//=========================================================== 
//  sonnet 
//=========================================================== 
- (GRSonnet *)sonnet
{
    //NSLog(@"in -sonnet, returned sonnet = %@", sonnet);

    return sonnet; 
}
- (void)setSonnet:(GRSonnet *)aSonnet
{
//    NSLog(@"GRSonnetView Controller in -setSonnet:, old value of sonnet: %@, changed to: %@", sonnet, aSonnet);
    if (sonnet != aSonnet) {
        [aSonnet retain];
        [sonnet release];
        sonnet = aSonnet;
        [self.view setNeedsLayout];
        self.textView.text = [sonnet text];
    }
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [imageView release]; imageView = nil;
    [sonnet release]; sonnet = nil;
    [textView release]; textView = nil;
    [super dealloc];
}


@end
