//
//  FileWriter.h
//  Derailleur
//
//  Created by Justin Cohler on 9/7/20.
//  Copyright © 2020 Benwithjamin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BikeData.h"
#ifndef FileWriter_h
#define FileWriter_h

@interface FileWriter : NSView

- (void) write:(NSArray<ICGLiveStreamData *> *)bikeData;

@end

#endif /* FileWriter_h */
