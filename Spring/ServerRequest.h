//
//  ServerRequest.h
//  Spring
//
//  Created by Joseph Asperger on 9/15/14.
//
//

#import <Foundation/Foundation.h>

#define EDIT_INTERESTS_REQUEST 1

@interface ServerRequest : NSObject

@property NSInteger type;

- (id) initWithType:(NSInteger)type;

@end
