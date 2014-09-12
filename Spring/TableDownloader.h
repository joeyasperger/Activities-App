//
//  TableDownloader.h
//  Spring
//
//  Created by Joseph Asperger on 9/11/14.
//
//

#import <Foundation/Foundation.h>

#define ACTIVITY_DOWNLOADER 1
#define FRIEND_DOWNLOADER 2

@protocol TableDownloaderDelegate

-(void) downloadCompleted:(NSMutableArray*)array;

@end


@interface TableDownloader : NSObject

-(id) initWithURL:(NSString*)url type:(NSInteger) type saveFile:(NSString*)file;

@property id delegate;

@end
