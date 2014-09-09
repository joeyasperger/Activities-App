//
//  QuickFetchViewController.h
//  Authentication
//
//  Created by jonathan on 9/11/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTMHTTPFetcher;
@interface QuickFetchViewController : UIViewController {
    UITextView *textView;
    NSString *token;
@private
    GTMHTTPFetcher *fetcher;
}

@property(nonatomic, copy)NSString *token;
@property(nonatomic, retain)IBOutlet UITextView *textView;

@end
