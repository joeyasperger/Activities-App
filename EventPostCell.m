//
//  EventPostCell.m
//  Spring
//
//  Created by Joseph Asperger on 11/9/14.
//
//

#import "EventPostCell.h"

@implementation EventPostCell

- (void)setFrame:(CGRect)frame {
    int inset = 10;
    int heightInset = 0;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    frame.origin.y += heightInset;
    frame.size.height -= 2 * heightInset;
    [super setFrame:frame];
}

@end
