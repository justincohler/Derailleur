//
//  Strava.h
//  Derailleur
//
//  Created by Justin Cohler on 9/9/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//
#ifndef StravaClient_h
#define StravaClient_h

#import "BikeSession.h"

@interface StravaClient: NSObject

- (void) uploadSession:(BikeSession *)bikeSession :(NSString *)path;

@end

#endif /* StravaClient_h */
