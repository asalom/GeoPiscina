//
//  ASGeoFence.h
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASEvent;
#import <FMDB/FMDatabase.h>

@interface ASGeoFence : NSObject

@property (nonatomic, readonly) NSInteger databaseId;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (nonatomic, readonly) NSInteger radius;
@property (nonatomic, readonly) BOOL active;
@property (nonatomic, readonly, strong) NSArray *events;
@property (nonatomic, readonly, getter=isValid) BOOL valid;

- (instancetype)initWithDatabaseId:(NSInteger)databaseId
                              name:(NSString *)name
                          latitude:(double)latitude
                         longitude:(double)longitude
                            radius:(NSInteger)radius
                            active:(BOOL)active;

- (NSArray *)eventsForDate:(NSDate *)date;
- (void)addEvent:(ASEvent *)event;
- (void)deleteEvent:(ASEvent *)event;

@end
