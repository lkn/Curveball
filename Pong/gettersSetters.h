#import "GameState.h"


int stateToInt(enum States st)
{
	switch(st)
	{
		case NONE:
			return -1;
		case HOME:
			return 0;
		case PLAYING:
			return 1;
		case OPTIONS:
			return 2;
		case PAUSED:
			return 3;
		case MULTIPLAYER:
			return 4;
		case JOINIP:
			return 5;
		case ERROR:
			return 6;
		case START:
			return 7;
		case RESULTS:
			return 8;
		case TARGET:
			return 9;
		case OPTIONS2:
			return 10;
		default:
			return -1;
	}
}
enum States intToState(int st)
{
	switch(st)
	{
		case -1:
			return NONE;
		case 0:
			return HOME;
		case 1:
			return PLAYING;
		case 2:
			return OPTIONS;
		case 3:
			return PAUSED;
		case 4:
			return MULTIPLAYER;
		case 5:
			return JOINIP;
		case 6:
			return ERROR;
		case 7:
			return START;
		case 8:
			return RESULTS;
		case 9:
			return TARGET;
		case 10:
			return OPTIONS2;
		default:
			return NONE;
	}
}


void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez,
			   GLfloat centerx, GLfloat centery, GLfloat centerz,
			   GLfloat upx, GLfloat upy, GLfloat upz)

{
	
    GLfloat m[16];
    GLfloat x[3], y[3], z[3];
    GLfloat mag;
	
    /* Make rotation matrix */
    /* Z vector */
	
    z[0] = eyex - centerx;
    z[1] = eyey - centery;
    z[2] = eyez - centerz;
	
    mag = sqrt(z[0] * z[0] + z[1] * z[1] + z[2] * z[2]);
	
    if (mag) {                   /* mpichler, 19950515 */
		z[0] /= mag;
		z[1] /= mag;
		z[2] /= mag;
    }
    /* Y vector */
	
    y[0] = upx;
    y[1] = upy;
    y[2] = upz;
	
	
	
    /* X vector = Y cross Z */
	
    x[0] = y[1] * z[2] - y[2] * z[1];
    x[1] = -y[0] * z[2] + y[2] * z[0];
    x[2] = y[0] * z[1] - y[1] * z[0];
	
	
    /* Recompute Y = Z cross X */
	
    y[0] = z[1] * x[2] - z[2] * x[1];
    y[1] = -z[0] * x[2] + z[2] * x[0];
    y[2] = z[0] * x[1] - z[1] * x[0];
	
    mag = sqrt(x[0] * x[0] + x[1] * x[1] + x[2] * x[2]);
	
    if (mag) {
		x[0] /= mag;
		x[1] /= mag;
		x[2] /= mag;
    }
	
    mag = sqrt(y[0] * y[0] + y[1] * y[1] + y[2] * y[2]);
	
    if (mag) {
		y[0] /= mag;
		y[1] /= mag;
		y[2] /= mag;
    }
#define M(row,col)  m[col*4+row]
	
    M(0, 0) = x[0];
    M(0, 1) = x[1];
    M(0, 2) = x[2];
    M(0, 3) = 0.0;
    M(1, 0) = y[0];
    M(1, 1) = y[1];
    M(1, 2) = y[2];
    M(1, 3) = 0.0;
    M(2, 0) = z[0];
    M(2, 1) = z[1];
    M(2, 2) = z[2];
    M(2, 3) = 0.0;
    M(3, 0) = 0.0;
    M(3, 1) = 0.0;
    M(3, 2) = 0.0;
    M(3, 3) = 1.0;
#undef M
    glMultMatrixf(m);
	
    /* Translate Eye to Origin */
	
    glTranslatef(-eyex, -eyey, -eyez);
	
}

void perspective(double fovy, double aspect, float zNear, float zFar)
{
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	double xmin, xmax, ymin, ymax;
	
	ymax = zNear * tan(fovy * M_PI / 360.0);
	ymin = -ymax;
	xmin = ymin * aspect;
	xmax = ymax * aspect;
	
	
	glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar);
	
	
	
	glMatrixMode(GL_MODELVIEW);
	//glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);	
	
	//glDepthMask(GL_TRUE);
}





-(GLuint)LoadTexture:(NSString*)filename
{
	GLuint textureID;
	GLuint textures[1];
	glGenTextures(1,textures);
	textureID = textures[0];
	glBindTexture(GL_TEXTURE_2D,textureID);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE,GL_REPLACE);
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
	NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
	
	
	
	
	UIImage *image = [[UIImage alloc] initWithData:texData];
	

	
	if (image == nil)
		NSLog(@"Do real error checking here");
		
		GLuint width = CGImageGetWidth(image.CGImage);
		GLuint height = CGImageGetHeight(image.CGImage);
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		void *imageData = malloc( height * width * 4 );
		CGContextRef tcontext = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
		CGColorSpaceRelease( colorSpace );
		CGContextClearRect( tcontext, CGRectMake( 0, 0, width, height ) );
		CGContextTranslateCTM( tcontext, 0, height - height );
		CGContextDrawImage( tcontext, CGRectMake( 0, 0, width, height ), image.CGImage );
		
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
		
		CGContextRelease(tcontext);
		
		free(imageData);
		[image release];
	[texData release];
	
	//NSLog(@"Loaded Texture %i",textureID);
	
	return textureID;
}

void setUpWalls()
{
	int count = 0;
	for(int i=0;i<8;i++)
	{
		wallVertices[0+12*count] = hFloatWidth;
		wallVertices[1+12*count] = (int)(-.99f*hFloatHeight);
		wallVertices[2+12*count] = (int)(-depth*i/8.0f);
		wallVertices[3+12*count] = hFloatWidth;
		wallVertices[4+12*count] = (int)( .99f*hFloatHeight);
		wallVertices[5+12*count] = (int)(-depth*i/8.0f);
		wallVertices[6+12*count] = hFloatWidth;
		wallVertices[7+12*count] = (int)(-.99f*hFloatHeight);
		wallVertices[8+12*count] = (int)(-depth*i/8.0f-.94f*depth/8.0f);
		wallVertices[9+12*count] = hFloatWidth;
		wallVertices[10+12*count] = (int)(.99f*hFloatHeight);
		wallVertices[11+12*count] = (int)(-depth*i/8.0f-.94f*depth/8.0f);
		count++;
	}
	for(int i=0;i<8;i++)
	{
		wallVertices[6+12*count] = -hFloatWidth;
		wallVertices[7+12*count] = (int)(-.99f*hFloatHeight);
		wallVertices[8+12*count] = (int)(-depth*i/8.0f);
		wallVertices[9+12*count] = -hFloatWidth;
		wallVertices[10+12*count] = (int)( .99f*hFloatHeight);
		wallVertices[11+12*count] = (int)(-depth*i/8.0f);
		wallVertices[0+12*count] = -hFloatWidth;
		wallVertices[1+12*count] = (int)(-.99f*hFloatHeight);
		wallVertices[2+12*count] = (int)(-depth*i/8.0f-.94f*depth/8.0f);
		wallVertices[3+12*count] = -hFloatWidth;
		wallVertices[4+12*count] = (int)(.99f*hFloatHeight);
		wallVertices[5+12*count] = (int)(-depth*i/8.0f-.94f*depth/8.0f);
		count++;
	}
	for(int i=0;i<8;i++)
	{
		wallVertices[0+12*count] = (int)(-.99f*hFloatWidth);
		wallVertices[1+12*count] = -hFloatHeight;
		wallVertices[2+12*count] = (int)(-depth*i/8.0f);
		wallVertices[3+12*count] = (int)(.99f*hFloatWidth);
		wallVertices[4+12*count] = -hFloatHeight;
		wallVertices[5+12*count] = (int)(-depth*i/8.0f);
		wallVertices[6+12*count] = (int)(-.99f*hFloatWidth);
		wallVertices[7+12*count] = -hFloatHeight;
		wallVertices[8+12*count] = (int)(-depth*i/8.0f-.94f*depth/8.0f);
		wallVertices[9+12*count] = (int)(.99f*hFloatWidth);
		wallVertices[10+12*count] = -hFloatHeight;
		wallVertices[11+12*count] = (int)(-depth*i/8.0f-.94f*depth/8.0f);
		count++;
	}
	for(int i=0;i<8;i++)
	{
		wallVertices[6+12*count] = (int)(-.99f*hFloatWidth);
		wallVertices[7+12*count] = hFloatHeight;
		wallVertices[8+12*count] = (int)(-depth*i/8.0f);
		wallVertices[9+12*count] = (int)(.99f*hFloatWidth);
		wallVertices[10+12*count] = hFloatHeight;
		wallVertices[11+12*count] = (int)(-depth*i/8.0f);
		wallVertices[0+12*count] = (int)(-.99f*hFloatWidth);
		wallVertices[1+12*count] = hFloatHeight;
		wallVertices[2+12*count] = (int)(-depth*i/8.0f-.94f*depth/8.0f);
		wallVertices[3+12*count] = (int)(.99f*hFloatWidth);
		wallVertices[4+12*count] = hFloatHeight;
		wallVertices[5+12*count] = (int)(-depth*i/8.0f-.94f*depth/8.0f);
		count++;
	}
}


void setUpFonts()
{
	
	
	
	fontStarts[' '-4] = 40;
	fontStarts[' '-3] = 61;
	fontStarts[' '-2] = 93;
	fontStarts[' '-1] = 126;
	fontStarts[' '] = 142;
	fontStarts['!'] = 142;
	fontStarts['"'] = 157;
	fontStarts['#'] = 175;
	fontStarts['$'] = 198;
	fontStarts['%'] = 220;
	fontStarts['&'] = 244;
	fontStarts['\''] = 272;
	fontStarts['('] = 285;
	fontStarts[')'] = 302;
	fontStarts['*'] = 318;
	fontStarts['+'] = 340;
	fontStarts[','] = 361;
	fontStarts['-'] = 376;
	fontStarts['.'] = 392;
	fontStarts['/'] = 405;
	fontStarts['0'] = 429;
	fontStarts['1'] = 449;
	fontStarts['2'] = 465;
	fontStarts['3'] = 487;
	fontStarts['4'] = 510;
	fontStarts['5'] = 534;
	fontStarts['6'] = 557;
	fontStarts['7'] = 580;
	fontStarts['8'] = 601;
	fontStarts['9'] = 625;
	fontStarts[':'] = 647;
	fontStarts[';'] = 661;
	fontStarts['<'] = 675;
	fontStarts['='] = 697;
	fontStarts['>'] = 719;
	fontStarts['?'] = 741;
	fontStarts['@'] = 761;
	fontStarts['A'] = 793;
	fontStarts['B'] = 817;
	fontStarts['C'] = 838;
	fontStarts['D'] = 859;
	fontStarts['E'] = 879;
	fontStarts['F'] = 900;
	fontStarts['G'] = 920;
	fontStarts['H'] = 940;
	fontStarts['I'] = 964;
	fontStarts['J'] = 977;
	fontStarts['K'] = 997;
	fontStarts['L'] = 1017;
	fontStarts['M'] = 1035;
	fontStarts['N'] = 1062;
	fontStarts['O'] = 1086;
	fontStarts['P'] = 1107;
	fontStarts['Q'] = 1130;
	fontStarts['R'] = 1152;
	fontStarts['S'] = 1172;
	fontStarts['T'] = 1195;
	fontStarts['U'] = 1216;
	fontStarts['V'] = 1239;
	fontStarts['W'] = 1260;
	fontStarts['X'] = 1288;
	fontStarts['Y'] = 1310;
	fontStarts['Z'] = 1330;
	fontStarts['['] = 1354;
	fontStarts['\\'] = 1373;
	fontStarts[']'] = 1394;
	fontStarts['^'] = 1414;
	fontStarts['_'] = 1434;
	fontStarts['`'] = 1457;
	fontStarts['a'] = 1471;
	fontStarts['b'] = 1491;
	fontStarts['c'] = 1509;
	fontStarts['d'] = 1527;
	fontStarts['e'] = 1547;
	fontStarts['f'] = 1566;
	fontStarts['g'] = 1583;
	fontStarts['h'] = 1603;
	fontStarts['i'] = 1621;
	fontStarts['j'] = 1633;
	fontStarts['k'] = 1651;
	fontStarts['l'] = 1671;
	fontStarts['m'] = 1683;
	fontStarts['n'] = 1708;
	fontStarts['o'] = 1728;
	fontStarts['p'] = 1746;
	fontStarts['q'] = 1766;
	fontStarts['r'] = 1784;
	fontStarts['s'] = 1803;
	fontStarts['t'] = 1820;
	fontStarts['u'] = 1837;
	fontStarts['v'] = 1856;
	fontStarts['w'] = 1874;
	fontStarts['x'] = 1897;
	fontStarts['y'] = 1916;
	fontStarts['z'] = 1933;
	fontStarts['{'] = 1952;
	fontStarts['|'] = 1972;
	fontStarts['}'] = 1985;
	fontStarts['~'] = 2004;
	fontStarts[127] = 2025; // so that ~ has a size
	//fontStarts['_'] = 142;
	
	
	
	for(int i=0;i<127;i++)
	{
		if(i < 127 && fontStarts[i+1] != 0)
			fontSizes[i] = fontStarts[i+1] - fontStarts[i];
		medFontStarts[i] = fontStarts[i];
	}
	
	
	//medFontStarts = fontStarts.clone();
	
	
	for(int i=0;i<='4';i++)
	{
		if(fontStarts[i] != 0)
			fontStarts[i] -= 21;
	}
	for(int i='5';i<='L';i++)
	{
		if(fontStarts[i] != 0)
			fontStarts[i] -= 11;
	}
	for(int i='M';i<='d';i++)
	{
		if(fontStarts[i] != 0)
			fontStarts[i] -= 9;
	}
	
	for(int i=0;i<='L';i++)
	{
		if(medFontStarts[i] != 0)
			medFontStarts[i] -= 12;
	}
	//NSLog(@"hi");
	
	for(int i=0;i<128;i++)
	{
		//NSLog(@"hi");
		fontTextures[i] = [[FontTexture alloc] initFontTexture:i];
		//NSLog(@"hi");
		//fontTextures[i] = new FontTexture(i);
	}
	
	
	//fontBuffInt.put(11,0);
	//fontBuffInt.put(8,0);
	//fontBuffInt.put(5,0);
	//fontBuffInt.put(2,0);
	fontBoxInt[11] = 0;
	fontBoxInt[8] = 0;
	fontBoxInt[5] = 0;
	fontBoxInt[2] = 0;
	
	
}

//static int width,height,gwidth,gheight,floatWidth,floatHeight,hFloatWidth,hFloatHeight;
+(int)floatWidth
{
	return floatWidth;
}
+(int)floatHeight
{
	return floatHeight;
}

+(Button*)hoveredButton
{
	return hoveredButton;
}
//static TextureCoord * button3[3] = new TextureCoord[3];

+(TextureCoord**)button
{
	return button;
}
+(TextureCoord**)button2
{
	return button2;
}
+(TextureCoord**)button3
{
	return button3;
}
+(FontTexture**)fontTextures
{
	return fontTextures;
}
//+(Button*[20][40])stateButtons
//{
//	return stateButtons;
//}



+(enum States)lastDownState
{
	return lastDownState;
}

+(enum States)state
{
	return state;
}



+(NSString *)sem
{
	return sem;
}
+(NSString*)myIP
{
	return myIP;
}
+(int)width
{
	return width;
}

+(int)height
{
	return height;
}
+(int)gwidth
{
	return gwidth;
}
+(int)gheight
{
	return gheight;
}
+(int)hFloatWidth
{
	return hFloatWidth;
}
+(int)hFloatHeight
{
	return hFloatHeight;
}


+(int)holdPaddleX
{
	return holdPaddleX;
}
+(int)holdPaddleY
{
	return holdPaddleY;
}
+(int)fontSize
{
	return fontSize;
}



+(BOOL)isCurveball
{
	return isCurveball;
}

+(BOOL)debug
{
	return debug;
}
+(BOOL)fullVersion
{
	return fullVersion;
}



+(int)freeLevels
{
	return freeLevels;
}
+(int)realWidth
{
	return realWidth;
}
+(int)realHeight
{
	return realHeight;
}
+(int)gameType
{
	return gameType;
}
+(int)xAccel
{
	return xAccel;
}
+(int)yAccel
{
	return yAccel;
}
+(int)previewX
{
	return previewX;
}
+(int)previewY
{
	return previewY;
}
+(BOOL)running
{
	return running;
}

+(int)level
{
	return level;
}

+(int)lives
{
	return lives;
}

+(BOOL)fog
{
	return fog;
}
+(int)inputMethod
{
	return inputMethod;
}

+(int)pX
{
	return pX;
}

+(int)pY
{
	return pY;
}

+(BOOL)inPreview
{
	return inPreview;
}

+(BOOL)waitingForOp
{
	return waitingForOp;
}

+(int)texBall
{
	return texBall;
}

+(BOOL)tellOpponent
{
	return tellOpponent;
}

+(int)smallTexFont
{
	return smallTexFont;
}

+(int)medTexFont
{
	return medTexFont;
}

+(int)bigTexFont
{
	return bigTexFont;
}

+(int)texTileset
{
	return texTileset;
}

+(int)mIndexCount
{
	return mIndexCount;
}


+(int)multiPlayerStatus
{
	return multiPlayerStatus;
}

+(int)ballRadius
{
	return ballRadius;
}

+(int)bX
{
	return bX;
}

+(int)bY
{
	return bY;
}

+(int)bZ
{
	return bZ;
}

+(int)myScore
{
	return myScore;
}

+(int)enScore
{
	return enScore;
}

+(int)bXSpeed
{
	return bXSpeed;
}

+(int)bYSpeed
{
	return bYSpeed;
}

+(int)bZSpeed
{
	return bZSpeed;
}

+(int)lastOutcome
{
	return lastOutcome;
}

+(int)paddleHeight
{
	return paddleHeight;
}

+(int)paddleWidth
{
	return paddleWidth;
}

+(int)hPaddleHeight
{
	return hPaddleHeight;
}

+(int)hPaddleWidth
{
	return hPaddleWidth;
}



+(BOOL)iLost
{
	return iLost;
}

+(int)eX
{
	return eX;
}

+(int)eY
{
	return eY;
}

+(int)multiplier
{
	return multiplier;
}

+(int)divisor
{
	return divisor;
}

+(int)tileset1
{
	return tileset1;
}

+(int)eSpeed
{
	return eSpeed;
}

+(int)randEnemy
{
	return randEnemy;
}

+(BOOL)didSounds
{
	return didSounds;
}

+(int)difficulty
{
	return difficulty;
}

+(long)lastTouchEvent
{
	return lastTouchEvent;
}

+(BOOL)ipValid
{
	return ipValid;
}


+(int*)sinTable
{
	return sinTable;
}

+(int*)cosTable
{
	return cosTable;
}

+(int*)fontStarts
{
	return fontStarts;
}

+(int*)medFontStarts
{
	return medFontStarts;
}

+(int*)fontSizes
{
	return fontSizes;
}

+(int*)mxs
{
	return mxs;
}

+(int*)mys
{
	return mys;
}

+(int*)eSpeeds
{
	return eSpeeds;
}

+(int*)bZSpeeds
{
	return bZSpeeds;
}

+(int*)randEnemies
{
	return randEnemies;
}

+(GLfloat*)fontBoxInt
{
	return fontBoxInt;
}

+(int*)shadowInt
{
	return shadowInt;
}

+(int*)paddleInt
{
	return paddleInt;
}

+(int*)boxInt
{
	return boxInt;
}

+(int*)fontTexCoords
{
	return fontTexCoords;
}

+(int*)texCoordsInt
{
	return texCoordsInt;
}


+(BOOL)sound
{
	return sound;
}
+(BOOL)vibrate
{
	return vibrate;
}

+(void)setRunning:(BOOL) inp
{
	running = inp;
}

+(void)setLevel:(int) inp
{
	level = inp;
}

+(void)setLives:(int) inp
{
	lives = inp;
}

+(void)setFreeLevels:(int) inp
{
	freeLevels = inp;
}

+(void)setRealWidth:(int) inp
{
	realWidth = inp;
}

+(void)setRealHeight:(int) inp
{
	realHeight = inp;
}


+(void)setPreviewX:(int) inp
{
	previewX = inp;
}

+(void)setPreviewY:(int) inp
{
	previewY = inp;
}



+(void)setInPreview:(BOOL) inp
{
	inPreview = inp;
}

+(void)setWaitingForOp:(BOOL) inp
{
	waitingForOp = inp;
}

+(void)setTexBall:(int) inp
{
	texBall = inp;
}


+(void)setTellOpponent:(BOOL) inp
{
	tellOpponent = inp;
}

+(void)setSmallTexFont:(int) inp
{
	smallTexFont = inp;
}

+(void)setMedTexFont:(int) inp
{
	medTexFont = inp;
}

+(void)setBigTexFont:(int) inp
{
	bigTexFont = inp;
}

+(void)setTexTileset:(int) inp
{
	texTileset = inp;
}






+(void)setMIndexCount:(int) inp
{
	mIndexCount = inp;
}

+(void)setHoldPaddleX:(int) inp
{
	holdPaddleX = inp;
}

+(void)setHoldPaddleY:(int) inp
{
	holdPaddleY = inp;
}

+(void)setFontSize:(int) inp
{
	fontSize = inp;
}

+(void)setMultiPlayerStatus:(int) inp
{
	multiPlayerStatus = inp;
}

+(void)setBallRadius:(int) inp
{
	ballRadius = inp;
}

+(void)setEnScore:(int) inp
{
	enScore = inp;
}

+(void)setBXSpeed:(int) inp
{
	bXSpeed = inp;
}

+(void)setPaddleHeight:(int) inp
{
	paddleHeight = inp;
}

+(void)setPaddleWidth:(int) inp
{
	paddleWidth = inp;
}

+(void)setHPaddleHeight:(int) inp
{
	hPaddleHeight = inp;
}

+(void)setHPaddleWidth:(int) inp
{
	hPaddleWidth = inp;
}

+(void)setILost:(BOOL) inp
{
	iLost = inp;
}

+(void)setMultiplier:(int) inp
{
	multiplier = inp;
}

+(void)setDivisor:(int) inp
{
	divisor = inp;
}

+(void)setTileset1:(int) inp
{
	tileset1 = inp;
}

+(void)setESpeed:(int) inp
{
	eSpeed = inp;
}

+(void)setRandEnemy:(int) inp
{
	randEnemy = inp;
}

+(void)setDidSounds:(BOOL) inp
{
	didSounds = inp;
}

+(void)setDifficulty:(int) inp
{
	difficulty = inp;
}


+(void)setLastTouchEvent:(long) inp
{
	lastTouchEvent = inp;
}

+(void)setIpValid:(BOOL) inp
{
	ipValid = inp;
}





+(void)setSound:(BOOL) inp
{
	sound = inp;
}



+(void)setVibrate:(BOOL) inp
{
	vibrate = inp;
}


+(void)setWidth:(int) inp
{
	width = inp;
}


+(void)setHeight:(int) inp
{
	height = inp;
}


+(void)setGwidth:(int) inp
{
	gwidth = inp;
}


+(void)setGheight:(int) inp
{
	gheight = inp;
}


+(void)setFloatWidth:(int) inp
{
	floatWidth = inp;
}


+(void)setFloatHeight:(int) inp
{
	floatHeight = inp;
}


+(void)setHFloatWidth:(int) inp
{
	hFloatWidth = inp;
}


+(void)setHFloatHeight:(int) inp
{
	hFloatHeight = inp;
}



+(void)setHoveredButton:(Button *) inp
{
	hoveredButton = inp;
}

+(void)setButtonInfo:(id *) inp
{
	buttonInfo = inp;
}


+(void)setState:(enum States) inp
{
	state = inp;
}


+(void)setLastDownState:(enum States) inp
{
	lastDownState = inp;
}


