//
//  ASGeoFence.m
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "ASGeoFence.h"
#import "ASCoordinator.h"
#import "ASGeoFenceManager.h"
#import "ASEventManager.h"
#import "ASEvent.h"

@interface ASGeoFence ()
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite) double latitude;
@property (nonatomic, readwrite) double longitude;
@property (nonatomic, readwrite) NSInteger radius;
@property (nonatomic, readwrite) BOOL active;
@end

@implementation ASGeoFence

- (instancetype)initWithDatabaseId:(NSInteger)databaseId
                              name:(NSString *)name
                          latitude:(double)latitude
                         longitude:(double)longitude
                            radius:(NSInteger)radius
                            active:(BOOL)active {
    if (self = [super init]) {
        self.databaseId = databaseId;
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.radius = radius;
        self.active = active;
    }
    return self;
}

- (NSArray *)eventsForDate:(NSDate *)date {
    return [[ASCoordinator sharedInstance].eventManager eventsForDate:date geoFence:self];
}

- (void)addEvent:(ASEvent *)event {
    [[ASCoordinator sharedInstance].eventManager addEvent:event];
}

- (void)addExitForEvent:(ASEvent *)event exit:(NSDate *)date {
    [[ASCoordinator sharedInstance].eventManager addExitForEvent:event exit:date];
}

- (void)deleteEvent:(ASEvent *)event {
    [[ASCoordinator sharedInstance].eventManager deleteEvent:event];
}

- (BOOL)isValid {
    return self.latitude != 0.0 && self.longitude != 0.0 && self.name != nil;
}

@end
