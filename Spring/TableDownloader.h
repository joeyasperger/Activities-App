//
//  TableDownloader.h
//  Spring
//
//  Created by Joseph Asperger on 9/11/14.
//
//

#import <Foundation/Foundation.h>


@interface TableDownloader : NSObject

-(void) initWithURL:(NSString*)url type:(NSInteger) type finishedSelector:(SEL)finishedSelector saveFile:(NSString*)file;

@end
