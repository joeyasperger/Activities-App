//
//  GAEModelSync.h
//  CoreDataBooks
//
//  Created by Jonathan Saggau on 9/25/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAECommunicator.h"

@interface GAEModelSync : NSObject <GAECommunicatorDelegate>{
    GAECommunicator *communicator;
@protected
    NSManagedObjectContext *managedObjectContext;
}

//Use this to get your network status
@property(nonatomic, readonly, retain)GAECommunicator *communicator;

-(id)initWithremoteHost:(NSString *)remoteHost plistPath:(NSString *)path managedObjectContext:(NSManagedObjectContext *)moc;

-(void)sync;
-(void)cancel;

@end
