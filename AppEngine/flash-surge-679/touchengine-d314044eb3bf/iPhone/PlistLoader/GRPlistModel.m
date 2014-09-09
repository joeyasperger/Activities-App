//
//  GRPlistModel.m
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import "GRPlistModel.h"

@interface GRPlistModel (private)

- (BOOL)promiscuous;
- (void)setPromiscuous:(BOOL)flag;
- (NSMutableDictionary *)plistRep;
- (void)setPlistRep:(NSMutableDictionary *)aPlistRep;
- (void)setPlistRepValue:(id)aPlistRepValue forKey:(id)aKey;
- (void)removePlistRepValueForKey:(id)aKey;

@end

@implementation GRPlistModel

+(GRPlistModel *)plistModelWithContentsOfFile:(NSString *)aPath;
{
    GRPlistModel *aModel = [[GRPlistModel alloc] initWithContentsOfFile:aPath];
    return [aModel autorelease];
}

+(GRPlistModel *)plistModelWithContentsOfURL:(NSURL *)aUrl;
{
    GRPlistModel *aModel = [[GRPlistModel alloc] initWithContentsOfURL:aUrl];
    return [aModel autorelease];
}

+(GRPlistModel *)plistModelWithDictionary:(NSDictionary *)aDict;
{
    GRPlistModel *aModel = [[GRPlistModel alloc] initWithDictionary:aDict];
    return [aModel autorelease];
}

- (id) init
{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    self = [self initWithDictionary:aDict];
    return self;
}

-(id)initWithContentsOfFile:(NSString *)aPath;
{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithContentsOfFile:aPath];
    self = [self initWithDictionary:aDict];
    return self;
}

-(id)initWithContentsOfURL:(NSURL *)aUrl;
{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithContentsOfURL:aUrl];
    self = [self initWithDictionary:aDict];
    return self;
}

-(id)initWithDictionary:(NSDictionary *)aDict;
{
    self = [super init];
    if (self != nil) {
        if (nil != aDict)
            self.plistRep = [NSMutableDictionary dictionaryWithDictionary:aDict];
        else
            self.plistRep = [NSMutableDictionary dictionary];
        self.promiscuous = NO;
    }
    return self;
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag;
{
    BOOL success = [[self plistRep] writeToFile:path atomically:flag];
    return success;
}

- (BOOL)writeToURL:(NSURL *)aURL atomically:(BOOL)flag;
{
    BOOL success = [[self plistRep] writeToURL:aURL atomically:flag];
    return success;
}

- (BOOL)contentsEqualToDictionary:(NSDictionary *)aDict;
{
    BOOL contentsEqualToDictionary = [[self plistRep] isEqualToDictionary:aDict];
    return contentsEqualToDictionary;
}

- (void)setContentsFromDictionary:(NSDictionary *)aDict;
{

    //if currents are not equal to new contents:
        //recursively traverse dictionary and reset changed values
        //for keypaths.  KVO notifying for changed keypaths along the way.
        
    //initial implementation just changes the whole dictionary
        
    if (![self contentsEqualToDictionary:aDict])
    {
        [self setPlistRep:[NSMutableDictionary dictionaryWithDictionary:aDict]];
    }
}

- (id)valueForUndefinedKey:(NSString *)key;
{
    id someValue = [self.plistRep valueForKey:key];
    return someValue;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
{
    //if promiscuous, forward the value on to the dictionary
    if (self.promiscuous)
    {
        [self setPlistRepValue:value forKey:key];
        return;
    }
    
    //if !promiscuous, verify that there is a key in the plistRep
    NSArray *keys = [plistDictRep allKeys];
    if ([keys containsObject:key])
    {
        [self setPlistRepValue:value forKey:key];
        return;
    }
    
    NSAssert(NO, @"can't set value for undefined key if not promiscuous");
}

- (void)setNilValueForKey:(NSString *)theKey 
{
    if ([theKey isEqualToString:@"promiscuous"])
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"promiscuous"];
    else 
        [super setNilValueForKey:theKey];
}

- (void)setPlistRepValue:(id)aPlistRepValue forKey:(id)aKey
{
    [[self plistRep] setObject:aPlistRepValue forKey:aKey];
}
- (void)removePlistRepValueForKey:(id)aKey
{
    [[self plistRep] removeObjectForKey:aKey];
}


//=========================================================== 
//  promiscuous 
//=========================================================== 
- (BOOL)promiscuous
{
    //NSLog(@"in -promiscuous, returned promiscuous = %@", promiscuous ? @"YES": @"NO" );
    
    return promiscuous;
}
- (void)setPromiscuous:(BOOL)flag
{
    //NSLog(@"in -setPromiscuous, old value of promiscuous: %@, changed to: %@", (promiscuous ? @"YES": @"NO"), (flag ? @"YES": @"NO") );
    
    promiscuous = flag;
}

//=========================================================== 
//  plistRep 
//=========================================================== 
- (NSMutableDictionary *)plistRep
{
    //NSLog(@"in -plistRep, returned plistRep = %@", plistRep);
    
    return plistDictRep; 
}
- (void)setPlistRep:(NSMutableDictionary *)aPlistRep
{
    //NSLog(@"in -setPlistRep:, old value of plistRep: %@, changed to: %@", plistRep, aPlistRep);
    
    if (plistDictRep != aPlistRep) {
        [aPlistRep retain];
        [plistDictRep release];
        plistDictRep = aPlistRep;
    }
}
- (NSDictionary *)plist
{
    NSDictionary *plist = [NSDictionary dictionaryWithDictionary:plistDictRep];
    return plist;
}


-(NSMutableDictionary *)plistDictRep;
{
    return  plistDictRep;
}
//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [plistDictRep release]; plistDictRep = nil;
    [super dealloc];
}

@end
