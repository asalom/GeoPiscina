//
//  ASGeoFenceManager.m
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "ASGeoFenceManager.h"
#import "ASDatabaseManager.h"
#import "ASGeoFence.h"
#import <FMDB/FMDatabase.h>

NSString * const GEOFENCE_TABLE_NAME = @"geofence";
NSString * const GEOFENCE_COLUMN_ID = @"id";
NSString * const GEOFENCE_COLUMN_NAME = @"name";
NSString * const GEOFENCE_COLUMN_LATITUDE = @"latitude";
NSString * const GEOFENCE_COLUMN_LONGITUDE = @"longitude";
NSString * const GEOFENCE_COLUMN_RADIUS = @"radius";
NSString * const GEOFENCE_COLUMN_ACTIVE = @"active";

@implementation ASGeoFenceManager

- (void)deleteGeoFence:(ASGeoFence *)geoFence {
    NSAssert(false, @"not implemented");
}

- (void)addGeoFence:(ASGeoFence *)geoFence {
    NSAssert(false, @"not implemented");
}

- (ASGeoFence *)activeGeoFence {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = 1;", GEOFENCE_TABLE_NAME, GEOFENCE_COLUMN_ACTIVE];
    FMResultSet *resultSet = [[ASDatabaseManager sharedInstance] executeQuery:query];
    if ([resultSet next]) {
        return [self geoFenceFromResultSet:resultSet];
    }
    
    else {
        NSAssert(false, @"There is no active geofence!!!");
    }
    
    return nil;
}

- (ASGeoFence *)geoFenceFromResultSet:(FMResultSet *)resultSet {
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
}

@end
