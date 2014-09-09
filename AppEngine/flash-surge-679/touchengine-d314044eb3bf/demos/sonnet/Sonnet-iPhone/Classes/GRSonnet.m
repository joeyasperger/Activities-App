//
//  GRSonnet.m
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import "GRSonnet.h"


@implementation GRSonnet
    @synthesize romanNumeral;
    @synthesize text;

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Sonnet = %@ \n", romanNumeral];

    return desc;
}

- (void) dealloc
{
    [romanNumeral release]; romanNumeral = nil;
    [text release]; text = nil;
    [super dealloc];
}

@end
