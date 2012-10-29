//
//  GameState.m
//  Pong
//
//  Created by Lynn Nguyen on 10/28/12.
//
//

#import "GameState.h"

#import "Preferences.h"
#import "SQLite3Data.h"


static GameState *gState;

@implementation GameState

@synthesize state = state_;
@synthesize level = level_;
@synthesize numberOfLives = numberOfLives_;
@synthesize myScore = myScore_;
@synthesize lastOutcome = lastOutcome_;
@synthesize previousScores = previousScores_;

@synthesize bX = bX_;
@synthesize bY = bY_;
@synthesize bZ = bZ_;
@synthesize bXSpeed = bXSpeed_;
@synthesize bYSpeed = bYSpeed_;
@synthesize bZSpeed = bZSpeed_;

@synthesize xAcceleration = xAcceleration_;
@synthesize yAcceleration = yAcceleration_;

@synthesize eX = eX_;
@synthesize eY = eY_;
@synthesize pX = pX_;
@synthesize pY = pY_;

+ (GameState *)global
{
  @synchronized (self)
  {
    if (!gState)
    {
      gState = [[self alloc] init];
    }
  }

  return gState;
}

- (int)state {
  return [SQLite3Data intFromPrefs:@"state" def:0];
}

- (int)level {
  return [SQLite3Data intFromPrefs:@"level" def:0];
}

- (int)numberOfLives {
  return [SQLite3Data intFromPrefs:@"lives" def:0];
}

- (int)myScore {
  return [SQLite3Data intFromPrefs:@"myScore" def:0];
}

- (int)lastOutcome {
  return [SQLite3Data intFromPrefs:@"lastOutcome" def:0];
}

- (NSArray *)previousScores {
  NSString *str = [NSString stringWithFormat:@"scores%d",
                      [Preferences global].difficulty];
  NSString *prevScoresString = [SQLite3Data stringFromPrefs:str
                                                        def:@""];
  return [prevScoresString componentsSeparatedByString:@"\n"];
}

- (int)bX {
  return [SQLite3Data intFromPrefs:@"bX" def:0];
}

- (int)bY {
  return [SQLite3Data intFromPrefs:@"bY" def:0];
}

- (int)bZ {
  return [SQLite3Data intFromPrefs:@"bZ" def:0];
}

- (int)bXSpeed {
  return [SQLite3Data intFromPrefs:@"bXSpeed" def:0];
}

- (int)bYSpeed {
  return [SQLite3Data intFromPrefs:@"bZSpeed" def:0];
}

- (int)xAcceleration {
  return [SQLite3Data intFromPrefs:@"xAccel" def:0];
}

- (int)yAcceleration {
  return [SQLite3Data intFromPrefs:@"yAccel" def:0];
}

- (int)eX {
  return [SQLite3Data intFromPrefs:@"eX" def:0];
}

- (int)eY {
  return [SQLite3Data intFromPrefs:@"eY" def:0];
}

- (int)pX {
  return [SQLite3Data intFromPrefs:@"pX" def:0];
}

- (int)pY {
  return [SQLite3Data intFromPrefs:@"pY" def:0];
}

@end
