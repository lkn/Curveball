//
//  SQLite3Data.h
//  Pong
//
//  Created by Lynn Nguyen on 10/28/12.
//
//

#import <Foundation/Foundation.h>


NSMutableDictionary *prefs;
NSString *databaseName;
NSString *databasePath;

@interface SQLite3Data : NSObject

+ (void)readData;
+ (void)writeData;

+ (NSString *)stringFromPrefs:(NSString *)key def:(NSString *)def;
+ (BOOL)boolFromPrefs:(NSString *)key def:(BOOL)def;
+ (int)intFromPrefs:(NSString *)key def:(int)def;

@end
