//
//  BikeSession.h
//  Derailleur
//
//  Created by Justin Cohler on 9/9/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#ifndef BikeSession_h
#define BikeSession_h
#import "TrackPoint.h"


typedef enum {
    EMPTY,
    IN_PROGRESS,
    PAUSED,
    COMPLETE
} SessionStatus;

@interface BikeSession : NSObject

@property (nonatomic, assign) SessionStatus status;
@property (nonatomic, strong) NSDate *previousTimestamp;
@property (nonatomic, assign) NSTimeInterval totalTimeSeconds;
@property (nonatomic, strong) NSNumber *distanceMeters;
@property (nonatomic, strong) NSMutableArray<TrackPoint *> *trackPoints;

- (void) record;
- (void) pause;
- (void) reset;
- (NSString *) save;
- (void) add: (TrackPoint *)point;
- (TrackPoint *) latest;

@end

#endif /* BikeSession_h */
