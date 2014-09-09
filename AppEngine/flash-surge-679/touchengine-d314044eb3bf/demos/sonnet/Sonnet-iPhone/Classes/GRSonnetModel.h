//
//  GRSonnetModel.h
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright 2008 New York University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GRSonnetModel : NSObject {
    NSURL *remoteURL;
    NSString *text;
    NSUInteger *number;
    
@private
    GRPlistController *plistController;
}

@property(nonatomic, retain)NSURL *remoteURL;
@property(nonatomic, copy)NSString *text;
@property(nonatomic, assign)NSUInteger *number;

- (void)load;
@end
