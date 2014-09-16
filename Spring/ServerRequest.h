//
//  ServerRequest.h
//  Spring
//
//  Created by Joseph Asperger on 9/15/14.
//
//

#import <Foundation/Foundation.h>

@interface ServerRequest : NSObject

@property NSMutableData *responseData;
- (id) initPostWithURL:(NSString*)url content:(NSString*)content;

@end
