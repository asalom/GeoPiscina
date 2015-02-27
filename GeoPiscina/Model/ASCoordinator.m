//
//  ASCoordinator.m
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "ASCoordinator.h"
#import "ASGeoFenceManager.h"
#import "ASEventManager.h"
#import "ASDatabaseManager.h"

@implementation ASCoordinator

+ (instancetype)sharedInstance {
    static dispatch_once_t onceMark;
    static ASCoordinator *sharedInstance = nil;
    
    dispatch_once(&onceMark, ^{
        sharedInstance = [[self alloc] init];
        [ASDatabaseManager sharedInstance];
        
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _geoFenceManager = [[ASGeoFenceManager alloc] init];
        _eventManager = [[ASEventManager alloc] init];
    }
    
    return self;
}

@end
