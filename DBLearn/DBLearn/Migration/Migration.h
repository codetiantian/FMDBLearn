//
//  Migration.h
//  DBLearn
//
//  Created by 这个夏天有点冷 on 2017/6/6.
//  Copyright © 2017年 YLT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBMigrationManager.h"

@interface Migration : NSObject <FMDBMigrating>

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) uint64_t version;

- (instancetype)initWithName:(NSString *)name andVersion:(uint64_t)version andExecuteUpdateArray:(NSArray *)updateArray;

- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error;

@end
