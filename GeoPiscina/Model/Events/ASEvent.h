//
//  ASEvent.h
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "CKCalendarEvent.h"
@class ASGeoFence;

@interface ASEvent : CKCalendarEvent
@property (nonatomic, readwrite) NSInteger databaseId;
@property (nonatomic, readonly, copy) NSDate *entryDate;
@property (nonatomic, readwrite, copy) NSDate *exitDate;
@property (nonatomic, readonly, strong) ASGeoFence *geoFence;
@property (nonatomic, readonly, getter=isValid) BOOL valid;

- (instancetype)initWithDatabaseId:(NSInteger)databaseId
                         entryDate:(NSDate *)entryDate
                          exitDate:(NSDate *)exitDate
                          geoFence:(ASGeoFence *)geoFence;

- (instancetype)initWithEntryDate:(NSDate *)entryDate
                         geoFence:(ASGeoFence *)geoFence;

@end
