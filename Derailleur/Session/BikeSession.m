//
//  Session.m
//  Derailleur
//
//  Created by Justin Cohler on 9/9/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@implementation Session

- (id) init
{
    return [super init];
}

- (TrackPoint *) latest
{
    return [self.trackPoints lastObject];
}

- (void) add: (TrackPoint *)point
{
    NSLog(@"Anything");
    [self.trackPoints addObject:point];
    self.previousTimestamp = point.time;
    NSLog(@"Previous Timestamp: %@", self.previousTimestamp);
}

@end

