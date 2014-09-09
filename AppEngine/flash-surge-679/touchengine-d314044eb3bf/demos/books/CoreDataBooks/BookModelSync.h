//
//  BookModelSync.h
//  CoreDataBooks
//
//  Created by Jonathan Saggau on 9/25/10.
//  Copyright 2010 Sounds Broken inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAEModelSync.h"

@interface BookModelSync : GAEModelSync {
    
@private
    NSFetchedResultsController *fetchedResultsController;
    NSDictionary *gaeBooksDict;
    NSDictionary *gaeBookshelvesDict;
}

//managed objects
-(NSArray *)books;

@end
