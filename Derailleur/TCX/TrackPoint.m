//
//  TrackPoint.m
//  Derailleur
//
//  Created by Justin Cohler on 9/7/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackPoint.h"

@implementation TrackPoint

- (id) initWithTime:(NSDate *)time andSpeed:(NSNumber *)speed andCadence:(NSNumber *)cadence andPower:(NSNumber *)power andResistance:(NSNumber *)resistance
{
    self = [super init];
    if (self) {
        self.time = time;
        self.speed = speed;
        self.cadence = cadence;
        self.power = power;
        self.resistance = resistance;
        self.distanceMeters = [NSNumber numberWithInt:0];

    }
    return self;
}

- (NSNumber *) computeDistance:(NSDate *)previousTimestamp
{
    NSTimeInterval delta = [self.time timeIntervalSinceDate:previousTimestamp];
    double distance = self.speed.doubleValue * 1000.0 * delta / 3600.0;
    self.distanceMeters = [[NSNumber alloc] initWithDouble:distance];
    return self.distanceMeters;
}

- (id) initWithTime:(NSDate *)time
{
    self = [super init];
    if (self) {
        self.time = time;
    }
    return self;
}

@end
