//
//  Preferences.h
//  Pong
//
//  Created by Lynn Nguyen on 10/28/12.
//
//

#import <Foundation/Foundation.h>


@interface Preferences : NSObject

+ (Preferences *)global;

@property (nonatomic) int gameType;
@property (nonatomic) BOOL shouldPlaySound;
@property (nonatomic) BOOL shouldVibrate;
@property (nonatomic) BOOL shouldShowFog;

@property (nonatomic) int paddlePositionX;
@property (nonatomic) int paddlePositionY;

@property (nonatomic) int difficulty;
@property (nonatomic) int inputMethod;

@end
