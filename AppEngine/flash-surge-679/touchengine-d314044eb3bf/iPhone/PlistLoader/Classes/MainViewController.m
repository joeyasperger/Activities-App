//
//  MainViewController.m
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "GRUtils.h"

@implementation MainViewController

@synthesize urlField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField { 
    LogMethod();
    return YES; 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField { 
    LogMethod();
    [textField resignFirstResponder]; 
    return NO; 
} 

/*
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
