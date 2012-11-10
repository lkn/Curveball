//
//  PongViewController.h
//  Pong
//
//  Created by Barrett Anderson on 1/24/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import <UIKit/UIKit.h>

#import "Button.h"
#import "FontTexture.h"
#import "PongAppDelegate.h"
#import "TextureCoord.h"


@interface PongViewController : UIViewController {
	EAGLContext *context;
  GLuint program;
  
  BOOL animating;
  NSInteger animationFrameInterval;
  CADisplayLink *displayLink;
	PongAppDelegate *delegate;
}

enum States {
  HOME,
  PLAYING,
  OPTIONS,
  PAUSED,
  MULTIPLAYER,
  JOINIP,
  ERROR,
  START,
  RESULTS,
  TARGET,
  OPTIONS2,
  NONE
};

- (void)resize:(int)w h:(int)h;
+ (void)switchToState:(enum States)toState;

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

void setUpFonts();

//static void drawString(NSString * str,int x,int y,int size);
+ (void)drawString:(NSString *)str x:(int)x y:(int)y size:(int)size;
+ (void)drawStringAlignRight:(NSString *)str x:(int)inx y:(int)y size:(int)size;
//static int width,height,gwidth,gheight,floatWidth,floatHeight,hFloatWidth,hFloatHeight;
+(NSString *)sem;
- (void)startAnimation;
- (void)stopAnimation;
+(int)width;
-(GLuint)LoadTexture:(NSString*)filename;

+(NSString*)myIP;
+(Button*)hoveredButton;
+(TextureCoord**)button;
+(TextureCoord**)button2;
+(TextureCoord**)button3;
//+(Button*[20][40])stateButtons;
+(int)floatWidth;
+(int)floatHeight;
+(BOOL)running;

+(int)hFloatWidth;
+(int)hFloatHeight;
+(int)freeLevels;
+(int)realWidth;
+(int)realHeight;

+(int)previewX;
+(int)previewY;
+(int*)sinTable;
+(int*)cosTable;
+(int*)fontStarts;
+(int*)medFontStarts;
+(int*)fontSizes;
+(BOOL)inPreview;
+(BOOL)waitingForOp;
+(int)texBall;
+(int*)mxs;
+(int*)mys;
+(BOOL)tellOpponent;
+(int)smallTexFont;
+(int)medTexFont;
+(int)bigTexFont;
+(int)texTileset;
+(int)mIndexCount;

+(int)fontSize;
+(int)multiPlayerStatus;
+(int)ballRadius;

+(int)enScore;

+(int)lastOutcome;
+(int)paddleHeight;
+(int)paddleWidth;
+(int)hPaddleHeight;
+(int)hPaddleWidth;
+(BOOL)iLost;

+(int)multiplier;
+(int)divisor;
+(int)tileset1;
+(int)eSpeed;
+(int)randEnemy;
+(BOOL)didSounds;

+(enum States)state;
+(enum States)lastDownState;
+(int*)eSpeeds;
+(int*)bZSpeeds;
+(int*)randEnemies;
+(long)lastTouchEvent;
+(BOOL)ipValid;
+(GLfloat*)fontBoxInt;
+(int*)shadowInt;
+(int*)paddleInt;
+(int*)boxInt;
+(int*)fontTexCoords;
+(int*)texCoordsInt;
//FontTexture * fontTextures[128];
+(FontTexture**)fontTextures;

+(void)setRunning:(BOOL) inp;
+(void)setFreeLevels:(int) inp;
+(void)setRealWidth:(int) inp;
+(void)setRealHeight:(int) inp;
+(void)setPreviewX:(int) inp;
+(void)setPreviewY:(int) inp;
+(void)setInPreview:(BOOL) inp;
+(void)setWaitingForOp:(BOOL) inp;
+(void)setTexBall:(int) inp;
+(void)setTellOpponent:(BOOL) inp;
+(void)setSmallTexFont:(int) inp;
+(void)setMedTexFont:(int) inp;
+(void)setBigTexFont:(int) inp;
+(void)setTexTileset:(int) inp;
+(void)setMIndexCount:(int) inp;

+(void)setFontSize:(int) inp;
+(void)setMultiPlayerStatus:(int) inp;
+(void)setBallRadius:(int) inp;

+(void)setEnScore:(int) inp;
+(void)setLastOutcome:(int) inp;
+(void)setPaddleHeight:(int) inp;
+(void)setPaddleWidth:(int) inp;
+(void)setHPaddleHeight:(int) inp;
+(void)setHPaddleWidth:(int) inp;
+(void)setILost:(BOOL) inp;
+(void)setMultiplier:(int) inp;
+(void)setDivisor:(int) inp;
+(void)setTileset1:(int) inp;
+(void)setESpeed:(int) inp;
+(void)setRandEnemy:(int) inp;
+(void)setDidSounds:(BOOL) inp;

+(void)setLastTouchEvent:(long) inp;
+(void)setIpValid:(BOOL) inp;

+(void)setWidth:(int) inp;
+(void)setHeight:(int) inp;
+(void)setGwidth:(int) inp;
+(void)setGheight:(int) inp;
+(void)setFloatWidth:(int) inp;
+(void)setFloatHeight:(int) inp;
+(void)setHFloatWidth:(int) inp;
+(void)setHFloatHeight:(int) inp;
+(void)setState:(enum States) inp;
+(void)setLastDownState:(enum States) inp;
+(void)setHoveredButton:(Button *) inp;
+(void)setButtonInfo:(id *) inp;


int textLength(NSString * text);
+ (void)drawStringCentered:(NSString *)str y:(int)y size:(int)size;
+ (void)drawStringRight:(NSString *)str y:(int)y size:(int)size;
enum States intToState(int st);
int stateToInt(enum States st);
+ (void)loadSaved;

@end


Button * stateButtons[20][40];



TextureCoord * txPaddle;
TextureCoord * button[3];// = new TextureCoord[3];
TextureCoord * button2[3];// = new TextureCoord[3];
TextureCoord * button3[3];// = new TextureCoord[3];

