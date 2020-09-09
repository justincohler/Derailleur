//
//  NSData+Extensions.m
//  Derailleur
//
//  Created by Justin Cohler on 9/8/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import "NSData+HexRepresentation.h"

@implementation NSData (HexRepresentation)

- (NSString *) hexString
{
    const unsigned char *bytes = (const unsigned char *) self.bytes;
    NSMutableString *hex = [NSMutableString new];
    for (NSInteger i = 0; i < self.length; i++) {
        [hex appendFormat:@"%02x", bytes[i]];
    }
    return [hex copy];
}

@end
