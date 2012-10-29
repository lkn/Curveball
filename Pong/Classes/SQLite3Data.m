//
//  SQLite3Data.m
//  Pong
//
//  Created by Lynn Nguyen on 10/28/12.
//
//  We should deprecate this.
//

#import "SQLite3Data.h"

#import <sqlite3.h>

@implementation SQLite3Data

+ (void)readData
{
	prefs = [[ NSMutableDictionary alloc] init];

	sqlite3 *database;
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
  {
		const char *sqlStatement = "select `name`,`val` from `pong` WHERE 1==1;";
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2(database,
                           sqlStatement,
                           -1,
                           &compiledStatement,
                           NULL) == SQLITE_OK)
    {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
      {
				NSString *aName =
            [NSString stringWithUTF8String:
                (char *)sqlite3_column_text(compiledStatement, 0)];
				NSString *aVal =
            [NSString stringWithUTF8String:
                (char *)sqlite3_column_text(compiledStatement, 1)];
				[prefs setObject:aVal forKey:aName];
			}
		}
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}

+ (void)writeData
{
	sqlite3 *database;

	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
  {
		NSEnumerator *enumerator = [ prefs keyEnumerator];
		NSString *key;
		while (key = [enumerator nextObject])
    {
			const char *sqlStatement =
          [[NSString stringWithFormat:
                @"INSERT INTO `pong` (`name`,`val`) VALUES ('%s','%s');",
                [key UTF8String],
                [[prefs objectForKey:key] UTF8String]] UTF8String];
			//sqlite3_stmt *compiledStatement;
			char *errMsg = "";
			if (sqlite3_exec(database,
                       sqlStatement,
                       NULL,
                       NULL,
                       &errMsg) == SQLITE_OK)
			{


			}

			sqlStatement =
          [[NSString stringWithFormat:
                @"UPDATE `pong` SET `val` = '%s' WHERE `name` = '%s';",
                [[prefs objectForKey:key] UTF8String],
                [key UTF8String]] UTF8String];
			//NSLog(@"%s",sqlStatement);
			//if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
			if (sqlite3_exec(database,
                       sqlStatement,
                       NULL,
                       NULL,
                       &errMsg) == SQLITE_OK)
			{
        
			}
			//sqlite3_finalize(compiledStatement);
		}
	}
	sqlite3_close(database);
}

+ (NSString *)stringFromPrefs:(NSString *)key def:(NSString*)def
{
	if ([prefs objectForKey:key] != nil)
  {
		return [prefs objectForKey:key];
  }

	return def;
}

+ (BOOL)boolFromPrefs:(NSString *)key def:(BOOL)def
{
	BOOL val = def;
	if ([prefs objectForKey:key] != nil)
	{
		//val = [prefs objectForKey:key];
		if ([[prefs objectForKey:key] isEqualToString:@"TRUE"])
    {
			val = TRUE;
    }
		else
    {
			val = FALSE;
    }
	}

	return val;
}

+ (int)intFromPrefs:(NSString *)key def:(int)def
{
	int val = def;
	if ([prefs objectForKey:key] != nil)
	{
		val = [[prefs objectForKey:key] intValue];
	}
	return val;
}

@end
