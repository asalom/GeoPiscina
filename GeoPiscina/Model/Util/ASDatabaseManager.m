//
//  ASDatabaseManager.m
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "ASDatabaseManager.h"
#import "ASGeoFenceManager.h"
#import "ASEventManager.h"

static NSString * const SQLITE_FILENAME = @"geofences.sqlite";

@interface ASDatabaseManager ()
@property (nonatomic, strong) FMDatabase *database;
@end

@implementation ASDatabaseManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceMark;
    static ASDatabaseManager *sharedInstance = nil;
    
    dispatch_once(&onceMark, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:SQLITE_FILENAME];
        self.database = [[FMDatabase alloc] initWithPath:path];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            NSLog(@"Creating database at %@", path);
            [self.database open];
            [self createDatabase];
        }
        
        else {
            NSLog(@"Opening database at %@", path);
            [self.database open];
        }

        FMResultSet *setToWAL = [_database executeQuery:@"PRAGMA journal_mode = WAL"];
        [setToWAL next];
        if (![@"wal" isEqualToString: [setToWAL stringForColumnIndex:0]]) {
            NSAssert(0, @"Unable to set SQLite journal_mode to WAL");
        }
    }
    
    return self;
}

- (void)createDatabase {
    // geofence
    NSMutableString *query = [NSMutableString new];
    [query appendFormat:@"CREATE TABLE %@ (", GEOFENCE_TABLE_NAME];
    [query appendFormat:@"%@ integer PRIMARY KEY NOT NULL,", GEOFENCE_COLUMN_ID];
    [query appendFormat:@"%@ TEXT NOT NULL,", GEOFENCE_COLUMN_NAME];
    [query appendFormat:@"%@ double NOT NULL,", GEOFENCE_COLUMN_LATITUDE];
    [query appendFormat:@"%@ double NOT NULL,", GEOFENCE_COLUMN_LONGITUDE];
    [query appendFormat:@"%@ integer NOT NULL,", GEOFENCE_COLUMN_RADIUS];
    [query appendFormat:@"%@ integer NOT NULL DEFAULT(0)", GEOFENCE_COLUMN_ACTIVE];
    [query appendString:@");"];
    
    NSLog(@"%@", query);
    [self.database executeUpdate:query];
    
    query = nil;
    query = [NSMutableString new];
    
    // event
    [query appendFormat:@"CREATE TABLE %@ (", EVENT_TABLE_NAME];
    [query appendFormat:@"%@ integer PRIMARY KEY NOT NULL,", EVENT_COLUMN_ID];
    [query appendFormat:@"%@ double NOT NULL,", EVENT_COLUMN_ENTRY_TIMESTAMP];
    [query appendFormat:@"%@ double,", EVENT_COLUMN_EXIT_TIMESTAMP];
    [query appendFormat:@"%@ integer NOT NULL,", EVENT_COLUMN_GEOFENCE];
    [query appendFormat:@"FOREIGN KEY(%@) REFERENCES %@ (%@)", EVENT_COLUMN_GEOFENCE, GEOFENCE_TABLE_NAME, GEOFENCE_COLUMN_ID];
    [query appendString:@");"];
    
    NSLog(@"%@", query);
    [self.database executeUpdate:query];
    
    [self populateDefaultData];
}

- (void)populateDefaultData {
    NSMutableString *query = [NSMutableString new];
    [query appendFormat:@"INSERT INTO %@ ", GEOFENCE_TABLE_NAME];
    [query appendFormat:@"(%@, %@, %@, %@, %@) VALUES ", GEOFENCE_COLUMN_NAME, GEOFENCE_COLUMN_LATITUDE, GEOFENCE_COLUMN_LONGITUDE, GEOFENCE_COLUMN_RADIUS, GEOFENCE_COLUMN_ACTIVE];
    [query appendString:@"('Piscina', 49.640228, 8.361498, 65, 1);"];
    
    NSLog(@"%@", query);
    [self.database executeUpdate:query];
}

- (NSInteger)lastInsertedRowId {
    return self.database.lastInsertRowId;
}

- (FMResultSet *)executeQuery:(NSString *)query {
    return [self.database executeQuery:query];
}

- (BOOL)executeUpdate:(NSString *)query {
    return [self.database executeUpdate:query];
}

@end
