//
//  ServerRequest.m
//  Spring
//
//  Created by Joseph Asperger on 9/15/14.
//
//

#import "ServerRequest.h"
#import "ServerInfo.h"

@implementation ServerRequest

@synthesize responseData = _responseData;

-(id) initPostWithURL:(NSString *)url content:(NSString *)content{
    if (self = [super init]){
        NSData *postData = [content dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *contentLength = [NSString stringWithFormat:@"%ld", [postData length]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %ld bytes of data",(long)[self.responseData length]);
}

@end
