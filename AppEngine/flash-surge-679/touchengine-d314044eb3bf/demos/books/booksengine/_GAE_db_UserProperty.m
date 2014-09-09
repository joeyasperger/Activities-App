// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GAE_db_UserProperty.m instead.

#import "_GAE_db_UserProperty.h"

@implementation GAE_db_UserPropertyID
@end

@implementation _GAE_db_UserProperty

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"GAE_db_UserProperty" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"GAE_db_UserProperty";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"GAE_db_UserProperty" inManagedObjectContext:moc_];
}

- (GAE_db_UserPropertyID*)objectID {
	return (GAE_db_UserPropertyID*)[super objectID];
}




@dynamic email;






@dynamic nickname;






@dynamic user_id;






@dynamic bookshelf_NoGAE;

	



@end
