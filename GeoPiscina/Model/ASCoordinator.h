//
//  ASCoordinator.h
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASGeoFenceManager;
@class ASEventManager;

@interface ASCoordinator : NSObject
@property (nonatomic, strong) ASGeoFenceManager *geoFenceManager;
@property (nonatomic, strong) ASEventManager *eventManager;

+ (instancetype)sharedInstance;
@end
