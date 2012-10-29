//
//  PongAppDelegate.m
//  Pong
//
//  Created by Barrett Anderson on 1/24/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import "PongAppDelegate.h"
#import "PongViewController.h"
#import <sqlite3.h>

@implementation PongAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
  self.window.rootViewController = self.viewController;

	//PongViewController.delegate = self;

	//[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];

	//NSLog(@"HIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
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

	//NSLog(@"HIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");

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
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	NSLog(@"WillTerminate");
	//NSLog(@"terminating..............................");
	[PongViewController writeData];
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
	[PongViewController writeData];
	NSLog(@"DidEnterBackground2");
	//exit(0);
	//NSLog(@"backgrounded..............................");
    // Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)dealloc
{
  NSLog(@"dealloc");
  [viewController release];
  NSLog(@"dealloc2");
  [window release];
  NSLog(@"dealloc3");
  [super dealloc];
	NSLog(@"dealloc4");
}

@end
