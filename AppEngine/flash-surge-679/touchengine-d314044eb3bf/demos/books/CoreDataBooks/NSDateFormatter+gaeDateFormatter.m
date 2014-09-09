//
//  NSDateFormatter+gaeDateFormatter.m
//  CoreDataBooks
//
//  Created by Jonathan Saggau on 9/26/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import "NSDateFormatter+gaeDateFormatter.h"

//2010-09-26 15:51:33
static NSString *dateFormatString = @"yyyy-MM-d H:mm:ss";

//Yup, it's leaked.  Because we'll reuse it constantly and building
//date formatters takes a dog's age.
static NSDateFormatter *kGaeDateFormatter;

@implementation NSDateFormatter (gaeDateFormatter)

+(NSDateFormatter *)gaeDateFormatter
{
    if (!kGaeDateFormatter) 
    {
        kGaeDateFormatter = [[NSDateFormatter alloc] init];
        [kGaeDateFormatter setDateFormat:dateFormatString];
    }
    return kGaeDateFormatter;
}

@end
