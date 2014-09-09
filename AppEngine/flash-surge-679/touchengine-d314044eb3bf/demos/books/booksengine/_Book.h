// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.h instead.

#import <CoreData/CoreData.h>


@class BookShelf;








@interface BookID : NSManagedObjectID {}
@end

@interface _Book : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BookID*)objectID;



@property (nonatomic, retain) NSString *author;

//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *copyright;

//- (BOOL)validateCopyright:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *date;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *gae_id;

@property long long gae_idValue;
- (long long)gae_idValue;
- (void)setGae_idValue:(long long)value_;

//- (BOOL)validateGae_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *gae_key;

//- (BOOL)validateGae_key:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) BookShelf* bookshelf;
//- (BOOL)validateBookshelf:(id*)value_ error:(NSError**)error_;



@end

@interface _Book (CoreDataGeneratedAccessors)

@end

@interface _Book (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAuthor;
- (void)setPrimitiveAuthor:(NSString*)value;


- (NSDate*)primitiveCopyright;
- (void)setPrimitiveCopyright:(NSDate*)value;


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;


- (NSNumber*)primitiveGae_id;
- (void)setPrimitiveGae_id:(NSNumber*)value;

- (long long)primitiveGae_idValue;
- (void)setPrimitiveGae_idValue:(long long)value_;


- (NSString*)primitiveGae_key;
- (void)setPrimitiveGae_key:(NSString*)value;


- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (BookShelf*)primitiveBookshelf;
- (void)setPrimitiveBookshelf:(BookShelf*)value;


@end
