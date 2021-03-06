//
//  EAGLView.m
//  Pong
//
//  Created by Barrett Anderson on 1/24/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import "EAGLView.h"

#import <QuartzCore/QuartzCore.h>

#import "Button.h"
#import "GameState.h"
#import "PongViewController.h"
#import "PongAppDelegate.h"
#import "Preferences.h"
#import "SoundMan.h"


@interface EAGLView (PrivateMethods)
- (void)createFramebuffer;
- (void)deleteFramebuffer;
@end

@implementation EAGLView

@dynamic context;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


static EAGLView * instance = NULL;


UIScreen *screen;
int screenX;
int screenY;

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:.
- (id)initWithCoder:(NSCoder*)coder
{
  self = [super initWithCoder:coder];
	if (self)
  {
		screen = [UIScreen mainScreen];
		screenY = screen.bounds.size.height;
		screenX = screen.bounds.size.width;

		float scale = 1.0;

		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
			scale = screen.scale;

		PongViewController.width = screenY*scale;
		PongViewController.height = screenX*scale;
		if ([self respondsToSelector:@selector(setContentScaleFactor:)] ) {
			//float scale = [UIScreen mainScreen] scale;
			[self setContentScaleFactor: screen.scale];
		} else {
			// Function not supported, work around the issue
		}
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

    eaglLayer.opaque = TRUE;
    eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
            kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
            nil];
  }

  return self;
}

- (void)dealloc
{
  [self deleteFramebuffer];
  [context release];

  [super dealloc];
}

- (EAGLContext *)context
{
  return context;
}

- (void)setContext:(EAGLContext *)newContext
{
  if (context != newContext)
  {
    [self deleteFramebuffer];

    [context release];
    context = [newContext retain];

    [EAGLContext setCurrentContext:nil];
  }
}

- (void)createFramebuffer
{
    if (context && !defaultFramebuffer)
    {
      [EAGLContext setCurrentContext:context];

      // Create default framebuffer object.
      glGenFramebuffers(1, &defaultFramebuffer);
      glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);

      // Create color render buffer and allocate backing store.
      glGenRenderbuffers(1, &colorRenderbuffer);
      glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
      [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
      glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
      glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);

      glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);

      if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));

		instance = self;
  }
}

- (void)deleteFramebuffer
{
  if (context)
  {
    [EAGLContext setCurrentContext:context];

    if (defaultFramebuffer)
    {
      glDeleteFramebuffers(1, &defaultFramebuffer);
      defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
      glDeleteRenderbuffers(1, &colorRenderbuffer);
      colorRenderbuffer = 0;
    }
  }
}

- (void)setFramebuffer
{
    if (context)
    {
      [EAGLContext setCurrentContext:context];

      if (!defaultFramebuffer)
        [self createFramebuffer];

      glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);

      glViewport(0, 0, framebufferWidth, framebufferHeight);
    }
}

- (BOOL)presentFramebuffer
{
  BOOL success = FALSE;

  if (context)
  {
    [EAGLContext setCurrentContext:context];

    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);

    success = [context presentRenderbuffer:GL_RENDERBUFFER];
  }

  return success;
}

- (void)layoutSubviews
{
  // The framebuffer will be re-created at the beginning of the next setFramebuffer method call.
  [self deleteFramebuffer];
}

@synthesize firstPieceView;
@synthesize secondPieceView;
@synthesize thirdPieceView;
@synthesize touchPhaseText;
@synthesize touchInfoText;
@synthesize touchTrackingText;
@synthesize touchInstructionsText;

void onTouchEventState0(NSString *type, int clickedX, int clickedY)
{
	for (int i = 0;stateButtons[0][i]!=NULL;i++)
	{
		Button * but = stateButtons[0][i];
		if (([but collides:clickedX iny:clickedY]) &&
        [type isEqualToString:@"up"] &&
        but->handler != NULL)
		{
			(*(but->handler))();
		}
	}
}

void onTouchEventState1(NSString *type, int clickedX, int clickedY)
{
	//BOOL didPause = FALSE;
	for (int i = 0; stateButtons[1][i] != NULL; i++)
	{
		Button * but = stateButtons[1][i];
		if (([but collides:clickedX iny:clickedY]) &&
        ([type isEqualToString:@"down"] || [type isEqualToString:@"up"]) &&
        but->handler != NULL)
		{
			//didPause = TRUE;
			(*(but->handler))();
			return;
		}
	}

	/*if(Pong.inputMethod == 1)
	 return;*/
	if ([type isEqualToString:@"down"])
	{
		memset(PongViewController.mxs, 0, 10*sizeof(int));
		memset(PongViewController.mys, 0, 10*sizeof(int));
	}

	[GameState global].pX = clickedX - [Preferences global].paddlePositionX;
	[GameState global].pY = clickedY - [Preferences global].paddlePositionY;
}

void onTouchEventState2(NSString *type, int clickedX, int clickedY) {
	for(int i = 0; stateButtons[2][i] != NULL; i++)
	{
		Button *but = stateButtons[2][i];
		if (([but collides:clickedX iny:clickedY]) &&
        [type isEqualToString:@"up"] &&
        but->handler != NULL)
		{
			(*(but->handler))();
		}
	}

	if ([Preferences global].shouldPlaySound)
	{
		[stateButtons[2][1] changeText:@"On"];
	}
	else
	{
		[stateButtons[2][1] changeText:@"Off"];
	}
	if ([Preferences global].shouldVibrate)
	{
		[stateButtons[2][2] changeText:@"On"];
	}
	else
	{
		[stateButtons[2][2] changeText:@"Off"];
	}
	if ([Preferences global].difficulty == 0)
	{
		[stateButtons[2][3] changeText:@"Easy"];
	}
	else if ([Preferences global].difficulty == 1)
	{
		[stateButtons[2][3] changeText:@"Medium"];
	}
	else if ([Preferences global].difficulty == 2)
	{
		[stateButtons[2][3] changeText:@"Hard"];
	}
	if ([Preferences global].shouldShowFog)
	{
		[stateButtons[2][4] changeText:@"On"];
	}
	else
	{
		[stateButtons[2][4] changeText:@"Off"];
	}
	if ([Preferences global].inputMethod == 0)
	{
		[stateButtons[2][5] changeText:@"Touch"];
	}
	else if ([Preferences global].inputMethod == 1)	{
		[stateButtons[2][5] changeText:@"Tilt"];
	}

	if (clickedX >= -PongViewController.hPaddleWidth &&
      clickedX <= PongViewController.hPaddleWidth &&
      clickedY >= -PongViewController.hPaddleHeight &&
      clickedY <= PongViewController.hPaddleHeight)
	{
    [Preferences global].paddlePositionX = clickedX;
    [Preferences global].paddlePositionY = clickedY;
	}
}

void onTouchEventState3(NSString *type, int clickedX, int clickedY)
{
	for (int i = 0; stateButtons[3][i] != NULL; i++)
	{
		Button * but = stateButtons[3][i];
		if (([but collides:clickedX iny:clickedY]) &&
        [type isEqualToString:@"up"] &&
        but->handler != NULL)
		{
			(*(but->handler))();
			//return;
		}
	}

	if ([type isEqualToString:@"down"] &&
      clickedX <= -PongViewController.hFloatWidth + 9*PongViewController.fontSize/2 &&
      clickedY >= PongViewController.hFloatHeight - PongViewController.fontSize*4)
	{
		[Preferences global].shouldPlaySound = ![Preferences global].shouldPlaySound;

		[SoundMan playSound:mpWall3];
	}
	else if ([type isEqualToString:@"down"] &&
           clickedX >= PongViewController.hFloatWidth - 9*PongViewController.fontSize/2 &&
           clickedY >= PongViewController.hFloatHeight - PongViewController.fontSize*4)
	{
		[Preferences global].shouldVibrate = ![Preferences global].shouldVibrate;
		if ([Preferences global].shouldVibrate)
		{
			//if(vibrator != null)
			//	vibrator.vibrate(50);
		}
		[SoundMan playSound:mpWall3];
	}
	else if ([type isEqualToString:@"down"] &&
           clickedX >= [GameState global].pX - PongViewController.hPaddleWidth &&
           clickedX <= [GameState global].pX + PongViewController.hPaddleWidth &&
           clickedY >= [GameState global].pY-PongViewController.hPaddleHeight &&
           clickedY <= [GameState global].pY+PongViewController.hPaddleHeight)
	{
		[PongViewController switchToState:PLAYING];
		[SoundMan playSound:mpWall3];
	}
}

void onTouchEventState7(NSString *type, int clickedX, int clickedY)
{
	for (int i = 0; stateButtons[7][i] != NULL; i++)
	{
		Button * but = stateButtons[7][i];
		if(([but collides:clickedX iny:clickedY]) &&
       [type isEqualToString:@"up"] &&
       but->handler != NULL)
		{
			(*(but->handler))();
		}
	}

//	BOOL changedPref = FALSE;

	if ([type isEqualToString:@"down"] &&
      clickedX <= -PongViewController.hFloatWidth + 9*PongViewController.fontSize/2 &&
      clickedY >= PongViewController.hFloatHeight - PongViewController.fontSize*4)
	{
//		PongViewController.sound = PongViewController.sound?FALSE:TRUE;
    [Preferences global].shouldPlaySound = ![Preferences global].shouldPlaySound;
//		changedPref = TRUE;
		[SoundMan playSound:mpWall3];
	}

	if ([type isEqualToString:@"down"] &&
      clickedX >= PongViewController.hFloatWidth - 9*PongViewController.fontSize/2 &&
      clickedY >= PongViewController.hFloatHeight - PongViewController.fontSize*4)
	{
    [Preferences global].shouldVibrate = ![Preferences global].shouldVibrate;
//		PongViewController.vibrate = PongViewController.vibrate?FALSE:TRUE;
//		changedPref = TRUE;
		[SoundMan playSound:mpWall3];
	}


	/*
	 if(state == States.START && gameType == 1)
	 {

	 if(event.getAction() == MotionEvent.ACTION_UP)
	 {
	 previewX = 0;
	 previewY = 0;
	 inPreview = false;
	 }
	 else
	 {

	 if(event.getAction() == MotionEvent.ACTION_DOWN && clickedY <= -hFloatHeight + 4*fontSize && !changedPref)
	 {
	 inPreview = true;
	 try {
	 playSound(mpMenu);
	 } catch (IllegalStateException e) {
	 e.printStackTrace();
	 } catch (IOException e) {
	 }
	 }

	 if(inPreview)
	 previewX = clickedX;


	 if(event.getAction() == MotionEvent.ACTION_DOWN)
	 {//-gp.hFloatWidth + 4*gp.fontSize
	 if(clickedY <= 2*fontSize && clickedY >= -2*fontSize)
	 {
	 if(level > 0 && clickedX <= -hFloatWidth+4*fontSize)
	 {
	 try
	 {
	 playSound(mpWall3);
	 }
	 catch (IllegalStateException e)
	 {
	 e.printStackTrace();
	 }
	 catch (IOException e)
	 {
	 }
	 level--;
	 myScore = 0;
	 curLev = new Level(parseXmlFile(levelStrings.get(level)));
	 }
	 if(level < Math.max(prefs.getInt("levelsBeat", 0),GLGamePlay.freeLevels) && level < this.levelStrings.size() - 1 && clickedX >= hFloatWidth-4*fontSize)
	 {
	 try
	 {
	 playSound(mpWall3);
	 }
	 catch (IllegalStateException e)
	 {
	 e.printStackTrace();
	 }
	 catch (IOException e)
	 {
	 }
	 level++;
	 myScore = 0;
	 curLev = new Level(parseXmlFile(levelStrings.get(level)));
	 }
	 }


	 }



	 }

	 }*/

	if ([type isEqualToString:@"down"] &&
      clickedX >= -PongViewController.hPaddleWidth &&
      clickedX <= PongViewController.hPaddleWidth &&
      clickedY >= -PongViewController.hPaddleHeight &&
      clickedY <= PongViewController.hPaddleHeight)
	{
		if (PongViewController.multiPlayerStatus == 0)
		{
			PongViewController.previewX = 0;
			PongViewController.previewY = 0;
			int difficulty = [Preferences global].difficulty;
			[GameState global].bZSpeed =
          (int)(-PongViewController.bZSpeeds[difficulty] * (pow(1.05, [GameState global].level)));

			//if(GetAd.allAds != null && GetAd.success && GetAd.allAds.size() > 1 && gameType == 0)
			{
				//Random randomizer = new Random();
				//int randNum = Math.abs(randomizer.nextInt()%GetAd.allAds.size())/2;
				//String ad1 = GetAd.allAds.get(randNum*2);
				//String ad2 = GetAd.allAds.get(randNum*2+1);
				//Pong.adLine1 = ad1;
				//Pong.adLine2 = ad2;
			}
			[GameState global].pX = clickedX - [Preferences global].paddlePositionX;
			[GameState global].pY = clickedY - [Preferences global].paddlePositionY;
			[PongViewController switchToState:PLAYING];
			[SoundMan playSound:mpPing];
		}
	}
}

void onTouchEventState8(NSString *type, int clickedX, int clickedY)
{
	for (int i = 0; stateButtons[8][i] != NULL; i++)
	{
		Button *but = stateButtons[8][i];
		if (([but collides:clickedX iny:clickedY]) &&
        [type isEqualToString:@"up"] &&
        but->handler != NULL)
		{
			(*(but->handler))();
		}
	}
}

-(void)allTouches:(NSSet *)touches type:(NSString *)type
{
	for (UITouch *touch in touches)
	{
		@synchronized(PongViewController.sem)
		{
			int x = [touch locationInView:self].x;
			int y = [touch locationInView:self].y;
			int clickedX = (y-screenY/2)*PongViewController.floatWidth/screenY;
			int clickedY = (x-screenX/2)*PongViewController.floatHeight/screenX;

			if ([type isEqualToString:@"down"])
			{
				PongViewController.lastDownState = PongViewController.state;
			}

			if (PongViewController.state == HOME &&
          PongViewController.lastDownState == HOME)// && ([type isEqualToString:@"down"] || [type isEqualToString:@"move"]))
			{
				onTouchEventState0(type,clickedX,clickedY);
				//requestRender();
			}
			else if (PongViewController.state == OPTIONS &&
               PongViewController.lastDownState == OPTIONS)
			{
				onTouchEventState2(type,clickedX,clickedY);
				//requestRender();
			}
			else if (PongViewController.state == PAUSED &&
               PongViewController.lastDownState == PAUSED)
			{
				onTouchEventState3(type,clickedX,clickedY);
				//requestRender();
			}
			//-hPaddleHeight-fontSize*2,gl,fontSize*3/2
			else if (PongViewController.state == MULTIPLAYER &&
               PongViewController.lastDownState == MULTIPLAYER)
			{
				//onTouchEventState4(type,clickedX,clickedY);
				//requestRender();
			}
			else if (PongViewController.state == PLAYING)
			{
				onTouchEventState1(type,clickedX,clickedY);
				//requestRender();
			}
			else if (PongViewController.state == JOINIP &&
               PongViewController.lastDownState == JOINIP)
			{
				//onTouchEventState5(type,clickedX,clickedY);
				//requestRender();
			}
			else if (PongViewController.state == ERROR)
			{
				//onTouchEventState6(type,clickedX,clickedY);
				//requestRender();
			}
			else if (PongViewController.state == START &&
               PongViewController.lastDownState == START)
			{
				onTouchEventState7(type,clickedX,clickedY);
				//requestRender();
			}
			else if (PongViewController.state == RESULTS &&
               PongViewController.lastDownState == RESULTS)
			{
				onTouchEventState8(type,clickedX,clickedY);
				//requestRender();
			}
			else if (PongViewController.state == TARGET &&
               PongViewController.lastDownState == TARGET)
			{
				//onTouchEventState9(type,clickedX,clickedY);
				//requestRender();
			}

		}//UNLOCK SEMAPHORE
		break;
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self allTouches:touches type:@"down"];
}

// Handles the continuation of a touch.
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self allTouches:touches type:@"move"];

}

// Handles the end of a touch event.
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self allTouches:touches type:@"up"];
}

@end
