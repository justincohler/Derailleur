//
//  BikeSession.m
//  Derailleur
//
//  Created by Justin Cohler on 9/9/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BikeSession.h"

@implementation BikeSession

- (id) init
{
    self = [super init];
    if (self) {
        self.trackPoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (TrackPoint *) latest
{
    return [self.trackPoints lastObject];
}

- (void) add: (TrackPoint *)point
{
    [self.trackPoints addObject:point];
    self.previousTimestamp = point.time;
}

@end
