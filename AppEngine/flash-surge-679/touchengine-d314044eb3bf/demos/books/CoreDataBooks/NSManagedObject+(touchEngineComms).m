//
//  NSManagedObject+(touchEngineComms).m
//  CoreDataBooks
//
//  Created by Jonathan Saggau on 9/25/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import "NSManagedObject+(touchEngineComms).h"


@implementation NSManagedObject (touchEngineComms)

-(void)setAttributesWithDictionary:(NSDictionary *)dictionary;
{
    //This might be (say) a little too promiscuous 
    for (NSString *key in [dictionary allKeys]) 
    {
        [self willChangeValueForKey:key];
    }
    
    for (NSString *key in [dictionary allKeys]) 
    {
        id value = [dictionary valueForKey:key];
        [self setPrimitiveValue:value forKey:key];
//        [self setValue:value forKey:key];
    }
    
    for (NSString *key in [dictionary allKeys]) 
    {
        [self didChangeValueForKey:key];
    }
}

@end
