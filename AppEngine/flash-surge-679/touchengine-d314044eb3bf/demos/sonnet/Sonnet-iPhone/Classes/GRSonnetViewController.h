//
//  GRSonnetViewController.h
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRSonnetView;
@class GRSonnet;
@class GRBackgroundImageView;

@interface GRSonnetViewController : UIViewController {
    GRSonnet *sonnet;
    IBOutlet UITextView *textView;
    IBOutlet GRBackgroundImageView *imageView;
}

@property(nonatomic, retain)GRSonnet *sonnet;
@property(nonatomic, retain)UITextView *textView;
@property(nonatomic, retain)GRBackgroundImageView *imageView;

@end
