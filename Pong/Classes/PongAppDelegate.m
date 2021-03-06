//
//  PongAppDelegate.m
//  Pong
//
//  Created by Barrett Anderson on 1/24/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import "PongAppDelegate.h"

#import <sqlite3.h>

#import "PongViewController.h"
#import "SQLite3Data.h"


@implementation PongAppDelegate

@synthesize window = window_;
@synthesize viewController = viewController_;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
  self.window.rootViewController = self.viewController;

	//PongViewController.delegate = self;

	databaseName = @"pongStore.sql";

	NSArray *documentPaths =
      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                          NSUserDomainMask,
                                          YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *tDatabasePath =
      [documentsDir stringByAppendingPathComponent:databaseName];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];

	[databasePath retain];
	[databaseName retain];

	//NSLog(@"%s",[databaseName UTF8String]);
	//NSLog(@"%s",[databasePath UTF8String]);

	NSFileManager *fileManager = [NSFileManager defaultManager];

	// Check if the database has already been created in the users filesystem
	if (![fileManager fileExistsAtPath:tDatabasePath])
	{
		//NSLog(@"file doesn't exist");
		// Get the path to the database in the application package
		NSString *databasePathFromApp =
        [[[NSBundle mainBundle] resourcePath]
            stringByAppendingPathComponent:databaseName];

		// Copy the database from the package to the users filesystem
		[fileManager copyItemAtPath:databasePathFromApp
                         toPath:tDatabasePath
                          error:nil];
	}

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	NSLog(@"WillResignActive");
  [self.viewController stopAnimation];
	NSLog(@"WillResignActive2");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSLog(@"DidBecomeActive");
  [self.viewController startAnimation];
	NSLog(@"DidBecomeActive2");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"WillTerminate");
	//NSLog(@"terminating..............................");
	[SQLite3Data writeData];
	NSLog(@"WillTerminate2");
	//NSLog(@"terminated..............................");
  [self.viewController stopAnimation];
	PongViewController.running = FALSE;
	NSLog(@"WillTerminate3");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	NSLog(@"DidEnterBackground");
	//NSLog(@"background..............................");
	[SQLite3Data writeData];
	NSLog(@"DidEnterBackground2");
	//exit(0);
	//NSLog(@"backgrounded..............................");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)dealloc
{
  NSLog(@"dealloc");
  [viewController_ release];
  NSLog(@"dealloc2");
  [window_ release];
  NSLog(@"dealloc3");
  [super dealloc];
	NSLog(@"dealloc4");
}

@end
