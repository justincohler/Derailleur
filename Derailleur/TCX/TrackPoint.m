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

- (id) initWithTime:(NSDate *)time andSpeed:(NSNumber *)speed andDistance:(NSNumber *)distance andCadence:(NSNumber *)cadence andPower:(NSNumber *)power andResistance:(NSNumber *)resistance
{
    self = [super init];
    if (self) {
        self.time = time;
        self.speed = speed;
        self.distanceMeters = distance;
        self.cadence = cadence;
        self.power = power;
        self.resistance = resistance;
    }
    return self;
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
