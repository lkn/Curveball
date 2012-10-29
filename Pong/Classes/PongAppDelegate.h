//
//  PongAppDelegate.h
//  Pong
//
//  Created by Barrett Anderson on 1/24/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PongViewController;

@interface PongAppDelegate : NSObject <UIApplicationDelegate>
//@property (readwrite) int pX;
//@property (readwrite) int pY;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PongViewController *viewController;

@end

