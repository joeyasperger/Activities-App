//
//  GAECommunicator.m
//  CoreDataBooks
//
//  Created by Jonathan Saggau on 9/25/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import "GAECommunicator.h"
#import "AAPLReachability.h"
#import "GTMHTTPFetcher.h"

static NSString *kGAECommunicatorFetchNameKey = @"kGAECommunicatorFetchNameKey";
static NSString *kGAECommunicatorFetchObjectIDKey = @"kGAECommunicatorFetchObjectIDKey";

@interface GAECommunicator ()

-(void)updateNetworkStatus;
-(void)startFetching;
-(void)fetchNext;
-(void)stopFetching;

@property(nonatomic, readwrite, copy)NSString *remoteHost;
@property(nonatomic, readwrite, copy)NSString *plistPath;
@property(nonatomic, readwrite, assign)NetworkStatus remoteHostStatus;
@property(nonatomic, readwrite, assign)NetworkStatus internetConnectionStatus;
@property(nonatomic, readwrite, assign)NetworkStatus localWiFiConnectionStatus;

@property(nonatomic, retain)NSMutableArray *downloadQueue;
@property(nonatomic, retain)GTMHTTPFetcher *fetcher;
@property(nonatomic, retain)NSDictionary *metadataOnTheWay;

///////  downloadQueue  ///////
- (void)addObjectToDownloadQueue:(id)obj;
- (NSUInteger)countOfDownloadQueue;
- (void)getDownloadQueue:(id *)buffer range:(NSRange)inRange;
- (id)objectInDownloadQueueAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inDownloadQueueAtIndex:(NSUInteger)idx;
- (void)insertDownloadQueue:(NSArray *)downloadQueueArray atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectFromDownloadQueueAtIndex:(NSUInteger)idx;
- (void)removeDownloadQueueAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDownloadQueueAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)replaceDownloadQueueAtIndexes:(NSIndexSet *)indexes withDownloadQueue:(NSArray *)downloadQueueArray;

- (GTMHTTPFetcher *)fetcher;
- (void)setFetcher:(GTMHTTPFetcher *)aFetcher;

@end

#pragma mark -
@implementation GAECommunicator

-(id)initWithremoteHost:(NSString *)host plistPath:(NSString *)path;
{
    self = [super init];
    if (self != nil) {
        [self setRemoteHost:host];
        [self setPlistPath:path];
        [self setDownloadQueue:[NSMutableArray array]];
    }
    return self;
}

-(void)startFetching
{
    //If we can see the host, will start fetching automatically.
    [self updateNetworkStatus];
}

-(void)fetchNext;
{
    if (![self fetcher]) 
    {
        NSDictionary *fetchMetaData = [[self downloadQueue] lastObject];
        if (fetchMetaData) 
        {
            NSString *remote = [self remoteHost];
            NSString *path = [self plistPath];
            NSString *objectName = [fetchMetaData objectForKey:kGAECommunicatorFetchNameKey];
            NSString *objectID = [fetchMetaData objectForKey:kGAECommunicatorFetchObjectIDKey];
            
            NSString *urlString = [NSString stringWithFormat:@"http://%@/%@/", remote, path];
            if (nil != objectName) 
            {
                urlString = [urlString stringByAppendingFormat:@"%@/", objectName];
            }
            
            if (nil != objectID) 
            {
                urlString = [urlString stringByAppendingFormat:@"%@/", objectName];
            }
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            GTMHTTPFetcher *aFetcher = [[GTMHTTPFetcher alloc] initWithRequest:request];
            [self setMetadataOnTheWay:fetchMetaData];
            [[self downloadQueue] removeLastObject];
            [aFetcher beginFetchWithDelegate:self
                           didFinishSelector:@selector(fetcher:finishedWithData:error:)];
            [self setFetcher:aFetcher];
            [aFetcher release];                                  
        }
    }
}   

-(void)fetchObjectNamed:(NSString *)aName objectID:(NSString *)anObjectID
{
    NSLog(@"[%@ fetchObjectNamed:%@ objectID:%@]", self, aName, anObjectID);
    NSMutableDictionary *fetchMetaData = [NSMutableDictionary dictionaryWithCapacity:2];
    if (aName) {
        [fetchMetaData setObject:aName forKey:kGAECommunicatorFetchNameKey];
    }
    
    if (anObjectID) {
        [fetchMetaData setObject:anObjectID forKey:kGAECommunicatorFetchObjectIDKey];
    }

    [self addObjectToDownloadQueue:fetchMetaData];
    [self startFetching];
}

-(void)fetchUser
{
    //TODO: make touchengine know what to do with this
    //[self fetchObjectNamed:@"user" objectID:nil];
}

-(void)stopFetching
{
    [self.fetcher setDelegate:nil];
    [self.fetcher stopFetching];
    [self setFetcher:nil];
}

-(void)cancelFetches
{
    [self stopFetching];
    [self.downloadQueue removeAllObjects];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    reachabilityIsActive = YES;
    [self updateNetworkStatus];
}

-(void)fetcher:(GTMHTTPFetcher *)aFetcher finishedWithData:(NSData *)data error:(NSError *)error;
{
    NSAssert(fetcher == self.fetcher, @"We are not supposed to be the delegate of a fetcher other than our own");
    NSString *objectName = [metadataOnTheWay objectForKey:kGAECommunicatorFetchNameKey];
    NSString *objectID = [metadataOnTheWay objectForKey:kGAECommunicatorFetchObjectIDKey];
    if (nil != error) 
    {
        if (delegate && [delegate respondsToSelector:@selector(communicator:didFailFetching:forObjectNamed:objectID:)]) 
        {
            [delegate communicator:self
                   didFailFetching:error
                    forObjectNamed:objectName
                          objectID:objectID];
        }
    }
    else if (nil != data && [data length] > 0)
    {
        if (delegate && [delegate respondsToSelector:@selector(communicator:didFinishFetching:forObjectNamed:objectID:)]) 
        {
            [delegate communicator:self
                   didFinishFetching:data
                    forObjectNamed:objectName
                          objectID:objectID];
        }
    }
    else 
    {
        NSAssert(NO, @"There should be an error or a populated data object");
    }
    [self setFetcher:nil]; //we'll make a new one each time around
    [self setMetadataOnTheWay:nil];
    [self performSelector:@selector(fetchNext) withObject:nil afterDelay:0.0];
}

- (void)updateNetworkStatus
{
    static BOOL inited;
    if(!inited)
    {
        NSLog(@"Init network status");
        //if this is the first time through, we init reachability and bail.
        //it will call us back once with correct reachability info shortly.
        inited = YES;
        // Use Apple's Reachability Class to check the reachability of a remote host (docs.google.com) or by using an IP address. 
        [[AAPLReachability sharedReachability] setHostName:[self remoteHost]];
        //[[AAPLReachability sharedReachability] setAddress:@"0.0.0.0"];
        
        // Use asynchronous network status changes.
        [[AAPLReachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
        
        // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
        // method "reachabilityChanged" will be called. 
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(reachabilityChanged:) 
                                                     name:@"kNetworkReachabilityChangedNotification" 
                                                   object:nil];
    }
    
    if(reachabilityIsActive)
    {
        NSLog(@"Check network status.");
        // Query the SystemConfiguration framework for the state of the device's network connections.
        self.remoteHostStatus           = [[AAPLReachability sharedReachability] remoteHostStatus];
        self.internetConnectionStatus	= [[AAPLReachability sharedReachability] internetConnectionStatus];
        self.localWiFiConnectionStatus	= [[AAPLReachability sharedReachability] localWiFiConnectionStatus];
        if ([self remoteHostStatus] > 0) 
        {
            //start fetching if we can reach the host
            [self fetchNext];
        }
        else 
        {
            //stop fetching if we can't
            [self stopFetching];
        }        
    }
    else
    {
        NSLog(@"reachability not ready yet");
        
        //AAPLReachability needs to do one "throw away" query before it starts 
        //really working...
        [[AAPLReachability sharedReachability] remoteHostStatus];
        [[AAPLReachability sharedReachability] internetConnectionStatus];
        [[AAPLReachability sharedReachability] localWiFiConnectionStatus];
    }
}

#pragma mark -
#pragma mark Accessors

///////  downloadQueue  ///////
-(void)addObjectToDownloadQueue:(id)obj
{
    [[self downloadQueue] addObject:obj];
}

- (NSUInteger)countOfDownloadQueue 
{
    return [[self downloadQueue] count];
}

- (void)getDownloadQueue:(id *)buffer range:(NSRange)inRange 
{
    [[self downloadQueue] getObjects:buffer range:inRange];
}

- (id)objectInDownloadQueueAtIndex:(NSUInteger)idx 
{
    id myDownloadQueue = [self downloadQueue];
    NSUInteger downloadQueueCount = [myDownloadQueue count];
    if ( downloadQueueCount == 0 || idx > (downloadQueueCount - 1) ) return nil;
    
    return [myDownloadQueue objectAtIndex:idx];
}

- (void)insertObject:(id)anObject inDownloadQueueAtIndex:(NSUInteger)idx 
{
    id myDownloadQueue = [self downloadQueue];
    NSUInteger downloadQueueCount = [myDownloadQueue count];
    if (idx > downloadQueueCount) return;
    
    if (anObject) [myDownloadQueue insertObject:anObject atIndex:idx];
}

- (void)insertDownloadQueue:(NSArray *)downloadQueueArray atIndexes:(NSIndexSet *)indexes 
{
    [[self downloadQueue] insertObjects:downloadQueueArray atIndexes:indexes];
}

- (void)removeObjectFromDownloadQueueAtIndex:(NSUInteger)idx 
{
    id myDownloadQueue = [self downloadQueue];
    NSUInteger downloadQueueCount = [myDownloadQueue count];
    if ( downloadQueueCount == 0 || idx > (downloadQueueCount - 1) ) return;
    
    [myDownloadQueue removeObjectAtIndex:idx];
}

- (void)removeDownloadQueueAtIndexes:(NSIndexSet *)indexes 
{
    [[self downloadQueue] removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInDownloadQueueAtIndex:(NSUInteger)idx withObject:(id)anObject 
{
    id myDownloadQueue = [self downloadQueue];
    NSUInteger downloadQueueCount = [myDownloadQueue count];
    if ( downloadQueueCount == 0 || idx > (downloadQueueCount - 1) ) return;
    
    [myDownloadQueue replaceObjectAtIndex:idx withObject:anObject];
}

- (void)replaceDownloadQueueAtIndexes:(NSIndexSet *)indexes withDownloadQueue:(NSArray *)downloadQueueArray 
{
    [[self downloadQueue] replaceObjectsAtIndexes:indexes withObjects:downloadQueueArray];
}

@synthesize plistPath;
@synthesize remoteHost;
@synthesize remoteHostStatus;
@synthesize internetConnectionStatus;
@synthesize localWiFiConnectionStatus;
@synthesize fetcher;
@synthesize downloadQueue;
@synthesize metadataOnTheWay;
@synthesize delegate;

- (void) dealloc
{
    delegate = nil;
    [remoteHost release]; remoteHost = nil;
    [plistPath release]; plistPath = nil;
    [downloadQueue release]; downloadQueue = nil;
    [fetcher release]; fetcher = nil;
    [metadataOnTheWay release]; metadataOnTheWay = nil;
    [super dealloc];
}


@end
