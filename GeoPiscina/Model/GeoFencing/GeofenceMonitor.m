//
//  GeofenceMonitor.m
//  Geofening
//
//  Created by KH1386 on 10/8/13.
//  Copyright (c) 2013 KH1386. All rights reserved.
//

#import "GeofenceMonitor.h"

#import "ASEventManager.h"
#import "ASGeoFenceManager.h"
#import "ASCoordinator.h"
#import "ASGeoFence.h"
#import "ASEvent.h"

@implementation GeofenceMonitor
@synthesize locationManager;
+(GeofenceMonitor *) sharedObj
{
    
    static GeofenceMonitor * shared =nil;
    
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        shared = [[GeofenceMonitor alloc] init];
    });
    return shared;
}

- (CLRegion*)dictToRegion:(NSDictionary*)dictionary
{
    NSString *identifier = [dictionary valueForKey:@"identifier"];
    CLLocationDegrees latitude = [[dictionary valueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationDistance regionRadius = [[dictionary valueForKey:@"radius"] doubleValue];
    
    if(regionRadius > locationManager.maximumRegionMonitoringDistance)
    {
        regionRadius = locationManager.maximumRegionMonitoringDistance;
    }
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    CLRegion * region =nil;
    
    if([version floatValue] >= 7.0f) //for iOS7
    {
        region =  [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                   radius:regionRadius
                                               identifier:identifier];
    }
    else // iOS 7 below
    {
        region = [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate
                                                       radius:regionRadius
                                                   identifier:identifier];
    }
    return  region;
}

-(id) init
{
    self = [super init];
    if(self)
    {

        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
    }
    return self;
}
-(void) showMessage:(NSString *) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Geofence"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:Nil, nil];
    
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    
    [alertView show];
    
    
}
-(BOOL) checkLocationManager
{
    [locationManager requestAlwaysAuthorization];
    return YES;
    if(![CLLocationManager locationServicesEnabled])
    {
        [self showMessage:@"You need to enable Location Services"];
        return  FALSE;
    }
    if(![CLLocationManager isMonitoringAvailableForClass:self.class])
    {
        [self showMessage:@"Region monitoring is not available for this Class"];
                return  FALSE;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        [self showMessage:@"You need to authorize Location Services for the APP"];
        return  FALSE;
    }
    return TRUE;
}
-(void) addGeofence:(NSDictionary*) dict
{

    CLRegion * region = [self dictToRegion:dict];
    [locationManager startMonitoringForRegion:region];
}
-(void) findCurrentFence
{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if([version floatValue] >= 7.0f) //for iOS7
    {
        NSArray * monitoredRegions = [locationManager.monitoredRegions allObjects];
        for(CLRegion *region in monitoredRegions)
         {
             [locationManager requestStateForRegion:region];
         }
    }
    else
    {
        [locationManager startUpdatingLocation];
    }

}
-(void) removeGeofence:(NSDictionary*) dict
{
    CLRegion * region = [self dictToRegion:dict];
    [locationManager stopMonitoringForRegion:region];

}
-(void) clearGeofences
{
    NSArray * monitoredRegions = [locationManager.monitoredRegions allObjects];
    for(CLRegion *region in monitoredRegions) {
        [locationManager stopMonitoringForRegion:region];
    }
}



/*
    Delegate Methods
 */

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {
        NSString *alert = [NSString stringWithFormat:@"##Entered Region - %@", region.identifier];
        NSLog(@"%@", alert);
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        notification.alertBody = alert;
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    else if(state == CLRegionStateOutside)
    {
        NSString *alert = [NSString stringWithFormat:@"##Exited Region - %@", region.identifier];
        NSLog(@"%@", alert);
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        notification.alertBody = alert;
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    else{
        NSLog(@"##Unknown state  Region - %@", region.identifier);
    }
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Started monitoring %@ region", region.identifier);
}


/*
 "ARRIVAL_ALERT" = "Welcome to the swimming pool! It's";
 "LEAVING_ALERT" = "Bye! You were swimming for";
 */


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSDate *now = [NSDate new];
    ASGeoFence *geoFence = [ASCoordinator sharedInstance].geoFenceManager.activeGeoFence;
    ASEvent *event = [[ASEvent alloc] initWithEntryDate:now
                                               geoFence:geoFence];
    if ([geoFence eventsForDate:now].count == 0) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        [[ASCoordinator sharedInstance].geoFenceManager.activeGeoFence addEvent:event];
        //NSString *alert = [NSString stringWithFormat:@"##Entered Region - %@", region.identifier];
        NSString *alert = [NSString stringWithFormat:@"%@ %@", Localized(@"ARRIVAL_ALERT"), [formatter stringFromDate:now]];
        NSLog(@"%@", alert);
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = alert;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    ASGeoFence *geoFence = [ASCoordinator sharedInstance].geoFenceManager.activeGeoFence;
    NSDate *now = [NSDate new];
    NSArray *events = [geoFence eventsForDate:now];
    //if (events.count > 0 && event.exitDate == nil) {
    if (events.count > 0) {
        ASEvent *event = events[0];
        
        if (event.exitDate == nil) {
            //NSString *alert = [NSString stringWithFormat:@"##Exited Region - %@", region.identifier];
            [geoFence addExitForEvent:event exit:now];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"HH:mm"];
            NSTimeInterval interval = [now timeIntervalSinceDate:event.entryDate];
            int hours = (int)interval / 3600;             // integer division to get the hours part
            int minutes = (interval - (hours*3600)) / 60; // interval minus hours part (in seconds) divided by 60 yields minutes
            NSString *timeDiff = [NSString stringWithFormat:@"%d:%02d", hours, minutes];
            NSString *alert = [NSString stringWithFormat:@"%@ %@", Localized(@"LEAVING_ALERT"), timeDiff];

            NSLog(@"%@", alert);
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = alert;
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    static BOOL firstTime=TRUE;
    
    if(firstTime)
    {
        firstTime = FALSE;
        NSSet * monitoredRegions = locationManager.monitoredRegions;
        if(monitoredRegions)
        {
            [monitoredRegions enumerateObjectsUsingBlock:^(CLRegion *region,BOOL *stop)
             {
                 NSString *identifer = region.identifier;
                 CLLocationCoordinate2D centerCoords =region.center;
                 CLLocationCoordinate2D currentCoords= CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
                 CLLocationDistance radius = region.radius;
                 
                 NSNumber * currentLocationDistance =[self calculateDistanceInMetersBetweenCoord:currentCoords coord:centerCoords];
                 if([currentLocationDistance floatValue] < radius)
                 {
                         NSLog(@"Invoking didEnterRegion Manually for region: %@",identifer);

                        //stop Monitoring Region temporarily
                         [locationManager stopMonitoringForRegion:region];
                     
                         [self locationManager:locationManager didEnterRegion:region];
                         //start Monitoing Region
                         [locationManager startMonitoringForRegion:region];
                 }
             }];
        }
        //Stop Location Updation, we dont need it now.
        [locationManager stopUpdatingLocation];

    }
}

//Helper Functions.
- (NSNumber*)calculateDistanceInMetersBetweenCoord:(CLLocationCoordinate2D)coord1 coord:(CLLocationCoordinate2D)coord2 {
    NSInteger nRadius = 6371; // Earth's radius in Kilometers
    double latDiff = (coord2.latitude - coord1.latitude) * (M_PI/180);
    double lonDiff = (coord2.longitude - coord1.longitude) * (M_PI/180);
    double lat1InRadians = coord1.latitude * (M_PI/180);
    double lat2InRadians = coord2.latitude * (M_PI/180);
    double nA = pow ( sin(latDiff/2), 2 ) + cos(lat1InRadians) * cos(lat2InRadians) * pow ( sin(lonDiff/2), 2 );
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = nRadius * nC;
    // convert to meters
    return @(nD*1000);
}



@end
