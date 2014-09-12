//
//  TableDownloader.m
//  Spring
//
//  Created by Joseph Asperger on 9/11/14.
//
//

#import "TableDownloader.h"
#import "Activity.h"
#import "Friend.h"

@interface TableDownloader ()

@property NSMutableData* responseData;
@property NSString* urlString;
@property NSString* filename;
@property NSInteger type;

@end


@implementation TableDownloader

@synthesize responseData = _responseData;
@synthesize urlString = _urlString;
@synthesize filename = _filename;
@synthesize type = _type;
@synthesize delegate = _delegate;


-(id) initWithURL:(NSString*)url type:(NSInteger) type saveFile:(NSString *)file{
    if (self = [super init]){
        self.urlString = url;
        self.filename = file;
        self.type = type;
        self.responseData = [NSMutableData data];
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:self.urlString]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %ld bytes of data",(long)[self.responseData length]);
    
    NSString* pliststr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", pliststr);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathString = [documentsDirectory stringByAppendingPathComponent:self.filename];
    
    [pliststr writeToFile:pathString atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (self.type == ACTIVITY_DOWNLOADER){
        [self readActivityPlist:pathString];
    }
    else if (self.type == FRIEND_DOWNLOADER){
        [self readFriendPlist:pathString];
    }
    
    
}

- (void) readActivityPlist:(NSString*)pathString{
    NSMutableArray *activities = [NSMutableArray array];
    NSArray *plistActivities = [NSArray arrayWithContentsOfFile:pathString];
    for (int i = 0; i < [plistActivities count]; i++){
        NSDictionary *activityDict = [plistActivities objectAtIndex:i];
        Activity *activity = [Activity new];
        activity.activityID = [[activityDict valueForKey:@"activity_id"] integerValue];
        activity.name = [activityDict valueForKey:@"activity_name"];
        activity.categoryID = [[activityDict valueForKey:@"category_id"] integerValue];
        [activities addObject:activity];
    }
    
    //send back to delegate
    [self.delegate downloadCompleted:activities];
}

-(void) readFriendPlist:(NSString*)pathString{
    NSMutableArray *friends = [NSMutableArray array];
    NSArray *friendsPlist = [NSArray arrayWithContentsOfFile:pathString];
    for (int i = 0; i < [friendsPlist count]; i++){
        NSDictionary *friendDict = [friendsPlist objectAtIndex:i];
        Friend *newFriend = [Friend new];
        newFriend.userID = [[friendDict valueForKey:@"userID"] integerValue];
        newFriend.name = [friendDict valueForKey:@"username"];
        [friends addObject:newFriend];
    }
    [self.delegate downloadCompleted:friends];
}

@end
