//
//  GRBackgroundImageView.m
//  Sonnet
//
//  Created by Jonathan Saggau on 11/15/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import "GRBackgroundImageView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation GRBackgroundImageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [image drawInRect:rect];
}

//=========================================================== 
//  image 
//=========================================================== 
- (UIImage *)image
{
    //NSLog(@"in -image, returned image = %@", image);

    return image; 
}
- (void)setImage:(UIImage *)anImage
{
    //NSLog(@"in -setImage:, old value of image: %@, changed to: %@", image, anImage);

    if (image != anImage) {
        [anImage retain];
        [image release];
        image = anImage;
        [self setNeedsDisplay];
    }
}

- (void)dealloc {
    [image release]; image = nil;
    [super dealloc];
}


@end
