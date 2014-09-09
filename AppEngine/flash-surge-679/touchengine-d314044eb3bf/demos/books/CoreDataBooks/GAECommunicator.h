//
//  GAECommunicator.h
//  CoreDataBooks
//
//  Created by Jonathan Saggau on 9/25/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAPLReachability.h"

@class GTMHTTPFetcher;

@class GAECommunicator;

@protocol GAECommunicatorDelegate <NSObject>

@optional
-(void)communicator:(GAECommunicator *)communicator
  didFinishFetching:(NSData *)plistData
     forObjectNamed:(NSString *)aName 
           objectID:(NSString *)anObjID;

@optional
-(void)communicator:(GAECommunicator *)communicator 
    didFailFetching:(NSError *)error
     forObjectNamed:(NSString *)aName 
           objectID:(NSString *)anObjID;
@end


@interface GAECommunicator : NSObject {    
    NSString *remoteHost;
    NSString *plistPath;
    NetworkStatus remoteHostStatus;
	NetworkStatus internetConnectionStatus;
	NetworkStatus localWiFiConnectionStatus;
    id <GAECommunicatorDelegate> delegate;
@private
    NSDictionary *metadataOnTheWay;
    NSMutableArray *downloadQueue;
    GTMHTTPFetcher *fetcher;
    BOOL reachabilityIsActive;
}

//Designated
-(id)initWithremoteHost:(NSString *)remoteHost plistPath:(NSString *)path;

//Fetching plists
-(void)fetchObjectNamed:(NSString *)aName objectID:(NSString *)anObjectID;
-(void)fetchUser;
-(void)cancelFetches;

//Network status -- best call this before you start running fetches
-(void)updateNetworkStatus;

@property(nonatomic, assign)id <GAECommunicatorDelegate> delegate;
@property(nonatomic, readonly, copy)NSString *remoteHost;
@property(nonatomic, readonly, copy)NSString *plistPath;
@property(nonatomic, readonly, assign)NetworkStatus remoteHostStatus;
@property(nonatomic, readonly, assign)NetworkStatus internetConnectionStatus;
@property(nonatomic, readonly, assign)NetworkStatus localWiFiConnectionStatus;

@end
