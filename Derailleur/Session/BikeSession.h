//
//  Session.h
//  Derailleur
//
//  Created by Justin Cohler on 9/9/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#ifndef Session_h
#define Session_h
#import "TrackPoint.h"

@interface Session : NSObject

@property (nonatomic, strong) NSDate *previousTimestamp;
@property (nonatomic, strong) NSMutableArray<TrackPoint *> *trackPoints;

- (TrackPoint *) latest;
- (void) add: (TrackPoint *)point;
@end

#endif /* Session_h */
