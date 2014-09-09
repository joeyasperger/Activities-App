//
//  FlipsideViewController.h
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright Jonathan Saggau 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipsideViewController : UIViewController {
    IBOutlet UITextView *textView;
    IBOutlet UILabel *authorLabel;
    IBOutlet UILabel *linkLabel;
    IBOutlet UILabel *publisherLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *onlineLabel;
}

@property(nonatomic, retain)UITextView *textView;
@property(nonatomic, retain)UILabel *authorLabel;
@property(nonatomic, retain)UILabel *linkLabel;
@property(nonatomic, retain)UILabel *publisherLabel;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, retain)UILabel *onlineLabel;

@end
