//
//  NSFetchedResultsController+extensions.h
//  Vertitron
//
//  Created by Jonathan Saggau on 7/13/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFetchedResultsController (GAEExtensions)

+(id)controllerForEntityName:(NSString *)entityName 
      inManagedObjectContext:(NSManagedObjectContext *)moc 
               withPredicate:(NSPredicate *)predicate
                 sortedByKey:(NSString *)key 
                   ascending:(BOOL)ascending 
                    delegate:(id)delegate;
@end
