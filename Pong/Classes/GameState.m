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

static const NSUInteger kMaxNumScoresToRecord = 7;

int compareScoreLines (const void *a, const void *b)
{
  NSLog(@"%s", __PRETTY_FUNCTION__);
	NSString ** aString = (NSString**)a;
	NSString ** bString = (NSString**)b;

	NSArray *scoreAArray = [*aString componentsSeparatedByString: @" "];
	NSArray *scoreBArray = [*bString componentsSeparatedByString: @" "];
  
	int av = [[scoreAArray objectAtIndex:1] intValue];
	int bv = [[scoreBArray objectAtIndex:1] intValue];

	return bv-av;
}

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

- (void)setLevel:(int)level {
  [SQLite3Data setInt:level forKey:@"level"];
}

- (int)numberOfLives {
  return [SQLite3Data intFromPrefs:@"lives" def:0];
}

- (void)setNumberOfLives:(int)numberOfLives {
  [SQLite3Data setInt:numberOfLives forKey:@"lives"];
}

- (int)myScore {
  return [SQLite3Data intFromPrefs:@"myScore" def:0];
}

- (void)setMyScore:(int)myScore {
  [SQLite3Data setInt:myScore forKey:@"myScore"];
}

- (int)lastOutcome {
  return [SQLite3Data intFromPrefs:@"lastOutcome" def:0];
}

- (void)setLastOutcome:(int)lastOutcome {
  [SQLite3Data setInt:lastOutcome forKey:@"lastOutcome"];
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

- (void)setBX:(int)bX {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", bX]
                  forKey:@"bX"];}

- (int)bY {
  return [SQLite3Data intFromPrefs:@"bY" def:0];
}

- (void)setBY:(int)bY {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", bY]
                  forKey:@"bY"];
}

- (int)bZ {
  return [SQLite3Data intFromPrefs:@"bZ" def:0];
}

- (void)setBZ:(int)bZ {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", bZ]
                  forKey:@"bZ"];
}

- (int)bXSpeed {
  return [SQLite3Data intFromPrefs:@"bXSpeed" def:0];
}

- (void)setBXSpeed:(int)bXSpeed {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", bXSpeed]
                  forKey:@"bXSpeed"];
}

- (int)bYSpeed {
  return [SQLite3Data intFromPrefs:@"bYSpeed" def:0];
}

- (void)setBYSpeed:(int)bYSpeed {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", bYSpeed]
                  forKey:@"bYSpeed"];
}

- (int)xAcceleration {
  return [SQLite3Data intFromPrefs:@"xAccel" def:0];
}

- (void)setXAcceleration:(int)xAcceleration {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", xAcceleration]
                  forKey:@"xAccel"];
}

- (int)yAcceleration {
  return [SQLite3Data intFromPrefs:@"yAccel" def:0];
}

-(void)setYAcceleration:(int)yAcceleration {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", yAcceleration]
                  forKey:@"yAccel"];
}

- (int)eX {
  return [SQLite3Data intFromPrefs:@"eX" def:0];
}

- (void)setEX:(int)eX {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", eX]
                  forKey:@"eX"];
}

- (int)eY {
  return [SQLite3Data intFromPrefs:@"eY" def:0];
}

- (void)setEY:(int)eY {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", eY]
                  forKey:@"eY"];
}

- (int)pX {
  return [SQLite3Data intFromPrefs:@"pX" def:0];
}

- (void)setPX:(int)pX {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", pX]
                  forKey:@"pX"];
}

- (int)pY {
  return [SQLite3Data intFromPrefs:@"pY" def:0];
}

- (void)setPY:(int)pY {
  [SQLite3Data setObject:[NSString stringWithFormat:@"%d", pY]
                  forKey:@"pY"];
}

- (void)recordMyScore {
  NSDateFormatter *date_formatter= [[[NSDateFormatter alloc] init] autorelease];
  [date_formatter setDateFormat:@"dd-MMM-yyyy"];
  NSString *date = [date_formatter stringFromDate:[NSDate date]];

  NSString *scoreLine =
      [NSString stringWithFormat:@"%s %d", [date UTF8String],
       [GameState global].myScore];

  NSString *scoreLines[15];
  scoreLines[0] = scoreLine;
  NSArray *prevScores = [GameState global].previousScores;
  int total = 1;
  for (int i=0; i < [prevScores count]; i++)
  {
    NSString *thisLine = [prevScores objectAtIndex:i];
    if (thisLine == NULL || [thisLine isEqualToString:@""])
      continue;
    scoreLines[i+1] = thisLine;
    total++;
  }

  // Order the scores from highest to lowest.
  qsort(scoreLines, total, sizeof(NSString *), compareScoreLines);

  NSString *scoresToSave = @"";
  for (int i=0; i < kMaxNumScoresToRecord && i < total; i++)
  {
    scoresToSave =
        [scoresToSave stringByAppendingFormat:@"%@\n", scoreLines[i]];
  }

  [prefs setObject:scoresToSave
            forKey:[NSString stringWithFormat:@"scores%d",
                    [Preferences global].difficulty]];
}

@end
