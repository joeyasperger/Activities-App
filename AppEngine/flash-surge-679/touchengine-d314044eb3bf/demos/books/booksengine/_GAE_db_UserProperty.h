// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GAE_db_UserProperty.h instead.

#import <CoreData/CoreData.h>


@class BookShelf;





@interface GAE_db_UserPropertyID : NSManagedObjectID {}
@end

@interface _GAE_db_UserProperty : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GAE_db_UserPropertyID*)objectID;



@property (nonatomic, retain) NSString *email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *nickname;

//- (BOOL)validateNickname:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *user_id;

//- (BOOL)validateUser_id:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) BookShelf* bookshelf_NoGAE;
//- (BOOL)validateBookshelf_NoGAE:(id*)value_ error:(NSError**)error_;



@end

@interface _GAE_db_UserProperty (CoreDataGeneratedAccessors)

@end

@interface _GAE_db_UserProperty (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;


- (NSString*)primitiveNickname;
- (void)setPrimitiveNickname:(NSString*)value;


- (NSString*)primitiveUser_id;
- (void)setPrimitiveUser_id:(NSString*)value;




- (BookShelf*)primitiveBookshelf_NoGAE;
- (void)setPrimitiveBookshelf_NoGAE:(BookShelf*)value;


@end
