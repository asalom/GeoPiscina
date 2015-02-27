//
//  ASEventManager.h
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASEvent;
@class ASGeoFence;

extern NSString * const EVENT_TABLE_NAME;
extern NSString * const EVENT_COLUMN_ID;
extern NSString * const EVENT_COLUMN_ENTRY_TIMESTAMP;
extern NSString * const EVENT_COLUMN_EXIT_TIMESTAMP;
extern NSString * const EVENT_COLUMN_GEOFENCE;

@interface ASEventManager : NSObject

- (void)addEvent:(ASEvent *)event;
- (void)addExitForEvent:(ASEvent *)event exit:(NSDate *)date;
- (void)deleteEvent:(ASEvent *)event;
- (BOOL)eventExists:(ASEvent *)event;

- (NSArray *)eventsForDate:(NSDate *)date geoFence:(ASGeoFence *)geoFence;

@end
