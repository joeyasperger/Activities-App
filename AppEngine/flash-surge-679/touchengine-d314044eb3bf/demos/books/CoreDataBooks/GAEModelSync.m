//
//  GAEModelSync.m
//  CoreDataBooks
//
//  Created by Jonathan Saggau on 9/25/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import "GAEModelSync.h"
#import "GAECommunicator.h"


@implementation GAEModelSync

-(id)initWithremoteHost:(NSString *)remoteHost plistPath:(NSString *)path managedObjectContext:(NSManagedObjectContext *)moc;
{
    self = [super init];
    if (self != nil) {
        communicator = [[GAECommunicator alloc] initWithremoteHost:remoteHost
                                                          plistPath:path];
        [communicator setDelegate:self];
        [communicator updateNetworkStatus];
        managedObjectContext = moc;
    }
    return self;
}

-(void)sync
{
    //Subclasses will override
}

-(void)cancel
{
    [communicator cancelFetches];
}

-(GAECommunicator *)communicator
{
    return communicator;
}

-(void)dealloc
{
    managedObjectContext = nil;
    [communicator cancelFetches];
    [communicator release]; communicator = nil;
    [super dealloc];
}


@end
