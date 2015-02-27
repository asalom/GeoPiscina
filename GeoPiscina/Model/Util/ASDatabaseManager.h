//
//  ASDatabaseManager.h
//  GeoPiscina
//
//  Created by Alexandre Salom Fernandez on 20/2/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>

@interface ASDatabaseManager : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)lastInsertedRowId;
- (FMResultSet *)executeQuery:(NSString *)query;
- (BOOL)executeUpdate:(NSString *)query;

@end
