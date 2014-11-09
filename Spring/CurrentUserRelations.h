//
//  CurrentUserRelations.h
//  Spring
//
//  Created by Joseph Asperger on 10/31/14.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CurrentUserRelations : NSObject

+ (void) downloadRelations;
+ (void) clearRelations;
+ (NSArray*) friends;
+ (NSArray*) recievedRequests;
+ (NSArray*) sentRequests;
+ (BOOL) hasDownloadedRelations;

@end
