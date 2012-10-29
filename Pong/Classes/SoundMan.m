//
//  SoundMan.m
//  Pong
//
//  Created by Lynn Nguyen on 10/28/12.
//
//

#import "SoundMan.h"

#import "Preferences.h"


@implementation SoundMan

void playSound(SystemSoundID insound)
{
	if([Preferences global].shouldPlaySound) {
		AudioServicesPlaySystemSound(insound);
  }
}

@end
