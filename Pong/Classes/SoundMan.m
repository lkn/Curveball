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

+ (void)initSounds {
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("bullseye"),
                              CFSTR("caf"),
                              NULL),
      &mpBullseye);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("lostshort"),
                              CFSTR("caf"),
                              NULL),
      &mpLostshort);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("ping"),
                              CFSTR("caf"),
                              NULL),
      &mpPing);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("target"),
                              CFSTR("caf"),
                              NULL),
      &mpTarget);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("wall1"),
                              CFSTR("caf"),
                              NULL),
      &mpWall1);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("wall3"),
                              CFSTR("caf"),
                              NULL),
      &mpWall3);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("lost"),
                              CFSTR("caf"),
                              NULL),
      &mpLost);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("menu"),
                              CFSTR("caf"),
                              NULL),
      &mpMenu);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("pong"),
                              CFSTR("caf"),
                              NULL),
      &mpPong);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("targetbounce"),
                              CFSTR("caf"),
                              NULL),
      &mpTargetbounce);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("wall2"),
                              CFSTR("caf"),
                              NULL),
      &mpWall2);
	AudioServicesCreateSystemSoundID(
      CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                              CFSTR("won"),
                              CFSTR("caf"),
                              NULL),
      &mpWon);
  //AudioServicesPlaySystemSound(mpBullseye);
}

+ (void)playSound:(SystemSoundID)insound {
	if ([Preferences global].shouldPlaySound) {
		AudioServicesPlaySystemSound(insound);
  }
}

@end
