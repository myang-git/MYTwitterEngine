//
//  MultipartBuilder.m
//
//  Created by Ming Yang on 5/3/12.
//

#import "MultipartBuilder.h"

static NSString* const NEWLINE = @"\r\n";

@implementation MultipartBuilder

@synthesize contentType;
@synthesize body;

- (id)init {
    if (self = [super init]) {
        body = [[NSMutableData alloc] init];
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        boundary = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        CFRelease(uuidRef);
        
        contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        
        NSString* firstBoundary = [NSString stringWithFormat:@"--%@%@", boundary, NEWLINE];
        [body appendData:[self stringToData:firstBoundary]];
        
        return self;
    }
    else {
        return nil;
    }
}

- (NSData*)stringToData:(NSString*)string {
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)addValue:(NSString *)value forName:(NSString *)name {
    NSString* header = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"%@", name, NEWLINE];
    [body appendData:[self stringToData:header]];
    [body appendData:[self stringToData:NEWLINE]];
    NSString* valueString = [NSString stringWithFormat:@"%@%@", value, NEWLINE];
    [body appendData:[self stringToData:valueString]];
    NSString* footer = [NSString stringWithFormat:@"--%@--%@", boundary, NEWLINE];
    [body appendData:[self stringToData:footer]];
}

- (void)addData:(NSData *)data withFilename:(NSString *)filename forName:(NSString *)name {
    NSString* header = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"%@", name, filename, NEWLINE];
    [body appendData:[self stringToData:header]];
    
    NSString* dataContentType = [NSString stringWithFormat:@"Content-Type: application/octet-stream%@", NEWLINE];
    [body appendData:[self stringToData:dataContentType]];
    
    [body appendData:[self stringToData:NEWLINE]];

    NSString* base64String = [data base64EncodedString];
    NSData* base64Data = [self stringToData:base64String];
    [body appendData:base64Data];
    
    NSString* footer = [NSString stringWithFormat:@"%@--%@%@", NEWLINE, boundary, NEWLINE];
    [body appendData:[self stringToData:footer]];
}

- (void)dealloc {
    [body release];
    [boundary release];
    [super dealloc];
}

@end
