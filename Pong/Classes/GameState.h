//
//  GameState.h
//  Pong
//
//  Created by Lynn Nguyen on 10/28/12.
//
//

#import <Foundation/Foundation.h>


@interface GameState : NSObject

+ (GameState *)global;

@property (nonatomic) int state;
@property (nonatomic) int level;
@property (nonatomic) int numberOfLives;
@property (nonatomic) int myScore;
@property (nonatomic) int lastOutcome;
@property (nonatomic, readonly) NSArray *previousScores;

@property (nonatomic) int bX;
@property (nonatomic) int bY;
@property (nonatomic) int bZ;
@property (nonatomic) int bXSpeed;
@property (nonatomic) int bYSpeed;
@property (nonatomic) int bZSpeed;

@property (nonatomic) int xAcceleration;
@property (nonatomic) int yAcceleration;

@property (nonatomic) int eX;
@property (nonatomic) int eY;
@property (nonatomic) int pX;
@property (nonatomic) int pY;

@end
