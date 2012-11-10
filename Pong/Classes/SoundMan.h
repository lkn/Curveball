//
//  SoundMan.h
//  Pong
//
//  Created by Lynn Nguyen on 10/28/12.
//
//

#import <AudioToolbox/AudioServices.h>
#import <Foundation/Foundation.h>

// TODO: These should really go into functions but im lazy.
SystemSoundID mpPing;
SystemSoundID mpPong;
SystemSoundID mpBullseye;
SystemSoundID mpLost;
SystemSoundID mpLostshort;
SystemSoundID mpMenu;
SystemSoundID mpTarget;
SystemSoundID mpTargetbounce;
SystemSoundID mpWall1;
SystemSoundID mpWall2;
SystemSoundID mpWall3;
SystemSoundID mpWon;

@interface SoundMan : NSObject

+ (void)initSounds;
+ (void)playSound:(SystemSoundID)sound;

@end
