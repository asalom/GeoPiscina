//
//  ASCalendarViewController.h
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 19/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MBCalendarKit/CalendarKit.h>

@interface ASCalendarViewController : UIViewController <CKCalendarViewDelegate, CKCalendarViewDataSource, CLLocationManagerDelegate>

@end
