//http://svn.cocoasourcecode.com/MGTwitterEngine/NSString+UUID.m

#import "NSString+UUID.h"

@implementation NSString(UUID)

+ (NSString *)uniqueString;
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    [(NSString *)uuidStr autorelease];
    return (NSString *)uuidStr;
}

@end
