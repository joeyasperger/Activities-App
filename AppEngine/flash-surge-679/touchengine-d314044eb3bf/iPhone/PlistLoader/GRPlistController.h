//
//  GRPlistController.h
//  PlistLoader
//
//  Created by Jonathan Saggau on 11/4/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "GRPlistControllerDelegateProtocol.h"

typedef enum {
    kGRPlistNoneDataSource = 0,
	kGRPlistRemoteDataSource,
	kGRPlistLocalDataSource
} GRDataSource;

typedef enum {
	kGRPlistDownloadCannotInitiate = 0,
	kGRPlistConnectionFailure,
	kGRPlistFileFormatFailure
} GRErrorCode;

#define GR_ERROR_DOMAIN @"GRPlistController_Error_Domain"

@class GRPlistModel;

// This class will grab a remote plist from the server whenever update is called.

// Also registers with the Reachability object for notifications when
// the remote host changes availability and updates accordingly
// asking the delegate first if downloading new data is desirable.

@interface GRPlistController : NSObject {
    NSURL *remoteURL;
    NSObject <GRPlistControllerDelegate> *delegate;
    
    NetworkStatus remoteHostStatus;
	NetworkStatus internetConnectionStatus;
	NetworkStatus localWiFiConnectionStatus;
    BOOL loadingData;
    GRDataSource dataSource;
@private
    GRPlistModel *_model;
    BOOL hostIsReachable;
    NSMutableDictionary *plistIndex;
    NSMutableData *receivedData;
    NSURLConnection *connection;
}

@property(nonatomic, retain)NSURL *remoteURL;
@property(nonatomic, assign)NSObject *delegate;
@property(nonatomic, readonly)GRPlistModel *model;
@property(nonatomic, readonly)GRDataSource dataSource;

//date of last download
@property(nonatomic, retain)NSDate *lastUpdate;
@property(nonatomic, getter=isLoadingData)BOOL loadingData;
@property NetworkStatus remoteHostStatus;
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus localWiFiConnectionStatus;

//designated Initializer
- (id)initWithRemoteURL:(NSURL *)aRemoteURL;

//(re)loads trying remote URL first, then pulls it off of disk.
- (void)updateDataFromDisk;
- (void)download;
- (void)cancelDownload;
@end

