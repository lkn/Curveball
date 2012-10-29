//
//  Preferences.m
//  Pong
//
//  Created by Lynn Nguyen on 10/28/12.
//
//

#import "Preferences.h"

#import "SQLite3Data.h"

static Preferences *gPreferences;

@implementation Preferences

@synthesize gameType = gameType_;
@synthesize shouldPlaySound = shouldPlaySound_;
@synthesize shouldShowFog = shouldShowFog_;
@synthesize paddlePositionX = paddlePositionX_;
@synthesize paddlePositionY = paddlePositionY_;
@synthesize difficulty = difficulty_;
@synthesize inputMethod = inputMethod_;

+ (Preferences *)global
{
  @synchronized (self)
  {
    if (!gPreferences) {
      gPreferences = [[self alloc] init];
    }
  }

  return gPreferences;
}

- (int)gameType {
  return [SQLite3Data intFromPrefs:@"gameType" def:0];
}

- (BOOL)shouldPlaySound {
  return [SQLite3Data boolFromPrefs:@"sound" def:TRUE];
}

- (BOOL)shouldVibrate {
  return [SQLite3Data boolFromPrefs:@"vibrate" def:TRUE];
}

- (BOOL)shouldShowFog {
  return [SQLite3Data boolFromPrefs:@"fog" def:TRUE];
}

- (int)paddlePositionX {
  return [SQLite3Data intFromPrefs:@"holdPaddleX" def:0];
}

- (void)setPaddlePositionX:(int)paddlePositionX {
  [prefs setObject:[NSString stringWithFormat:@"%d", paddlePositionX]
            forKey:@"holdPaddleX"];
}

- (int)paddlePositionY {
  return [SQLite3Data intFromPrefs:@"holdPaddleY" def:0];
}

- (void)setPaddlePositionY:(int)paddlePositionY {
  [prefs setObject:[NSString stringWithFormat:@"%d", paddlePositionY]
            forKey:@"holdPaddleY"];
}

- (int)difficulty {
  return [SQLite3Data intFromPrefs:@"difficulty" def:0];
}

- (int)inputMethod {
  return [SQLite3Data intFromPrefs:@"inputMethod" def:0];
}

@end
