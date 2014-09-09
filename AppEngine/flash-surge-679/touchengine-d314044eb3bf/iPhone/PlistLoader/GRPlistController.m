//
//  GRPlistController.m
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import "GRPlistController.h"
#import "GRPlistModel.h"
#import "GRUtils.h"
#import "NSString+UUID.h"

@interface GRPlistController (private)

- (NSString *)localPathForRemoteURL;
- (NSString *)localPlistIndexPath;
- (NSMutableDictionary *)plistIndex;
- (void)setPlistIndex:(NSMutableDictionary *)aPlistIndex;
- (void)setPlistIndexObject:(id)aPlistIndexObject forKey:(id)aKey;
- (void)removePlistIndexObjectForKey:(id)aKey;
- (void)updateDataFromDictionary:(NSDictionary *)dictionary;
- (void)startDownloadingURL;
- (void)reportDownloadErrorOfType:(GRErrorCode)errorCode userInfo:(NSDictionary *)uInfo;
- (void)savePlistIndex;

@end

//heh private property.  GET OFF MY LAWN!
@interface GRPlistController ()

@property(nonatomic, assign)BOOL hostIsReachable;
@property(nonatomic, retain)GRPlistModel *_model;
@property(nonatomic, retain)NSMutableDictionary *plistIndex;
@property(nonatomic, retain)NSMutableData *receivedData;
@property(nonatomic, retain)NSURLConnection *connection;
@property(nonatomic, assign)GRDataSource dataSource;

@end


@implementation GRPlistController

@synthesize delegate;
@synthesize remoteURL;
@synthesize localWiFiConnectionStatus;
@synthesize internetConnectionStatus;
@synthesize remoteHostStatus;
@synthesize hostIsReachable;
@synthesize loadingData;
@synthesize receivedData;
@synthesize connection;

//Designated initializer
- (id)initWithRemoteURL:(NSURL *)aRemoteURL;
{
    self = [super init];
    if (self != nil) {
        self.hostIsReachable = NO;        
        self._model = nil; //we'll make this when we need it.
        self.remoteURL = aRemoteURL; // this makes the local index as well.
        
        NSMutableDictionary *localPlistDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self localPlistIndexPath]];
        if (nil == localPlistDict)
        {
            localPlistDict = [NSMutableDictionary dictionary];
        }
        self.dataSource = kGRPlistNoneDataSource;
        self.plistIndex = localPlistDict;
        [self savePlistIndex];
        
        [[Reachability sharedReachability] setHostName:[aRemoteURL host]];
    }
    return self;
}

- (id) init
{
    NSURL *defaultUrl = [NSURL URLWithString:APPENGINE_URL];
    self = [self initWithRemoteURL:defaultUrl];
    return self;
}

#pragma mark Data updates

-(void)updateHostandNetworkStatus
{
    self.remoteHostStatus           = [[Reachability sharedReachability] remoteHostStatus];
    self.internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
    self.localWiFiConnectionStatus	= [[Reachability sharedReachability] localWiFiConnectionStatus];
}

- (void)updateDataFromDictionary:(NSDictionary *)newData
{
    if (nil == newData)
        newData = [NSDictionary dictionary];
        
    if (!([[self model] contentsEqualToDictionary:newData]))
    {
        //notify delegate that we're gonna change the data
        if (nil != delegate && [delegate respondsToSelector:@selector(listControllerDataWillChange:)])
            [delegate listControllerDataWillChange:self];
        
        //change the data (making a new model if we need one)
        if (nil == self._model)
            self._model = [GRPlistModel plistModelWithDictionary:newData];
        else 
            [self._model setContentsFromDictionary:newData];

        //cache the plist if it's not empty data, otherwise there is no reason to save it out
        if (!IsEmpty(newData))
            [[self model] writeToFile:[self localPathForRemoteURL] atomically:YES];
        
        //notify that we changed the data
        if (nil != delegate && [delegate respondsToSelector:@selector(listControllerDataDidChange:)])
            [delegate listControllerDataDidChange:self];
    }   
}

//reloads from cached plist files on disk
- (void)updateDataFromDisk;
{
    NSDictionary *newData = [NSDictionary dictionaryWithContentsOfFile:[self localPathForRemoteURL]];
    [self updateDataFromDictionary:newData];
    self.dataSource = kGRPlistLocalDataSource;
}

#pragma mark Downloading of data
//    [self updateHostandNetworkStatus]; should be called before this to be accurate
- (BOOL)shouldDownload
{    
    // default to allow
    BOOL shouldDownload = YES; 
    if (delegate && [self.delegate respondsToSelector:@selector(listControllerShouldDownloadRemoteData:)])
    {
        shouldDownload = [delegate listControllerShouldDownloadRemoteData:self];
    }
    return shouldDownload;
}

- (void)reportDownloadErrorOfType:(GRErrorCode)errorCode userInfo:(NSDictionary *)uInfo;
{
    if(delegate && [delegate respondsToSelector:@selector(listController:downloadDidFailWithError:)])
    {
        NSError *e = [NSError errorWithDomain:GR_ERROR_DOMAIN code:errorCode userInfo:uInfo];
        [delegate listController:self downloadDidFailWithError:e];
    }
}

- (void)download
{
    if (self.loadingData)
        return;
    [self updateHostandNetworkStatus]; // always call this before downloading
    //if host status is up and if it's okay to download.
    
    if (self.remoteHostStatus <= 0)
    {
        //Inform the user that the download could not be started
        NSDictionary *uInfo = [NSDictionary dictionaryWithObject:[self.remoteURL absoluteString] forKey:@"url"];
        [self reportDownloadErrorOfType:kGRPlistConnectionFailure userInfo:uInfo]; 
        return;
    }
    
    if ([self shouldDownload])
    {                
        self.loadingData = YES;
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[self remoteURL]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        
        // create the connection with the request
        // and start loading the data
        self.connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
        if (self.connection) 
        {
            self.receivedData = [NSMutableData data];
        } else {
            //Inform the user that the download could not be started
            NSDictionary *uInfo = [NSDictionary dictionaryWithObject:[self.remoteURL absoluteString] forKey:@"url"];
            [self reportDownloadErrorOfType:kGRPlistDownloadCannotInitiate userInfo:uInfo];
            self.loadingData = NO;
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
    
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    [self.receivedData setLength:0];
}

- (void)cancelDownload
{
    if (self.loadingData)
    {
        [self.connection cancel];
        self.loadingData = NO;
        
        // release the connection and receivedData
        self.receivedData = nil;
        self.connection = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.loadingData = NO;
    // release the connection and receivedData
    self.receivedData = nil;
    self.connection = nil;
    [self updateDataFromDisk];
    //inform delegate of the failure
    NSDictionary *uInfo = [NSDictionary dictionaryWithObject:[self.remoteURL absoluteString] forKey:@"url"];
    [self reportDownloadErrorOfType:kGRPlistConnectionFailure userInfo:uInfo];
}

// Check the contends of the data downloaded for plist and, if it's valid, updates the GRPlistModel (_model)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.loadingData = NO;
    
    // release the connection
    self.connection = nil;    
    
    //We need to make sure that we are only sending UTF8 - encoded plists.
    NSString *plistString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    [plistString autorelease];
    self.receivedData = nil;
    
    //quick and dirty check to make sure it's an xml plist.
    //we have to do this as the xml parser for -[NSString plist] will crash when given html
    //rather than just return nil
    if([plistString rangeOfString:@"DOCTYPE plist"].location == NSNotFound)
    {
        //Err out and load any old data we have for the current URL.
        NSDictionary *uInfo = [NSDictionary dictionaryWithObject:[self.remoteURL absoluteString] forKey:@"url"];
        [self reportDownloadErrorOfType:kGRPlistFileFormatFailure userInfo:uInfo];  
        [self updateDataFromDisk];
        return;
    }
    
    // we're pretty sure we have a plist now, so let's see what we get when we parse it.
    id plistRepresentation = [plistString propertyList];
    if (![plistRepresentation isKindOfClass:[NSDictionary class]])
    {
        //Err out and load any old data we have for the current URL.
        NSDictionary *uInfo = [NSDictionary dictionaryWithObject:[self.remoteURL absoluteString] forKey:@"url"];
        [self reportDownloadErrorOfType:kGRPlistFileFormatFailure userInfo:uInfo];  
        [self updateDataFromDisk];
        return;
    }
    
    // if we get this far, the plist is clean
    [self updateDataFromDictionary:(NSDictionary *) plistRepresentation];
    [self setLastUpdate:[NSDate date]];
    self.dataSource = kGRPlistRemoteDataSource;
}

#pragma mark reachabilityChanged notification

- (void)reachabilityChanged:(NSNotification *)note
{
    [self download];
}

//=========================================================== 
//  remoteURL 
//=========================================================== 
- (NSURL *)remoteURL
{
    //NSLog(@"in -remoteURL, returned remoteURL = %@", remoteURL);
    
    return remoteURL; 
}
- (void)setRemoteURL:(NSURL *)aRemoteURL
{
    //NSLog(@"in -setRemoteURL:, old value of remoteURL: %@, changed to: %@", remoteURL, aRemoteURL);
    
    if (remoteURL != aRemoteURL) {
        [aRemoteURL retain];
        [remoteURL release];
        remoteURL = aRemoteURL;
        self._model = nil; //gets regenerated as needed
    }
}

#pragma mark Plist index
- (NSString *)localPlistIndexPath;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localPath = [documentsDirectory stringByAppendingPathComponent:@"plistIndex.plist"];
    return localPath;
}

- (void)savePlistIndex
{
    NSDictionary *archivedPlistIndex = [NSDictionary dictionaryWithContentsOfFile:[self localPlistIndexPath]];
    if (![archivedPlistIndex isEqualToDictionary:self.plistIndex])
        [self.plistIndex writeToFile:[self localPlistIndexPath] atomically:YES];
}

//little helper method to make a new URL info dict
- (NSMutableDictionary *)newURLInfoDictionary
{
    NSString *localFileName = [NSString uniqueString];
    localFileName = [localFileName stringByAppendingString:@".plist"];
    NSArray *urlInfoObjs = [NSArray arrayWithObjects:localFileName, [NSDate distantPast], nil];
    NSArray *urlInfoKeys = [NSArray arrayWithObjects:@"localFileName", @"lastUpdate", nil];
    NSMutableDictionary *urlInfo = [NSMutableDictionary dictionaryWithObjects:urlInfoObjs forKeys:urlInfoKeys];
    return urlInfo;
}

#pragma mark accessors

@synthesize dataSource;

//consults the plistIndex.plist for the local plist path corresponding to a remote URL
- (NSString *)localPathForRemoteURL;
{
    NSString *urlKey = [self.remoteURL absoluteString];
    NSMutableDictionary *localURLInfo = [NSMutableDictionary dictionaryWithDictionary:[self.plistIndex valueForKey:urlKey]];
    if (IsEmpty(localURLInfo))
    {
        //make a unique plist filename to store the data.  Yay UUID!
        localURLInfo = [self newURLInfoDictionary];
        [self setPlistIndexObject:localURLInfo forKey:urlKey];
    }
    NSString *localFileName = [localURLInfo valueForKey:@"localFileName"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localPath = [documentsDirectory stringByAppendingPathComponent:localFileName];
    return localPath;
}

//=========================================================== 
//  plistIndex 
//=========================================================== 
- (NSMutableDictionary *)plistIndex
{
    //NSLog(@"in -plistIndex, returned plistIndex = %@", plistIndex);
    
    return plistIndex; 
}
- (void)setPlistIndex:(NSMutableDictionary *)aPlistIndex
{
    //NSLog(@"in -setPlistIndex:, old value of plistIndex: %@, changed to: %@", plistIndex, aPlistIndex);
    
    if (plistIndex != aPlistIndex) {
        [aPlistIndex retain];
        [plistIndex release];
        plistIndex = aPlistIndex;
        [self savePlistIndex];
    }
}

- (void)setPlistIndexObject:(id)aPlistIndexObject forKey:(id)aKey
{
    [[self plistIndex] setObject:aPlistIndexObject forKey:aKey];
    [self savePlistIndex];
}

- (void)removePlistIndexObjectForKey:(id)aKey
{
    [[self plistIndex] removeObjectForKey:aKey];
    [self savePlistIndex];
}

//=========================================================== 
//  model 
//=========================================================== 
// public accessor
- (GRPlistModel *)model
{
    //NSLog(@"in -model, returned model = %@", model);
    
    return _model; 
}
// private implementation
- (GRPlistModel *)_model
{
    //NSLog(@"in -model, returned model = %@", model);
    
    return _model; 
}
- (void)set_model:(GRPlistModel *)aModel
{
    //NSLog(@"in -setModel:, old value of model: %@, changed to: %@", model, aModel);
    
    if (_model != aModel) {
        [aModel retain];
        [_model release];
        _model = aModel;
    }
}

//get last updated date
//=========================================================== 
//  lastUpdate 
//=========================================================== 
- (NSDate *)lastUpdate
{
    NSString *urlKey = [self.remoteURL absoluteString];
    NSDictionary *urlInfo = [[self plistIndex] objectForKey:urlKey];
    
    NSDate *lastUpdate;
    lastUpdate = [urlInfo objectForKey:@"lastUpdate"];
    if (nil == lastUpdate)
    {
        lastUpdate = [NSDate distantPast];
    }
    return lastUpdate;
}
- (void)setLastUpdate:(NSDate *)aLastUpdate
{
    //NSLog(@"in -setLastUpdate:, old value of lastUpdate: %@, changed to: %@", lastUpdate, aLastUpdate);
    NSString *urlKey = [self.remoteURL absoluteString];
    NSMutableDictionary *urlInfo = [[self plistIndex] objectForKey:urlKey];
    if (IsEmpty(urlInfo))
    {
        urlInfo = [self newURLInfoDictionary];
    }
    if (nil == aLastUpdate)
        aLastUpdate = [NSDate distantPast];
    [urlInfo setValue:aLastUpdate forKey:@"lastUpdate"];
    [self setPlistIndexObject:urlInfo forKey:urlKey];
}

- (void) dealloc
{
    [remoteURL release]; remoteURL = nil;
    [_model release]; _model = nil;
    [plistIndex release]; plistIndex = nil;
    [self cancelDownload];
    [receivedData release]; receivedData = nil;
    [connection release]; connection = nil;
    delegate = nil;
    [super dealloc];
}


@end
