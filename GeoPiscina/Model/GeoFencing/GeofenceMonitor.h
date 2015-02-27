//
//  GeofenceMonitor.h
//  Geofening
//
//  Created by KH1386 on 10/8/13.
//  Copyright (c) 2013 KH1386. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface GeofenceMonitor : NSObject<CLLocationManagerDelegate>
+(GeofenceMonitor *) sharedObj;

-(void) addGeofence:(NSDictionary*) dict;
-(void) removeGeofence:(NSDictionary*) dict;
-(void) clearGeofences;
-(void) findCurrentFence;
-(BOOL)checkLocationManager;
@property CLLocationManager * locationManager;
@end
