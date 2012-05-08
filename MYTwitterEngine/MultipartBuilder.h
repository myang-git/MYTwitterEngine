//
//  MultipartBuilder.h
//
//  Created by Ming Yang on 5/3/12.
//

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"

@interface MultipartBuilder : NSObject {
    NSMutableData* body;
    NSString* boundary;
    NSString* contentType;
}

- (void)addValue:(NSString*)value forName:(NSString*)name;
- (void)addData:(NSData*)data withFilename:(NSString*)filename forName:(NSString*)name;

@property (nonatomic, readonly) NSString* contentType;
@property (nonatomic, copy) NSData* body;

@end
