//
//  GRPlistModel.h
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import <UIKit/UIKit.h>

// forwards setValue:forUnknownKeyKey to a dictionary
// if promiscuous (usually a bad idea), it forwards any setValue 
// to any key.  Otherwise, it only sets keys that have been defined
// in the plist
@interface GRPlistModel : NSObject 
{
    BOOL promiscuous;
@private
    NSMutableDictionary *plistDictRep;
}

@property(nonatomic, getter=isPromiscuous)BOOL promiscuous;
@property(nonatomic, readonly)NSDictionary *plist;

+(GRPlistModel *)plistModelWithContentsOfFile:(NSString *)aPath;
+(GRPlistModel *)plistModelWithContentsOfURL:(NSURL *)aUrl;
+(GRPlistModel *)plistModelWithDictionary:(NSDictionary *)aDict;

//Designated initializer
-(id)initWithDictionary:(NSDictionary *)aDict;
-(id)initWithContentsOfFile:(NSString *)aPath;
-(id)initWithContentsOfURL:(NSURL *)aUrl;

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag;
- (BOOL)writeToURL:(NSURL *)aURL atomically:(BOOL)flag;

- (BOOL)contentsEqualToDictionary:(NSDictionary *)aDict;
- (void)setContentsFromDictionary:(NSDictionary *)aDict;

- (void)setPlistRepValue:(id)aPlistRepValue forKey:(id)aKey;
- (void)removePlistRepValueForKey:(id)aKey;

-(NSMutableDictionary *)plistDictRep;
@end
