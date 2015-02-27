//
//  ASCalendarViewController.m
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 19/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "ASCalendarViewController.h"
#import "GeofenceMonitor.h"
#import "NSDate+Components.h"
#import "ASGeoFenceManager.h"
#import "ASEventManager.h"
#import "ASCoordinator.h"
#import "ASGeoFence.h"
#import "ASEvent.h"

@interface ASCalendarViewController ()
@property (weak, nonatomic) IBOutlet UIView *calendarContainerView;
@property (nonatomic, strong) NSMutableDictionary *data;
@end

@implementation ASCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. Instantiate a CKCalendarView
    CKCalendarView *calendar = [CKCalendarView new];
    
    // 2. Optionally, set up the datasource and delegates
    [calendar setDelegate:self];
    [calendar setDataSource:self];
    
    // 3. Present the calendar
    [[self calendarContainerView] addSubview:calendar];
    
    
    self.data = [[NSMutableDictionary alloc] init];
//    NSString *title = NSLocalizedString(@"Release MBCalendarKit 2.2.4", @"");
//    NSDate *date = [NSDate dateWithDay:17 month:2 year:2015];
//    CKCalendarEvent *releaseUpdatedCalendarKit = [CKCalendarEvent eventWithTitle:title andDate:date andInfo:nil];
//    
//    NSString *title2 = NSLocalizedString(@"The Hunger Games: Mockingjay, Part 1", @"");
//    NSDate *date2 = [NSDate dateWithDay:18 month:2 year:2015];
//    CKCalendarEvent *mockingJay = [CKCalendarEvent eventWithTitle:title2 andDate:date2 andInfo:nil];
//    
//    //NSString *title3 = NSLocalizedString(@"Integrate MBCalendarKit", @"");
//    //NSDate *date3 = date2;
//    //CKCalendarEvent *integrationEvent = [CKCalendarEvent eventWithTitle:title3 andDate:date3 andInfo:nil];
//    
//    //    4.  Add the events to the backing dictionary.
//    //        The keys are NSDate objects that must
//    //        match the ones passed data source method.
//    self.data[date] = @[releaseUpdatedCalendarKit];
//    self.data[date2] = @[mockingJay];     // multiple events on one date.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    GeofenceMonitor  * gfm = [GeofenceMonitor sharedObj];
    
    // 49.640228, 8.361498
    NSMutableDictionary * fence = [NSMutableDictionary new];
    [fence setValue:@"Piscina" forKey:@"identifier"];
    [fence setValue:@"49.640228" forKey:@"latitude"];
    [fence setValue:@"8.361498" forKey:@"longitude"];
    [fence setValue:@"65" forKey:@"radius"];
    
    if([gfm checkLocationManager]) {
        [gfm addGeofence:fence];
        [gfm findCurrentFence];
    }

}

#pragma mark - CKCalendarViewDelegate
- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date {
    NSArray *eventsForDate = [[ASCoordinator sharedInstance].geoFenceManager.activeGeoFence eventsForDate:date];
    if (eventsForDate.count > 0) {
        [[ASCoordinator sharedInstance].geoFenceManager.activeGeoFence deleteEvent:eventsForDate[0]];
    }
    
    else {
        ASEvent *event = [[ASEvent alloc] initWithEntryDate:date
                                                   geoFence:[ASCoordinator sharedInstance].geoFenceManager.activeGeoFence];
        [[ASCoordinator sharedInstance].geoFenceManager.activeGeoFence addEvent:event];
//        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
//        NSDate *date = [NSDate dateWithDay:components.day month:components.month year:components.year];
//        CKCalendarEvent *event = [CKCalendarEvent eventWithTitle:@"Piscina" andDate:date andInfo:nil];
//        self.data[date] = @[event];
    }
    [calendarView reload];
}

#pragma mark - CKCalendarViewDataSource
- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date {
    return [[ASCoordinator sharedInstance].geoFenceManager.activeGeoFence eventsForDate:date];
    //return [self data][date];
}

@end
