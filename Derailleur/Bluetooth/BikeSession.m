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
        self.status = EMPTY;
        self.trackPoints = [NSMutableArray array];
        self.totalTimeSeconds = 0;
        self.distanceMeters = [NSNumber numberWithFloat:0.0];
    }
    return self;
}

- (void) record
{
    self.status = IN_PROGRESS;
    self.previousTimestamp = [NSDate date];
}

- (void) pause
{
    self.status = PAUSED;
}

- (void) reset
{
    self.status = EMPTY;
    self.trackPoints = [NSMutableArray array];
}

- (NSString *) save
{
    self.status = COMPLETE;
    
    NSXMLElement *root = [[NSXMLElement alloc] initWithName:@"TrainingCenterDatabase"];
    [root addAttribute:[NSXMLNode attributeWithName:@"xsi:schemaLocation" stringValue:@"http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2 http://www.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd"]];
    [root addAttribute:[NSXMLNode attributeWithName:@"xmlns:ns5" stringValue:@"http://www.garmin.com/xmlschemas/ActivityGoals/v1"]];
    [root addAttribute:[NSXMLNode attributeWithName:@"xmlns:ns3" stringValue:@"http://www.garmin.com/xmlschemas/ActivityExtension/v2"]];
    [root addAttribute:[NSXMLNode attributeWithName:@"xmlns:ns2" stringValue:@"http://www.garmin.com/xmlschemas/UserProfile/v2"]];
    [root addAttribute:[NSXMLNode attributeWithName:@"xmlns" stringValue:@"http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2"]];
    [root addAttribute:[NSXMLNode attributeWithName:@"xmlns:xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"]];
    
    NSXMLElement *activities = [[NSXMLElement alloc] initWithName:@"Activities"];
    [root addChild:activities];
    
    NSXMLElement *activity = [[NSXMLElement alloc] initWithName:@"Activity"];
    [activity addAttribute:[NSXMLNode attributeWithName:@"Sport" stringValue:@"biking"]];
    [activities addChild:activity];
    
    NSXMLElement *activityId = [[NSXMLElement alloc] initWithName:@"Id"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormat:@"##0.00000"];
    
    NSString *idString;
    if (self.trackPoints.count > 0) {
        idString = [dateFormatter stringFromDate:self.trackPoints[0].time];
        [activityId setStringValue:idString];
        [activity addChild:activityId];
        
        NSXMLElement *lap = [[NSXMLElement alloc] initWithName:@"Lap"];
        [lap addAttribute:[NSXMLNode attributeWithName:@"StartTime" stringValue:idString]];
        
        NSXMLElement *totalTimeSeconds = [[NSXMLElement alloc] initWithName:@"TotalTimeSeconds"];
        self.totalTimeSeconds = [[NSDate date] timeIntervalSinceDate:self.trackPoints[0].time];
        NSString *totalTimeSecondsString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.totalTimeSeconds]];
        [totalTimeSeconds setStringValue:totalTimeSecondsString];
        [lap addChild:totalTimeSeconds];
        
        NSXMLElement *distanceMeters = [[NSXMLElement alloc] initWithName:@"DistanceMeters"];
        [distanceMeters setStringValue:[numberFormatter stringFromNumber:self.distanceMeters]];
        [lap addChild:distanceMeters];
        
        NSXMLElement *track = [[NSXMLElement alloc] initWithName:@"Track"];
        for (TrackPoint *currentPoint in self.trackPoints) {
            NSXMLElement *trackPoint = [[NSXMLElement alloc] initWithName:@"TrackPoint"];
            
            NSXMLElement *time = [[NSXMLElement alloc] initWithName:@"Time"];
            [time setStringValue:[dateFormatter stringFromDate:currentPoint.time]];
            [trackPoint addChild:time];
            
            NSXMLElement *distanceMeters = [[NSXMLElement alloc] initWithName:@"DistanceMeters"];
            [distanceMeters setStringValue:[numberFormatter stringFromNumber:currentPoint.distanceMeters]];
            [trackPoint addChild:distanceMeters];
            
            NSXMLElement *cadence = [[NSXMLElement alloc] initWithName:@"Cadence"];
            [cadence setStringValue:[numberFormatter stringFromNumber:currentPoint.cadence]];
            [trackPoint addChild:cadence];
            
            NSXMLElement *power = [[NSXMLElement alloc] initWithName:@"Power"];
            [power setStringValue:[numberFormatter stringFromNumber:currentPoint.power]];
            [trackPoint addChild:power];
            
            [track addChild:trackPoint];
        }
        [lap addChild:track];
        [activity addChild:lap];
    }
    
    NSXMLDocument *xmlRequest = [NSXMLDocument documentWithRootElement:root];
    NSLog(@"XML Document\n%@", xmlRequest);
    NSData *xmlData = [xmlRequest XMLDataWithOptions:NSXMLNodePrettyPrint];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingFormat:@"/%@.tcx", idString];
    [xmlData writeToFile:filePath atomically:NO];
    
//    NSString *filePath = [[NSString alloc] initWithFormat: @"%@%@.tcx",
//                          NSTemporaryDirectory(), idString];
//    NSFileManager *m = [NSFileManager defaultManager];
//    [m createFileAtPath:filePath contents:xmlData attributes:nil];
    
    return filePath;
}

- (void) add: (TrackPoint *)point
{
    NSNumber *distance = [point computeDistance:self.previousTimestamp];
    self.distanceMeters = [NSNumber numberWithFloat:([self.distanceMeters floatValue] + [distance floatValue])];
    [self.trackPoints addObject:point];
    self.previousTimestamp = point.time;
}

- (TrackPoint *) latest
{
    return [self.trackPoints lastObject];
}

@end
