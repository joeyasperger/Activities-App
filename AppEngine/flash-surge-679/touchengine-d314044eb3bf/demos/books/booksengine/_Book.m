// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.m instead.

#import "_Book.h"

@implementation BookID
@end

@implementation _Book

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Book";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Book" inManagedObjectContext:moc_];
}

- (BookID*)objectID {
	return (BookID*)[super objectID];
}




@dynamic author;






@dynamic copyright;






@dynamic date;






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






@dynamic title;






@dynamic bookshelf;

	



@end
