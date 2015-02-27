//
//  ASEventManager.m
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "ASEventManager.h"
#import "ASEvent.h"
#import "ASGeoFence.h"
#import "ASDatabaseManager.h"
#import "NSDate+Components.h"
#import <FMDB/FMDatabase.h>

NSString * const EVENT_TABLE_NAME = @"event";
NSString * const EVENT_COLUMN_ID = @"id";
NSString * const EVENT_COLUMN_ENTRY_TIMESTAMP = @"entryTimestamp";
NSString * const EVENT_COLUMN_EXIT_TIMESTAMP = @"exitTimestamp";
NSString * const EVENT_COLUMN_GEOFENCE = @"geofence";

@implementation ASEventManager

- (void)addEvent:(ASEvent *)event {
    if (!event.isValid) {
        NSAssert(false, @"%@ is not valid", event);
    }
    
    if ([self eventExists:event]) {
        NSLog(@"There is an event!!!!");
        return;
    }
    
    NSMutableString *query = [NSMutableString new];
    [query appendFormat:@"INSERT INTO %@ ", EVENT_TABLE_NAME];
    [query appendFormat:@"('%@', '%@') VALUES", EVENT_COLUMN_ENTRY_TIMESTAMP, EVENT_COLUMN_GEOFENCE];
    [query appendFormat:@"(%f, %li);", event.entryDate.timeIntervalSince1970, (long)event.geoFence.databaseId];
    if (![[ASDatabaseManager sharedInstance] executeUpdate:query]) {
        NSAssert(false, @"Error while inserting %@", event);
    }
}

- (void)deleteEvent:(ASEvent *)event {
    NSMutableString *query = [NSMutableString new];
    [query appendFormat:@"DELETE FROM %@ ", EVENT_TABLE_NAME];
    [query appendFormat:@"WHERE %@ = %li", EVENT_COLUMN_ID, event.databaseId];
    if (![[ASDatabaseManager sharedInstance] executeUpdate:query]) {
        NSAssert(false, @"Error while inserting %@", event);
    }
}

- (BOOL)eventExists:(ASEvent *)event {
    return [self eventsForDate:event.entryDate geoFence:event.geoFence].count > 0;
}

- (NSArray *)eventsForDate:(NSDate *)date geoFence:(ASGeoFence *)geoFence {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %li;", EVENT_TABLE_NAME, EVENT_COLUMN_GEOFENCE, (long)geoFence.databaseId];
    // TODO: filter dates on the query
    
    
    FMResultSet *resultSet = [[ASDatabaseManager sharedInstance] executeQuery:query];
    NSMutableArray *events = [NSMutableArray new];
    while ([resultSet next]) {
        ASEvent *event = [self eventFromResultSet:resultSet geoFence:geoFence];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        NSDate *requestingDate = [NSDate dateWithDay:components.day month:components.month year:components.year];
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:event.entryDate];
        NSDate *entryDate = [NSDate dateWithDay:components.day month:components.month year:components.year];
        
        
        NSComparisonResult result = [requestingDate compare:entryDate];
        if (result == NSOrderedSame) {
            [events addObject:event];
        }
    }
    return events;
}

- (ASEvent *)eventFromResultSet:(FMResultSet *)resultSet geoFence:(ASGeoFence *)geoFence {
    NSInteger databaseId = [resultSet intForColumn:EVENT_COLUMN_ID];
    NSDate *entryDate = [NSDate dateWithTimeIntervalSince1970:[resultSet doubleForColumn:EVENT_COLUMN_ENTRY_TIMESTAMP]];
    NSDate *exitDate = [NSDate dateWithTimeIntervalSince1970:[resultSet doubleForColumn:EVENT_COLUMN_EXIT_TIMESTAMP]];
    
    return [[ASEvent alloc] initWithDatabaseId:databaseId
                                     entryDate:entryDate
                                      exitDate:exitDate
                                      geoFence:geoFence];
}

/*
 NSInteger databaseId = [resultSet intForColumn:GEOFENCE_COLUMN_ID];
 NSString *name = [resultSet stringForColumn:GEOFENCE_COLUMN_NAME];
 double latitude = [resultSet doubleForColumn:GEOFENCE_COLUMN_LATITUDE];
 double longitude = [resultSet doubleForColumn:GEOFENCE_COLUMN_LONGITUDE];
 NSInteger radius = [resultSet intForColumn:GEOFENCE_COLUMN_RADIUS];
 BOOL active = [resultSet boolForColumn:GEOFENCE_COLUMN_ACTIVE];
 
 return [[ASGeoFence alloc] initWithDatabaseId:databaseId
 name:name
 latitude:latitude
 longitude:longitude
 radius:radius
 active:active];
 */

@end
