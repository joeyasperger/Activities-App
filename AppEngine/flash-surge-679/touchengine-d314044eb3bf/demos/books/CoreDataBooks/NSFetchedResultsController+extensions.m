//
//  NSFetchedResultsController+extensions.m
//  Vertitron
//
//  Created by Jonathan Saggau on 7/13/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import "NSFetchedResultsController+extensions.h"

@implementation NSFetchedResultsController (GAEExtensions)

+(NSFetchedResultsController *)controllerForEntityName:(NSString *)entityName 
                                inManagedObjectContext:(NSManagedObjectContext *)moc 
                                         withPredicate:(NSPredicate *)predicate
                                           sortedByKey:(NSString *)key 
                                             ascending:(BOOL)ascending 
                                              delegate:(id)delegate
{
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
// Set the batch size to 1 as we'll only every have one tenant.
//    [fetchRequest setFetchBatchSize:1];
    
    NSSortDescriptor *sortDescriptor = nil;
    
    if (predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    // Edit the sort key as appropriate.
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    [sortDescriptors release];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    [NSFetchedResultsController deleteCacheWithName:entityName];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                                managedObjectContext:moc 
                                                                                                  sectionNameKeyPath:nil 
                                                                                                           cacheName:entityName];
    aFetchedResultsController.delegate = delegate;
    
    [fetchRequest release];
    
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return [aFetchedResultsController autorelease];
}

@end
