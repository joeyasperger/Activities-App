//
//  GRContactUsViewController.h
//  Sonnet
//
//  Created by Jonathan Saggau on 11/16/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GRContactUsViewController : UIViewController <UIWebViewDelegate>  {
    UIWebView *webView;
    UIBarButtonItem *button;
    UIToolbar *toolbar;
}

@property(nonatomic, retain)IBOutlet UIWebView *webView;
@property(nonatomic, retain)IBOutlet UIBarButtonItem *button;
@property(nonatomic, retain)IBOutlet UIToolbar *toolbar;

-(void)dismiss;

@end
