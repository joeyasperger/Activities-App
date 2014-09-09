//
//  GRSonnet.h
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GRSonnet : NSObject {
    NSString *romanNumeral;
    NSString *text;
}

@property(nonatomic, copy)NSString *romanNumeral;
@property(nonatomic, copy)NSString *text;
@end
