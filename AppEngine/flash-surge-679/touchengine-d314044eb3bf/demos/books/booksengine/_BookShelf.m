// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BookShelf.m instead.

#import "_BookShelf.h"

@implementation BookShelfID
@end

@implementation _BookShelf

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookShelf" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BookShelf";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BookShelf" inManagedObjectContext:moc_];
}

- (BookShelfID*)objectID {
	return (BookShelfID*)[super objectID];
}




@dynamic comment;






@dynamic gae_id;



- (long long)gae_idValue {
	NSNumber *result = [self gae_id];
	return [result longLongValue];
}

- (void)setGae_idValue:(long long)value_ {
	[self setGae_id:[NSNumber numberWithLongLong:value_]];
}

- (long long)primitiveGae_idValue {
	NSNumber *result = [self primitiveGae_id];
	return [result longLongValue];
}

- (void)setPrimitiveGae_idValue:(long long)value_ {
	[self setPrimitiveGae_id:[NSNumber numberWithLongLong:value_]];
}





@dynamic gae_key;






@dynamic name;






@dynamic book_set;

	
- (NSMutableSet*)book_setSet {
	[self willAccessValueForKey:@"book_set"];
	NSMutableSet *result = [self mutableSetValueForKey:@"book_set"];
	[self didAccessValueForKey:@"book_set"];
	return result;
}
	

@dynamic owner;

	



@end
