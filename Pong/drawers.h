// Home screen
void drawState0() {
	if (multiPlayerStatus == 0)	{
		if (isCurveball) {
			[PongViewController drawStringCentered:@"3D Curveball"
                                           y:hFloatHeight-fontSize/2
                                        size:fontSize*5/2];
    }	else {
			[PongViewController drawStringCentered:@"3D Pong"
                                           y:hFloatHeight-fontSize/2
                                        size:fontSize*5/2];
    }
	}


	//[PongViewController drawStringCentered:@"This is a discounted preview." y:-hFloatHeight+fontSize*3 size:fontSize];

	[PongViewController drawStringCentered:@"Greyed out buttons will be available in future releases."
                                       y:-hFloatHeight+fontSize*3/2
                                    size:fontSize];

	/*		if(gp.multiPlayerStatus == 1 && gp.socketThread != null)
	 {
	 if(gp.myIP != null)
	 {
	 String waiting = "Waiting for player to connect";
	 String ip = "Your Internal IP: "+gp.myIP.toString();
	 String instr = "3D Pong uses port 31045";
	 if(GLGamePlay.isCurveball)
	 instr = "3D Curveball uses port 31046";
	 if(!gp.socketThread.isConnected)
	 {
	 drawStringCentered(waiting,-gp.hPaddleHeight-gp.fontSize,gl,gp.fontSize*3/2);
	 drawStringCentered(ip,-gp.hPaddleHeight-gp.fontSize*4,gl,gp.fontSize*3/2);
	 drawString(instr,-gp.hFloatWidth+gp.fontSize/2,-gp.hFloatHeight+gp.fontSize*2,gl,gp.fontSize);
	 }
	 }

	 }*/
}

// Playing screen
void drawState1() {
	if (multiPlayerStatus != 0) {
		[PongViewController drawString:[NSString stringWithFormat:@"You:%d", [GameState global].myScore]
                                 x:-hFloatWidth+fontSize/2
                                 y:hFloatHeight
                              size:fontSize];
	}	else {
		[PongViewController drawString:[NSString stringWithFormat:@"%d", [GameState global].myScore]
                                 x:-hFloatWidth+fontSize/2
                                 y:-hFloatHeight+3*fontSize/2
                              size:fontSize];
	}

	if ([Preferences global].gameType != 1)	{
		NSString *lifeBalls = @"";
    int lives = [GameState global].numberOfLives;
		for (int i=1; i<lives; i++) {
      lifeBalls = [lifeBalls stringByAppendingFormat:@"%c",' '-1];
    }
		[PongViewController drawString:lifeBalls
                                 x:-hFloatWidth+fontSize/2
                                 y:-hFloatHeight+3*fontSize
                              size:fontSize*3/2];
	}
}

// Options screen
void drawState2() {
	[PongViewController drawStringCentered:@"Options"
                                       y:hFloatHeight
                                    size:fontSize*8/5];

	[PongViewController drawString:@"Sound"
                               x:-fontSize*19
                               y:hFloatHeight-3*fontSize
                            size:fontSize*3/2];
	[PongViewController drawString:@"Fog"
                               x:fontSize*14-fontSize/2
                               y:hFloatHeight-3*fontSize
                            size:fontSize*3/2];
	[PongViewController drawString:@"Vibrate"
                               x:-fontSize*10
                               y:hFloatHeight-3*fontSize
                            size:fontSize*3/2];

	[PongViewController drawString:@"X"
                               x:[Preferences global].paddlePositionX-fontSize/2
                               y:[Preferences global].paddlePositionY+fontSize
                            size:fontSize];


	[PongViewController drawString:@"Control"
                               x:-fontSize*16
                               y:hFloatHeight-9*fontSize
                            size:fontSize*3/2];
	[PongViewController drawString:@"Difficulty"
                               x:0
                               y:hFloatHeight-3*fontSize
                            size:fontSize*3/2];


	[PongViewController drawString:@"Tap on the paddle where you would like to \"hold\"\nit during gameplay. This can help if you have\ntrouble seeing through your finger."
                               x:-hFloatWidth+fontSize/4
                               y:-hPaddleHeight
                            size:fontSize*10/9];
}

// Pause screen
void drawState3() {
	[PongViewController drawStringCentered:@"Paused"
                                       y:hFloatHeight
                                    size:fontSize*2];
	[PongViewController drawStringCentered:@"Tap paddle to resume"
                                       y:hPaddleHeight+fontSize*5
                                    size:fontSize*3/2];

	NSString *soundImage = [NSString stringWithFormat:@"%c", ' '-2];
	NSString *ex = [NSString stringWithFormat:@"%c", ' '-4];
	NSString *vib = [NSString stringWithFormat:@"%c ", ' '-3];


	[PongViewController drawString:soundImage
                               x:-hFloatWidth+fontSize
                               y:hFloatHeight-fontSize
                            size:fontSize*2];
	[PongViewController drawStringRight:vib
                                    y:hFloatHeight-fontSize
                                 size:fontSize*2];

	if ([Preferences global].shouldPlaySound == false) {
		[PongViewController drawString:ex
                                 x:-hFloatWidth+fontSize*3/2
                                 y:hFloatHeight-fontSize
                              size:fontSize*2];
  }
	if ([Preferences global].shouldVibrate == false) {
		[PongViewController drawString:ex
                                 x:hFloatWidth-4*fontSize
                                 y:hFloatHeight-fontSize
                              size:fontSize*2];
  }


	if (multiPlayerStatus != 0)	{
		[PongViewController drawString:[NSString stringWithFormat:@"You:%d", [GameState global].myScore]
                                 x:-hFloatWidth+fontSize/2
                                 y:hFloatHeight
                              size:fontSize];
	}	else {
		[PongViewController drawString:[NSString stringWithFormat:@"%d", [GameState global].myScore]
                                 x:-hFloatWidth+fontSize/2
                                 y:-hFloatHeight+3*fontSize/2
                              size:fontSize];
	}
	if ([Preferences global].gameType != 1)	{
		NSString *lifeBalls = @"";
    int lives = [GameState global].numberOfLives;
		for (int i=1; i<lives; i++) {
      lifeBalls = [lifeBalls stringByAppendingFormat:@"%c",' '-1];
    }
		[PongViewController drawString:lifeBalls
                                 x:-hFloatWidth+fontSize/2
                                 y:-hFloatHeight+3*fontSize
                              size:fontSize*3/2];
	}
}

void drawState4() {
}

void drawState5() {
}

void drawState6() {
}

// Start screen
void drawState7() {
	NSString * begin = @"Tap Paddle to begin";
	if ([Preferences global].gameType == 1) {
		begin = @"Tap paddle for pitch";
  }

	NSString *soundImage = [NSString stringWithFormat:@"%c", ' '-2];
	NSString *ex = [NSString stringWithFormat:@"%c", ' '-4];
	NSString *vib = [NSString stringWithFormat:@"%c ", ' '-3];

	[PongViewController drawString:soundImage
                               x:-hFloatWidth+fontSize
                               y:hFloatHeight-fontSize
                            size:fontSize*2];
	[PongViewController drawStringRight:vib
                                    y:hFloatHeight-fontSize
                                 size:fontSize*2];

	if ([Preferences global].shouldPlaySound == false) {
		[PongViewController drawString:ex
                                 x:-hFloatWidth+fontSize*3/2
                                 y:hFloatHeight-fontSize
                              size:fontSize*2];
  }
	if ([Preferences global].shouldVibrate == false) {
		[PongViewController drawString:ex x:hFloatWidth-4*fontSize
                                 y:hFloatHeight-fontSize
                              size:fontSize*2];
  }

	NSString *levelString = [NSString stringWithFormat:@"Level %d", [GameState global].level+1];
	if (multiPlayerStatus == 0) {// || socketThread.isConnected)
		[PongViewController drawStringCentered:begin
                                         y:hPaddleHeight+fontSize*5
                                      size:fontSize*3/2];
  }

	if (multiPlayerStatus == 0) {
		[PongViewController drawStringCentered:levelString
                                         y:hFloatHeight
                                      size:fontSize*2];
  }

	if ([Preferences global].gameType == 1) {
		[PongViewController drawStringCentered:@"Drag here to rotate"
                                         y:-hFloatHeight+fontSize*3
                                      size:fontSize*3/2];
  }

	if (multiPlayerStatus != 0)	{
		[PongViewController drawString:[NSString stringWithFormat:@"You:%d", [GameState global].myScore]
                                 x:-hFloatWidth+fontSize/2
                                 y:hFloatHeight
                              size:fontSize];
	}	else {
		[PongViewController drawString:[NSString stringWithFormat:@"%d", [GameState global].myScore]
                                 x:-hFloatWidth+fontSize/2
                                 y:-hFloatHeight+3*fontSize/2
                              size:fontSize];
	}
	if ([Preferences global].gameType != 1)	{
		NSString *lifeBalls = @"";
    int lives = [GameState global].numberOfLives;
		for (int i=1; i<lives; i++) {
      lifeBalls = [lifeBalls stringByAppendingFormat:@"%c",' '-1];
    }
		[PongViewController drawString:lifeBalls
                                 x:-hFloatWidth+fontSize/2
                                 y:-hFloatHeight+3*fontSize
                              size:fontSize*3/2];
	}
}

// Results screen
void drawState8() {
	if ([Preferences global].gameType == 0)	{
		[PongViewController drawStringCentered:[NSString stringWithFormat:@"Game Over! %d Points", [GameState global].myScore]
                                         y:hFloatHeight
                                      size:fontSize*15/8];

		NSArray *prevScores = [GameState global].previousScores;
		//int total = 1;
		for (int i=0;i<[prevScores count];i++) {
			NSString *thisLine = [prevScores objectAtIndex:i];
			if (thisLine == NULL || [thisLine isEqualToString:@""]) {
				continue;
      }

			NSArray *thisScore = [thisLine componentsSeparatedByString: @" "];

			NSString *thisDate = [thisScore objectAtIndex:0];
			NSString *thisScoreNum = [thisScore objectAtIndex:1];

			[PongViewController drawString:thisDate
                                   x:-hFloatWidth+fontSize
                                   y:hFloatHeight-fontSize*5-fontSize*3*i/2
                                size:fontSize];
			[PongViewController drawStringAlignRight:thisScoreNum
                                             x:-4*fontSize
                                             y:hFloatHeight-fontSize*5-fontSize*3*i/2
                                          size:fontSize];
		}


		//String local = "This Phone";
		//String world = "World, 24 Hours";

		//drawString(local,-gp.hFloatWidth+gp.fontSize*3,gp.hFloatHeight-gp.fontSize*3,gl,gp.fontSize);
		[PongViewController drawString:@"This Phone"
                                 x:-hFloatWidth+fontSize*3
                                 y:hFloatHeight-fontSize*3
                              size:fontSize];

		[PongViewController drawStringAlignRight:@"World, 24 Hours"
                                           x:hFloatWidth-fontSize*3
                                           y:hFloatHeight-fontSize*3
                                        size:fontSize];

		//drawStringAlignRight(world,gp.hFloatWidth-gp.fontSize*3,gp.hFloatHeight-gp.fontSize*3,gl,gp.fontSize);


		//String hs = "High Scores for this Difficulty";
		NSString *hs;
		switch([Preferences global].difficulty) {
			case 0:
				hs = @"Easy";
				break;
			case 1:
				hs = @"Medium";
				break;
			case 2:
				hs = @"Hard";
				break;
			default:
				hs = @"Unknown";
		}
		//drawStringCentered(hs,gp.hFloatHeight-gp.fontSize*3,gl,gp.fontSize*5/4);
		[PongViewController drawStringCentered:hs
                                         y:hFloatHeight-fontSize*3
                                      size:fontSize*5/4];
	}
}

int textLength(NSString *text) {
	int total = 0;
	for (int i = 0;i < [text length];i++)
		if ([text characterAtIndex:i] == ' ')
			total += 15;
		else
			total += PongViewController.fontSizes[[text characterAtIndex:i]];
	return total-3*[text length] + 3;
}

+ (void)drawStringCentered:(NSString *)str y:(int)y size:(int)size {
	int x = -size*textLength(str)/40;
	[PongViewController drawString:str x:x y:y size:size];
}

+ (void)drawStringRight:(NSString *)str y:(int)y size:(int)size {
	int x = hFloatWidth-size*textLength(str)/20;
	[PongViewController drawString:str x:x y:y size:size];
}

+ (void)drawStringAlignRight:(NSString *)str
                           x:(int)inx
                           y:(int)y
                        size:(int)size {
	int x = inx-size*textLength(str)/20;
	[PongViewController drawString:str x:x y:y size:size];
}

//static void drawString(NSString * str,int x,int y,int size)
+ (void)drawString:(NSString *)str x:(int)x y:(int)y size:(int)size {
	int oX = x;
	int pixSize = width*size/floatWidth;
	int fontTex = bigTexFont;
	int smallMax = 10;
	int medMax = 37;
	if (pixSize <= smallMax)
		fontTex = smallTexFont;
		else if(pixSize <= medMax)
			fontTex = medTexFont;
			glBindTexture(GL_TEXTURE_2D, fontTex);
			glVertexPointer(3, GL_FLOAT, 0, fontBoxInt);
			fontBoxInt[2] = 0;
			fontBoxInt[5] = 0;
			fontBoxInt[8] = 0;
			fontBoxInt[11] = 0;

			int xPos = 0;
			int offset = 0;
			for(int i=0;i<[str length];i++)
			{
				char curChar = [str characterAtIndex:i];
				if(curChar == ' ')
				{
					offset += 12;
					xPos++;
					continue;
				}
				if(curChar == '\n')
				{
					y -= size*3/2;
					x = oX;
					xPos = 0;
					offset = 0;
					continue;
				}
				if(curChar >= 127)
					continue;


				if(fontTex == smallTexFont)
					glTexCoordPointer(2, GL_FIXED, 0, fontTextures[curChar].medBuff);
					else if(fontTex == medTexFont)
						glTexCoordPointer(2, GL_FIXED, 0, fontTextures[curChar].medBuff);
						else if(fontTex == bigTexFont)
							glTexCoordPointer(2, GL_FIXED, 0, fontTextures[curChar].bigBuff);


							fontBoxInt[0] = x+offset*size/20;
							fontBoxInt[3] = x+offset*size/20+fontSizes[curChar]*size/20;
							fontBoxInt[6] = x+offset*size/20;
							fontBoxInt[9] = x+offset*size/20+fontSizes[curChar]*size/20;

							fontBoxInt[1] = y;
							fontBoxInt[4] = y;
							fontBoxInt[7] = y-size*3/2;
							fontBoxInt[10] = y-size*3/2;

							glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

							xPos++;
				offset += fontSizes[curChar]-3;

				//NSLog(@"drawing: %c %i %i %i %i %i %i",curChar,size,fontSizes[curChar],fontTextures[curChar].bigBuff[0],fontTextures[curChar].bigBuff[1],fontTextures[curChar].bigBuff[2],fontTextures[curChar].bigBuff[3]);
			}
}
