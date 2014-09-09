//
//  BookModelSync.m
//  CoreDataBooks
//
//  Created by Jonathan Saggau on 9/25/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import "BookModelSync.h"
#import "NSFetchedResultsController+extensions.h"
#import "GAECommunicator.h"
#import "Book.h"
#import "BookShelf.h"
#import "NSManagedObject+(touchEngineComms).h"
#import "NSDateFormatter+gaeDateFormatter.h"

@interface BookModelSync ()

@property(nonatomic, retain)NSDictionary *gaeBooksDict;
@property(nonatomic, retain)NSDictionary *gaeBookshelvesDict;

@end

@implementation BookModelSync

- (NSFetchedResultsController *)fetchedResultsController 
{
    if (fetchedResultsController != nil) 
    {
        return fetchedResultsController;
    }
    
    fetchedResultsController = [[NSFetchedResultsController controllerForEntityName:@"Book"
                                                             inManagedObjectContext:managedObjectContext
                                                                      withPredicate:nil
                                                                        sortedByKey:@"author"
                                                                          ascending:YES
                                                                           delegate:self] retain];
    
    return fetchedResultsController;
}    

-(NSArray *)books
{
    NSArray *books = [self.fetchedResultsController fetchedObjects];
    return books;
}

-(void)sync
{
    [super sync];
    //TODO: handle err
    
    // automatically fetches all of the books from coredata
    [self fetchedResultsController]; 
    NSLog(@"books = %@", [self books]);
    
    //fetch all books and bookshelves from GAE
    [communicator fetchUser];
    [communicator fetchObjectNamed:@"Book" objectID:nil]; 
    [communicator fetchObjectNamed:@"BookShelf" objectID:nil];
}

-(Book *)fetchBookWithGAEID:(NSNumber *)gaeID gaeKey:(NSString *)gaeKey
{
    Book *book = nil;
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease]; 
    [request setEntity:[NSEntityDescription entityForName:@"Book" inManagedObjectContext:managedObjectContext]];
    NSPredicate *predicate = nil; 
    predicate = [NSPredicate predicateWithFormat:@"gae_id == %@ AND gae_key == %@", gaeID, gaeKey]; 
    [request setPredicate:predicate];
    NSError *error = nil; 
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error]; 
    if (error) 
    {
        NSLog(@"Fetch error %@", [error localizedDescription]);
        abort();
    }
    if ([results count] > 0) 
    {
        NSAssert2([results count] == 1, @"THere must be only one book with gaeKey = %@ and gaeID = %@", gaeKey, gaeID);
        book = [results objectAtIndex:0];
    }
    
    return book;
}

-(void)updateForNewGAEData
{
    //We need both lists to update as they're interdependent entities
    if (nil != [self gaeBooksDict] && nil != [self gaeBookshelvesDict]) 
    {
        /*
         For each gaeBook in gaeBooksDict:
         Find coreData book that corresponds
         if coreData book:
         update coredata book
         else:
         make new coredata book
         any coredata books NOT in the current gaeBooksDict need to be deleted
         (this requires keeping a list of coredata books that were not found)
         
         Same algo for the bookshelves
         */
        NSMutableArray *booksRemaining = [[[self books] mutableCopy] autorelease];
        NSArray *gaeBooks = [[self gaeBooksDict] objectForKey:@"Book_set"];
        for (NSDictionary *aBook in gaeBooks) {
            NSMutableDictionary *book = [[aBook mutableCopy] autorelease];
            NSLog(@"book to find = %@", book);
            NSNumber *ident = [book objectForKey:@"id"];
            NSString *key = [book objectForKey:@"key"];
            
            //Sanitize the values from GAE to those of our book's attribute names
            //TODO: this could be automated, possibly using the mogenerator template
            [book setValue:ident forKey:@"gae_id"];
            [book setValue:key forKey:@"gae_key"];
            [book removeObjectForKey:@"key"];
            [book removeObjectForKey:@"id"];
            
            NSString *copyrightString = [book objectForKey:@"copyright"];
            NSString *dateString = [book objectForKey:@"date"];
            NSLog(@"copyrightString %@; dateString %@;", copyrightString, dateString);

            NSDate *copyrightDate = [[NSDateFormatter gaeDateFormatter] dateFromString:copyrightString];
            NSDate *dateDate = [[NSDateFormatter gaeDateFormatter] dateFromString:dateString];
            [book setValue:copyrightDate forKey:@"copyright"];
            [book setValue:dateDate forKey:@"date"];
            
            NSLog(@"copyrightDate %@; dateDate %@;", copyrightDate, dateDate);

            Book *managedBook = [self fetchBookWithGAEID:ident gaeKey:key];
            [booksRemaining removeObject:managedBook];
            if (IsEmpty(managedBook)) 
            {
                managedBook = [Book insertInManagedObjectContext:managedObjectContext];
            }
            [managedBook setAttributesWithDictionary:book];
        }
        
        //TODO: bookshelves and bookshelf UI
        
        //Save changes
        NSError *error = nil;
        if (![managedObjectContext save:&error]) 
        {
            NSLog(@"Failed to save with error:%@", [error localizedDescription]);
            abort();
        }
        
        [self setGaeBooksDict:nil];
        [self setGaeBookshelvesDict:nil];
    }
}

-(void)handleNewBooks:(NSData *)booksRepresentation
{
    NSError *error = nil;
    NSDictionary *booksDict = [NSPropertyListSerialization propertyListWithData:booksRepresentation
                                                                        options:0
                                                                         format:nil
                                                                          error:&error];
    NSAssert(!error, @"Problem parsing data for books");
    [self setGaeBooksDict:booksDict];
    [self updateForNewGAEData];
}

-(void)handleNewBookshelves:(NSData *)shelvesRepresentation
{
    NSError *error = nil;
    NSDictionary *bookShelvesDict = [NSPropertyListSerialization propertyListWithData:shelvesRepresentation
                                                                              options:0
                                                                               format:nil
                                                                                error:&error];
    NSAssert(!error, @"Problem parsing data for bookShelves");
    [self setGaeBookshelvesDict:bookShelvesDict];
    [self updateForNewGAEData];
}

-(void)communicator:(GAECommunicator *)acommunicator
  didFinishFetching:(NSData *)plistData
     forObjectNamed:(NSString *)aName 
           objectID:(NSString *)anObjID;
{
    if ([super respondsToSelector:@selector(communicator:didFinishFetching:ForObjectNamed:objectID:)]) {
        [super communicator:acommunicator
          didFinishFetching:plistData
             forObjectNamed:aName
                   objectID:anObjID];
    }
    if ([@"BookShelf" isEqualToString:aName]) 
    {
        [self handleNewBookshelves:plistData];
    }
    else if ([@"Book" isEqualToString:aName])
    {
        [self handleNewBooks:plistData];
    }
}

-(void)communicator:(GAECommunicator *)acommunicator 
    didFailFetching:(NSError *)error
     forObjectNamed:(NSString *)aName 
           objectID:(NSString *)anObjID;
{
    if ([super respondsToSelector:@selector(communicator:didFailFetching:ForObjectNamed:objectID:)]) {
        [super communicator:acommunicator
            didFailFetching:error 
             forObjectNamed:aName
                   objectID:anObjID];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
    NSLog(@"[%@ %@]", self, NSStringFromSelector(_cmd));
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
{
    NSLog(@"[%@ %@]", self, NSStringFromSelector(_cmd));
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
    NSLog(@"[%@ %@]", self, NSStringFromSelector(_cmd));
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    NSLog(@"[%@ %@]", self, NSStringFromSelector(_cmd));
}

@synthesize gaeBooksDict;
@synthesize gaeBookshelvesDict;
     
- (void) dealloc
{
    [gaeBooksDict release]; gaeBooksDict = nil;
    [gaeBookshelvesDict release]; gaeBookshelvesDict = nil;
    
    [fetchedResultsController setDelegate:nil];
    [fetchedResultsController release]; fetchedResultsController = nil; 
    [super dealloc];
}


@end
