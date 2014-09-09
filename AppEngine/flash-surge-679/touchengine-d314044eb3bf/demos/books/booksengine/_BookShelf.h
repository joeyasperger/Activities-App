// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookShelf.h instead.

#import <CoreData/CoreData.h>


@class Book;
@class GAE_db_UserProperty;






@interface BookShelfID : NSManagedObjectID {}
@end

@interface _BookShelf : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BookShelfID*)objectID;



@property (nonatomic, retain) NSString *comment;

//- (BOOL)validateComment:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *gae_id;

@property long long gae_idValue;
- (long long)gae_idValue;
- (void)setGae_idValue:(long long)value_;

//- (BOOL)validateGae_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *gae_key;

//- (BOOL)validateGae_key:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* book_set;
- (NSMutableSet*)book_setSet;



@property (nonatomic, retain) GAE_db_UserProperty* owner;
//- (BOOL)validateOwner:(id*)value_ error:(NSError**)error_;



@end

@interface _BookShelf (CoreDataGeneratedAccessors)

- (void)addBook_set:(NSSet*)value_;
- (void)removeBook_set:(NSSet*)value_;
- (void)addBook_setObject:(Book*)value_;
- (void)removeBook_setObject:(Book*)value_;

@end

@interface _BookShelf (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveComment;
- (void)setPrimitiveComment:(NSString*)value;


- (NSNumber*)primitiveGae_id;
- (void)setPrimitiveGae_id:(NSNumber*)value;

- (long long)primitiveGae_idValue;
- (void)setPrimitiveGae_idValue:(long long)value_;


- (NSString*)primitiveGae_key;
- (void)setPrimitiveGae_key:(NSString*)value;


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSMutableSet*)primitiveBook_set;
- (void)setPrimitiveBook_set:(NSMutableSet*)value;



- (GAE_db_UserProperty*)primitiveOwner;
- (void)setPrimitiveOwner:(GAE_db_UserProperty*)value;


@end
