//
//  TrackPoint.h
//  Derailleur
//
//  Created by Justin Cohler on 9/7/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#ifndef TrackPoint_h
#define TrackPoint_h

@interface TrackPoint : NSObject

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSNumber *distanceMeters;
@property (nonatomic, strong) NSNumber *speed;
@property (nonatomic, strong) NSNumber *cadence;
@property (nonatomic, strong) NSNumber *power;
@property (nonatomic, strong) NSNumber *resistance;

- (id) initWithTime:currentTimestamp andSpeed:speed andCadence:cadence andPower:power andResistance:resistance;
- (id) initWithTime:(NSDate *)time;
- (NSNumber *) computeDistance:(NSDate *)previousTimestamp;

@end

#endif /* TrackPoint_h */
