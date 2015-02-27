//
//  ASEvent.m
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "ASEvent.h"
#import "ASGeoFence.h"
#import "NSDate+Components.h"

@interface ASEvent ()
@property (nonatomic, readwrite, copy) NSDate *entryDate;
@property (nonatomic, readwrite, strong) ASGeoFence *geoFence;
@end

@implementation ASEvent

- (instancetype)initWithDatabaseId:(NSInteger)databaseId
                         entryDate:(NSDate *)entryDate
                          exitDate:(NSDate *)exitDate
                          geoFence:(ASGeoFence *)geoFence {
    if (self = [super init]) {
        self.databaseId = databaseId;
        self.entryDate = entryDate;
        self.exitDate = exitDate;
        self.geoFence = geoFence;
    }
    
    return self;
}

- (instancetype)initWithEntryDate:(NSDate *)entryDate
                         geoFence:(ASGeoFence *)geoFence {
    if (self = [super init]) {
        self.entryDate = entryDate;
        self.geoFence = geoFence;
    }
    
    return self;
}

- (BOOL)isValid {
    return self.entryDate != nil && self.geoFence != nil;
}

- (NSString *)title {
    return self.geoFence.name;
}

- (NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.entryDate];
    NSDate *date = [NSDate dateWithDay:components.day month:components.month year:components.year];
    return date;
}

@end
