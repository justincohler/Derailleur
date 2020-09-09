//
//  NSString+Extensions.m
//  Derailleur
//
//  Created by Justin Cohler on 9/8/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSNumber *) hexToInt
{
    NSScanner *scanner = [NSScanner scannerWithString: self];
    unsigned int value;
    [scanner scanHexInt: &value];
    return [[NSNumber alloc] initWithInt:value];
}

- (NSNumber *) hexToFloat
{
    NSScanner *scanner = [NSScanner scannerWithString: self];
    unsigned int intValue;
    [scanner scanHexInt: &intValue];
    float adjustedValue = intValue / 10.0;
    return [[NSNumber alloc] initWithFloat:adjustedValue];
}

@end

