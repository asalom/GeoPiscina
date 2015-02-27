//
//  ASGeoFenceManager.h
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASGeoFence;

extern NSString * const GEOFENCE_TABLE_NAME;
extern NSString * const GEOFENCE_COLUMN_ID;
extern NSString * const GEOFENCE_COLUMN_NAME;
extern NSString * const GEOFENCE_COLUMN_LATITUDE;
extern NSString * const GEOFENCE_COLUMN_LONGITUDE;
extern NSString * const GEOFENCE_COLUMN_RADIUS;
extern NSString * const GEOFENCE_COLUMN_ACTIVE;

@interface ASGeoFenceManager : NSObject

@property (nonatomic, strong) ASGeoFence *activeGeoFence;
@property (nonatomic, strong) NSArray *allGeoFences;

- (void)deleteGeoFence:(ASGeoFence *)geoFence;
- (void)addGeoFence:(ASGeoFence *)geoFence;

@end
