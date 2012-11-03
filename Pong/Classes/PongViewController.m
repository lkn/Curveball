//
//  PongViewController.m
//  Pong
//
//  Created by Barrett Anderson on 1/24/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import "PongViewController.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Button.h"
#import "EAGLView.h"
#import "FontTexture.h"
#import "GameState.h"
#import "PongAppDelegate.h"
#import "Preferences.h"
#import "SoundMan.h"
#import "SQLite3Data.h"


// Uniform index.
enum {
  UNIFORM_TRANSLATE,
  NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
  ATTRIB_VERTEX,
  ATTRIB_COLOR,
  NUM_ATTRIBUTES
};

void drawWorld();
void setUpWalls();

int depth = (int)(2.0*65536);
int altitude = (int)(0.6*65536);

enum States state = HOME;

static BOOL isCurveball = TRUE;

static BOOL debug = FALSE;
static BOOL fullVersion = TRUE;
//SurfaceHolder sHolder;
//Thread t;
static BOOL running;
static id * buttonInfo;
//int width;

//int height;
//int gwidth;
//int gheight;
static int freeLevels = 0;
static int realWidth;
static int realHeight;

static int previewX = 0;
static int previewY = 0;
static Button * hoveredButton;


static int sinTable[] = {
  0,
  9802,
  19509,
  29028,
  38268,
  47140,
  55557,
  63439,
  70711,
  77301,
  83147,
  88192,
  92388,
  95694,
  98079,
  99520,
  100000
};

static int cosTable[] = {
  100000,
  99520,
  98079,
  95694,
  92388,
  88192,
  83147,
  77301,
  70711,
  63439,
  55557,
  47140,
  38268,
  29028,
  19509,
  9802,
  0
};

static int fontStarts[130];// = new int[130];
static int medFontStarts[130];// = new int[130];
static int fontSizes[130];// = new int[130];

static BOOL inPreview = false;
//GameRenderer gameRenderer;
static BOOL waitingForOp = false;
//Level curLev;
//ArrayList<Level> allLevels;
//States state = PLAYING;

//GameLoop gLoop;
//Thread gameLoop;
static NSMutableString *myIP;
//GL10 g_gl;
//BOOL resize;
//SocketThread socketThread;
//Thread st;
static int texBall;
static int mxs[10];// = new int[10];
static int mys[10];// = new int[10];
//Vibrator vibrator;
static BOOL tellOpponent = false;
NSString *whatToTellOpponent = @"";

static int smallTexFont;
static int medTexFont;
static int bigTexFont;

static int texTileset;
TextureCoord * txBall;
TextureCoord * txTransBall;
/*TextureCoord txPaddle;
TextureCoord txTarget;
TextureCoord txTarget1;
TextureCoord txTarget2;
TextureCoord txTarget3;
TextureCoord txTarget4;
TextureCoord txTransTarget;
TextureCoord txFireTile;
TextureCoord txBounceTile;
TextureCoord txShadow;
TextureCoord[] txExplosions;
TextureCoord txSmallTarget;*/

//TextureCoord txArrows;
//TextureCoord txArrowLeft;
//TextureCoord txArrowRight;



//GLWorld world = new GLWorld();
//GLShape[] mShapes = new GLShape[32];
//IntBuffer   mVertexBuffer;
//IntBuffer   mColorBuffer;
//ShortBuffer mIndexBuffer;
static int mIndexCount = 0;
//private ArrayList<GLShape>	mShapeList = new ArrayList<GLShape>();
//private ArrayList<GLVertex>	mVertexList = new ArrayList<GLVertex>();

static int fontSize;
//int floatHeight;//=(int)(4.8f);
//int floatWidth;//=(int)(8f);
//int hFloatHeight;//=(int)(2.4f);
//int hFloatWidth;//=(int)(4f);

static int multiPlayerStatus = 0;//0 = none, 1 = host, 2 = client
static int ballRadius = 0;

static int enScore = 0;

static int lastOutcome = -1;
static int paddleHeight = 0;
static int paddleWidth = 0;
static int hPaddleHeight = 0;
static int hPaddleWidth = 0;
static BOOL iLost = false;

static int multiplier = 1600;
static int divisor = 800;
static int tileset1 = 0;
static int eSpeed = (int)(.02f*65536);
static int randEnemy = 100;
static NSString * sem = @"";

static BOOL didSounds = false;

static int eSpeeds[] = {
  (int)(.015f*65536),
  (int)(.025f*65536),
  (int)(.04f*65536)
};

static int bZSpeeds[] = {
  (int)(.04f*65536),
  (int)(.05f*65536),
  (int)(.06f*65536)
};

static int randEnemies[] = {100, 250, 500};
static long lastTouchEvent = 0;

enum States lastDownState = NONE;

//NSMutableString *enteredIP = "";
static BOOL ipValid = false;//set in graphics renderer

int fps;

//NSMutableString *error = "Error";
static GLfloat fontBoxInt[12];// = new int[12];
static int shadowInt[12];// = new int[12];
static int paddleInt[12];// = new int[12];
static int boxInt[] = {
	//enemy Paddle
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	//right
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	// bottom
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	// top
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	// Ball
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	// paddle
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	// trans Left
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	// trans Right
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	// trans top
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
	// trans bottom
	0,0,0,
	0,0,0,
	0,0,0,
	0,0,0,
};

static int fontTexCoords[8];// = new int[8];
static int texCoordsInt[] =  {
	// FRONT
	0, 0,
	65536, 0,
	0, 65536,
	65536, 65536,
	// BACK
	65536, 0,
	65536, 65536,
	0, 0,
	0, 65536,
	// LEFT
	65536, 0,
	65536, 65536,
	0, 0,
	0, 65536,
	// RIGHT
	65536, 0,
	65536, 65536,
	0, 0,
	0, 65536,
	// TOP
	0, 0,
	65536, 0,
	0, 65536,
	65536, 65536,
	// BOTTOM
	65536, 0,
	65536, 65536,
	0, 0,
	0, 65536,
	//
	0, 0,
	65536, 0,
	0, 65536,
	65536, 65536,
	//
	0, 0,
	65536, 0,
	0, 65536,
	65536, 65536,
	//
	0, 0,
	65536, 0,
	0, 65536,
	65536, 65536,
	//
	0, 0,
	65536, 0,
	0, 65536,
	65536, 65536
};

//IntBuffer cubeBuffInt;
//IntBuffer shadowBuffInt;
//IntBuffer paddleBuffInt;
//IntBuffer texBuffInt;
//IntBuffer fontBuffInt;
FontTexture * fontTextures[128];// = new FontTexture[128];

static int width,height,gwidth,gheight,floatWidth,floatHeight,hFloatWidth,hFloatHeight;

void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez,
			   GLfloat centerx, GLfloat centery, GLfloat centerz,
			   GLfloat upx, GLfloat upy, GLfloat upz);
void perspective(double fovy, double aspect, float zNear, float zFar);

@interface PongViewController ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) CADisplayLink *displayLink;
@property (nonatomic, assign) PongAppDelegate *delegate;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

//@property static int width,height,gwidth,gheight,floatWidth,floatHeight,hFloatWidth,hFloatHeight;
@end

@implementation PongViewController
//@synthesize width,height,gwidth,gheight,floatWidth,floatHeight,hFloatWidth,hFloatHeight;
@synthesize animating, context, displayLink, delegate;

static void gameReset()
{
	memset(PongViewController.mxs, 0, 10*sizeof(int));
	memset(PongViewController.mys, 0, 10*sizeof(int));

  int difficulty = [Preferences global].difficulty;
  int level = [GameState global].level;
	[GameState global].bZSpeed =
      (int)(-bZSpeeds[difficulty] * (pow(1.05, level)));
	eSpeed = (int)(eSpeeds[difficulty] * (pow(1.05, level)));
	randEnemy = (int)(randEnemies[difficulty] * (pow(1.05, level)));

	[GameState global].bXSpeed = 0;
	[GameState global].bYSpeed = 0;
//  [GameState global].bZSpeed = (int)(.04f*65536);
	[GameState global].bX = 0;
	[GameState global].bY = 0;
	[GameState global].bZ = -ballRadius;

  [GameState global].xAcceleration = 0;
  [GameState global].yAcceleration = 0;

  [GameState global].pX = 0;
  [GameState global].pY = 0;
	[GameState global].eX = 0;
	[GameState global].eY = 0;
}

- (void)awakeFromNib
{
  EAGLContext *aContext = NULL;//= [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

  if (!aContext)
  {
    aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
  }

  if (!aContext)
    NSLog(@"Failed to create ES context");
  else if (![EAGLContext setCurrentContext:aContext])
    NSLog(@"Failed to set ES context current");

  self.context = aContext;
  [aContext release];

  [(EAGLView *)self.view setContext:context];
  [(EAGLView *)self.view setFramebuffer];

  if ([context API] == kEAGLRenderingAPIOpenGLES2)
    [self loadShaders];

  animating = FALSE;
  animationFrameInterval = 1;
  self.displayLink = nil;
}

- (void)dealloc
{
  if (program)
  {
    glDeleteProgram(program);
    program = 0;
  }

  // Tear down context.
  if ([EAGLContext currentContext] == context)
    [EAGLContext setCurrentContext:nil];

  [context release];

  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self stopAnimation];
}

- (void)viewDidUnload
{
	[super viewDidUnload];

  if (program)
  {
    glDeleteProgram(program);
    program = 0;
  }

    // Tear down context.
  if ([EAGLContext currentContext] == context)
    [EAGLContext setCurrentContext:nil];
	self.context = nil;
}

- (NSInteger)animationFrameInterval
{
  return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
  if (frameInterval >= 1)
  {
    animationFrameInterval = frameInterval;

    if (animating)
    {
      [self stopAnimation];
      [self startAnimation];
    }
  }
}

- (void)startAnimation
{
  if (!animating)
  {
    CADisplayLink *aDisplayLink =
        [CADisplayLink displayLinkWithTarget:self
                                    selector:@selector(drawFrame)];
    [aDisplayLink setFrameInterval:animationFrameInterval];
    [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    self.displayLink = aDisplayLink;

    animating = TRUE;
  }
}

- (void)stopAnimation
{
  if (animating)
  {
    [self.displayLink invalidate];
    self.displayLink = nil;
    animating = FALSE;
  }
}


#import "drawers.h"

int count = 0;
- (void)drawFrame
{
  [(EAGLView *)self.view setFramebuffer];

	if (count == 0)
	{
		//float scale = 1.0;

		//if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
		//	scale = [UIScreen mainScreen].scale;

		[self resize:width h:height];
		//[self resize:1500 h:5];
	}
	count++;

  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

  glClear(GL_COLOR_BUFFER_BIT);

	if ([Preferences global].shouldShowFog)
		glEnable(GL_FOG);
	else
		glDisable(GL_FOG);

	drawWorld();

	glEnable(GL_TEXTURE_2D);
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_CULL_FACE);
	glDisableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);

	static GLfloat paddleCoords[] = {
    -0.5f, -0.33f, 0,
    0.5f, -0.33f, 0,
    -0.5f,  0.33f, 0.0f,
    0.5f,  0.33f, 0.0f,
  };

  int eX = [GameState global].eX;
  int eY = [GameState global].eY;
  int bX = [GameState global].bX;
  int bY = [GameState global].bY;
  int bZ = [GameState global].bZ;
	if ([Preferences global].gameType == 0)
	{
		paddleCoords[0] = eX-hPaddleWidth;
		paddleCoords[1] = eY-hPaddleHeight;
		paddleCoords[2] = -depth;
		paddleCoords[3] = eX+hPaddleWidth;
		paddleCoords[4] = eY-hPaddleHeight;
		paddleCoords[5] = -depth;
		paddleCoords[6] = eX-hPaddleWidth;
		paddleCoords[7] = eY+hPaddleHeight;
		paddleCoords[8] = -depth;
		paddleCoords[9] = eX+hPaddleWidth;
		paddleCoords[10] = eY+hPaddleHeight;
		paddleCoords[11] = -depth;

		glVertexPointer(3, GL_FLOAT, 0, paddleCoords);
		glTexCoordPointer(2, GL_FIXED, 0, txPaddle->coordBuff);
		glBindTexture(GL_TEXTURE_2D,tileset1);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

		paddleCoords[0] = bX-ballRadius;
		paddleCoords[1] = bY-ballRadius;
		paddleCoords[2] = bZ;
		paddleCoords[3] = bX-ballRadius;
		paddleCoords[4] = bY+ballRadius;
		paddleCoords[5] = bZ;
		paddleCoords[6] = bX+ballRadius;
		paddleCoords[7] = bY-ballRadius;
		paddleCoords[8] = bZ;
		paddleCoords[9] = bX+ballRadius;
		paddleCoords[10] = bY+ballRadius;
		paddleCoords[11] = bZ;

		//glVertexPointer(3, GL_FLOAT, 0, paddleCoords);
		glTexCoordPointer(2, GL_FIXED, 0, txBall->coordBuff);
		//glBindTexture(GL_TEXTURE_2D,tileset1);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

		//glVertexPointer(3, GL_FLOAT, 0, paddleCoords);
		glTexCoordPointer(2, GL_FIXED, 0, txTransBall->coordBuff);
		//glBindTexture(GL_TEXTURE_2D,tileset1);

		paddleCoords[0] = -hFloatWidth;
		paddleCoords[1] = bY-ballRadius;
		paddleCoords[2] = bZ-ballRadius;
		paddleCoords[3] = -hFloatWidth;
		paddleCoords[4] = bY+ballRadius;
		paddleCoords[5] = bZ-ballRadius;
		paddleCoords[6] = -hFloatWidth;
		paddleCoords[7] = bY-ballRadius;
		paddleCoords[8] = bZ+ballRadius;
		paddleCoords[9] = -hFloatWidth;
		paddleCoords[10] = bY+ballRadius;
		paddleCoords[11] = bZ+ballRadius;
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

		paddleCoords[0] = hFloatWidth;
		paddleCoords[1] = bY-ballRadius;
		paddleCoords[2] = bZ-ballRadius;
		paddleCoords[3] = hFloatWidth;
		paddleCoords[4] = bY+ballRadius;
		paddleCoords[5] = bZ-ballRadius;
		paddleCoords[6] = hFloatWidth;
		paddleCoords[7] = bY-ballRadius;
		paddleCoords[8] = bZ+ballRadius;
		paddleCoords[9] = hFloatWidth;
		paddleCoords[10] = bY+ballRadius;
		paddleCoords[11] = bZ+ballRadius;
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

		paddleCoords[0] = bX-ballRadius;
		paddleCoords[1] = -hFloatHeight;
		paddleCoords[2] = bZ+ballRadius;
		paddleCoords[3] = bX-ballRadius;
		paddleCoords[4] = -hFloatHeight;
		paddleCoords[5] = bZ-ballRadius;
		paddleCoords[6] = bX+ballRadius;
		paddleCoords[7] = -hFloatHeight;
		paddleCoords[8] = bZ+ballRadius;
		paddleCoords[9] = bX+ballRadius;
		paddleCoords[10] = -hFloatHeight;
		paddleCoords[11] = bZ-ballRadius;
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

		paddleCoords[0] = bX-ballRadius;
		paddleCoords[1] = hFloatHeight;
		paddleCoords[2] = bZ+ballRadius;
		paddleCoords[3] = bX-ballRadius;
		paddleCoords[4] = hFloatHeight;
		paddleCoords[5] = bZ-ballRadius;
		paddleCoords[6] = bX+ballRadius;
		paddleCoords[7] = hFloatHeight;
		paddleCoords[8] = bZ+ballRadius;
		paddleCoords[9] = bX+ballRadius;
		paddleCoords[10] = hFloatHeight;
		paddleCoords[11] = bZ-ballRadius;
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}

  int pX = [GameState global].pX;
  int pY = [GameState global].pY;
	paddleCoords[0] = pX-hPaddleWidth;
	paddleCoords[1] = pY-hPaddleHeight;
	paddleCoords[2] = 0;
	paddleCoords[3] = pX+hPaddleWidth;
	paddleCoords[4] = pY-hPaddleHeight;
	paddleCoords[5] = 0;
	paddleCoords[6] = pX-hPaddleWidth;
	paddleCoords[7] = pY+hPaddleHeight;
	paddleCoords[8] = 0;
	paddleCoords[9] = pX+hPaddleWidth;
	paddleCoords[10] = pY+hPaddleHeight;
	paddleCoords[11] = 0;

	glVertexPointer(3, GL_FLOAT, 0, paddleCoords);
	glTexCoordPointer(2, GL_FIXED, 0, txPaddle->coordBuff);
	glBindTexture(GL_TEXTURE_2D,tileset1);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

	switch (state) {
		case HOME:
			drawState0();
			break;
		case PLAYING:
			drawState1();
			break;
		case OPTIONS:
			drawState2();
			break;
		case PAUSED:
			drawState3();
			break;
		case START:
			drawState7();
			break;
		case RESULTS:
			drawState8();
			break;
		default:
			break;
	}

	for (int j=0; stateButtons[stateToInt(state)][j] != NULL; j++) {
    [stateButtons[stateToInt(state)][j] draw];
  }

  [(EAGLView *)self.view presentFramebuffer];
	count++;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
  GLint status;
  const GLchar *source;

  source = (GLchar *)[[NSString stringWithContentsOfFile:file
                                                encoding:NSUTF8StringEncoding
                                                   error:nil] UTF8String];
  if (!source)
  {
    NSLog(@"Failed to load vertex shader");
    return FALSE;
  }

  *shader = glCreateShader(type);
  glShaderSource(*shader, 1, &source, NULL);
  glCompileShader(*shader);

#if defined(DEBUG)
  GLint logLength;
  glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0)
  {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetShaderInfoLog(*shader, logLength, &logLength, log);
    NSLog(@"Shader compile log:\n%s", log);
    free(log);
  }
#endif

  glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
  if (status == 0)
  {
    glDeleteShader(*shader);
    return FALSE;
  }

  return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
  GLint status;

  glLinkProgram(prog);

#if defined(DEBUG)
  GLint logLength;
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0)
  {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program link log:\n%s", log);
    free(log);
  }
#endif

  glGetProgramiv(prog, GL_LINK_STATUS, &status);
  if (status == 0) {
    return FALSE;
  }

  return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
  GLint logLength, status;

  glValidateProgram(prog);
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0)
  {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program validate log:\n%s", log);
    free(log);
  }

  glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
  if (status == 0) {
    return FALSE;
  }

  return TRUE;
}

- (BOOL)loadShaders
{
  GLuint vertShader, fragShader;
  NSString *vertShaderPathname, *fragShaderPathname;

  // Create shader program.
  program = glCreateProgram();

  // Create and compile vertex shader.
  vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader"
                                                       ofType:@"vsh"];
  if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
  {
    NSLog(@"Failed to compile vertex shader");
    return FALSE;
  }

  // Create and compile fragment shader.
  fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader"
                                                       ofType:@"fsh"];
  if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
  {
    NSLog(@"Failed to compile fragment shader");
    return FALSE;
  }

  // Attach vertex shader to program.
  glAttachShader(program, vertShader);

  // Attach fragment shader to program.
  glAttachShader(program, fragShader);

  // Bind attribute locations.
  // This needs to be done prior to linking.
  glBindAttribLocation(program, ATTRIB_VERTEX, "position");
  glBindAttribLocation(program, ATTRIB_COLOR, "color");

  // Link program.
  if (![self linkProgram:program])
  {
    NSLog(@"Failed to link program: %d", program);

    if (vertShader)
    {
      glDeleteShader(vertShader);
      vertShader = 0;
    }
    if (fragShader)
    {
      glDeleteShader(fragShader);
      fragShader = 0;
    }
    if (program)
    {
      glDeleteProgram(program);
      program = 0;
    }

    return FALSE;
  }

  // Get uniform locations.
  uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(program, "translate");

  // Release vertex and fragment shaders.
  if (vertShader)
    glDeleteShader(vertShader);
  if (fragShader)
    glDeleteShader(fragShader);

  return TRUE;
}

static GLfloat* wallVertices;

#import "buttonHandlers.h"

#import "gettersSetters.h"

- (void)resize:(int)w h:(int)h
{
	NSLog(@"%d %d", w, h);
	[PongViewController loadSaved];

	tileset1 = [self LoadTexture:@"tileset1"];
	smallTexFont = [self LoadTexture:@"smallfont"];
	medTexFont = [self LoadTexture:@"medfont"];
	bigTexFont = [self LoadTexture:@"bigfont"];

	txPaddle = [[TextureCoord alloc] initTextureCoord:0
                                                  y:24
                                              width:12
                                             height:8
                                             totalX:32
                                             totalY:32];
	txPaddle->coordBuff[1]+=150;
	txPaddle->coordBuff[3]+=150;
	txPaddle->coordBuff[5]-=150;
	txPaddle->coordBuff[7]-=150;

	txBall = [[TextureCoord alloc] initTextureCoord:4
                                                y:0
                                            width:4
                                           height:4
                                           totalX:32
                                           totalY:32];
	txTransBall = [[TextureCoord alloc] initTextureCoord:0
                                                     y:0
                                                 width:4
                                                height:4
                                                totalX:32
                                                totalY:32];

	button[0] = [[TextureCoord alloc] initTextureCoord:25
                                                   y:24
                                               width:1
                                              height:8
                                              totalX:32
                                              totalY:32];
	button[1] = [[TextureCoord alloc] initTextureCoord:26
                                                   y:24
                                               width:1
                                              height:8
                                              totalX:32
                                              totalY:32];
	button[2] = [[TextureCoord alloc] initTextureCoord:27
                                                   y:24
                                               width:1
                                              height:8
                                              totalX:32
                                              totalY:32];

	button2[0] = [[TextureCoord alloc] initTextureCoord:21
                                                    y:24
                                                width:1
                                               height:8
                                               totalX:32
                                               totalY:32];
	button2[1] = [[TextureCoord alloc] initTextureCoord:22
                                                    y:24
                                                width:1
                                               height:8
                                               totalX:32
                                               totalY:32];
	button2[2] = [[TextureCoord alloc] initTextureCoord:23
                                                    y:24
                                                width:1
                                               height:8
                                               totalX:32
                                               totalY:32];

	button3[0] = [[TextureCoord alloc] initTextureCoord:29
                                                    y:24
                                                width:1
                                               height:8
                                               totalX:32
                                               totalY:32];
	button3[1] = [[TextureCoord alloc] initTextureCoord:30
                                                    y:24
                                                width:1
                                               height:8
                                               totalX:32
                                               totalY:32];
	button3[2] = [[TextureCoord alloc] initTextureCoord:31
                                                    y:24
                                                width:1
                                               height:8
                                               totalX:32
                                               totalY:32];

	button[0]->coordBuff[1]+=150;
	button[0]->coordBuff[3]+=150;
	button[1]->coordBuff[1]+=150;
	button[1]->coordBuff[3]+=150;
	button[2]->coordBuff[1]+=150;
	button[2]->coordBuff[3]+=150;

	button2[0]->coordBuff[1]+=150;
	button2[0]->coordBuff[3]+=150;
	button2[1]->coordBuff[1]+=150;
	button2[1]->coordBuff[3]+=150;
	button2[2]->coordBuff[1]+=150;
	button2[2]->coordBuff[3]+=150;

	button3[0]->coordBuff[1]+=150;
	button3[0]->coordBuff[3]+=150;
	button3[1]->coordBuff[1]+=150;
	button3[1]->coordBuff[3]+=150;
	button3[2]->coordBuff[1]+=150;
	button3[2]->coordBuff[3]+=150;

	//for(int i=0;i<8;i++)
	//	NSLog(@"%i",txPaddle->coordBuff[i]);


	glEnable(GL_FOG);
	glFogf(GL_FOG_MODE, GL_LINEAR);
	glFogf(GL_FOG_START, altitude);
	glFogf(GL_FOG_END, altitude + depth*2);

	glEnable(GL_DITHER);
	//glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
	//glBlendFunc( GL_SRC_ALPHA_SATURATE, GL_ONE );
	glEnable(GL_BLEND);
	glEnable(GL_CULL_FACE);
	glEnable(GL_SMOOTH);
	glDisable( GL_DEPTH_TEST );
	wallVertices = (GLfloat *)malloc(3*4*8*4*(sizeof(CGFloat)));

	width = w;
	height = h;
	gwidth = w;
	gheight = h;

	floatHeight = (int)(.3*65536);
	floatWidth = floatHeight*width/height;
	hFloatHeight = floatHeight/2;
	hFloatWidth = floatWidth/2;

	ballRadius = floatWidth/30;
	paddleHeight = floatHeight/4;
	paddleWidth = floatWidth/4;
	hPaddleHeight = paddleHeight/2;
	hPaddleWidth = paddleWidth/2;
	fontSize = floatWidth/40;

	[GameState global].bZ = -ballRadius;

	setUpWalls();

	setUpFonts();

/*	if(gameType == 1)
	{
		if(state != TARGET)
			switchToState(START);
		curLev = new Level(parseXmlFile(levelStrings.get(level)));
	}
	*///TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

	double angle = atan(((float)hFloatWidth)/altitude);
	angle = 2.0*angle*180.0/M_PI;

	glRotatef(-90,0,0,1);
	perspective(angle,(double)((double)floatHeight)/((double)floatWidth),altitude/2,depth*2);
	gluLookAt(0,0,altitude,0,0,0,0,1,0);

	for (int i=0;i<20;i++)
		for (int j=0;j<40;j++)
			stateButtons[i][j] = NULL;

	Button *s0b0d =  [[Button alloc] initButton:-fontSize*5
                                            y:27*fontSize/4
                                        width:hFloatWidth/2
                                       height:9*fontSize/2
                                         text:@"Play!"
                                     textSize:fontSize*9/4
                                     gameType:-1
                                  multiPlayer:0];
	s0b0d->handler = s0b0dh;
	stateButtons[0][0] = s0b0d;

	Button *s0b1d =  [[Button alloc] initButton:-hFloatWidth+fontSize
                                            y:2*fontSize/2
                                        width:hFloatWidth
                                       height:8*fontSize/2
                                         text:@"Target Mode"
                                     textSize:fontSize*2
                                     gameType:-1
                                  multiPlayer:0];
	s0b1d->handler = s0b1dh;
	s0b1d->enabled = false;
	stateButtons[0][1] = s0b1d;

	Button *s0b2d = [[Button alloc] initButton:2*fontSize
                                           y:2*fontSize/2
                                       width:fontSize*17
                                      height:8*fontSize/2
                                        text:@"Multiplayer"
                                    textSize:fontSize*2
                                    gameType:-1
                                 multiPlayer:0];
	s0b2d->handler = s0b2dh;
	s0b2d->enabled = false;
	stateButtons[0][2] = s0b2d;

	Button *s0b3d =  [[Button alloc] initButton:-hFloatWidth+fontSize*3
                                            y:-9*fontSize/2
                                        width:fontSize*13
                                       height:8*fontSize/2
                                         text:@"Options"
                                     textSize:fontSize*2
                                     gameType:-1
                                  multiPlayer:0];
	s0b3d->handler = s0b3dh;
	stateButtons[0][3] = s0b3d;

	Button *s1b0d =  [[Button alloc] initButton:hFloatWidth-fontSize*3
                                            y:hFloatHeight
                                        width:fontSize*3
                                       height:5*fontSize/2
                                         text:@"||"
                                     textSize:fontSize*5/4
                                     gameType:-1
                                  multiPlayer:0];
	s1b0d->handler = s1b0dh;
	stateButtons[1][0] = s1b0d;

	Button *s2b0d =  [[Button alloc] initButton:hFloatWidth-fontSize*7
                                            y:-hFloatHeight+fontSize*9/2
                                        width:fontSize*6
                                       height:4*fontSize
                                         text:@"OK"
                                     textSize:fontSize*2
                                     gameType:-1
                                  multiPlayer:-1];
	s2b0d->gameType = 0;
	s2b0d->handler = s2b0dh;
	stateButtons[2][0] = s2b0d;

	Button *s2b1d =  [[Button alloc] initButton:-fontSize*18
                                            y:hFloatHeight-fontSize*5
                                        width:fontSize*5
                                       height:3*fontSize
                                         text:@"Off"
                                     textSize:fontSize*3/2
                                     gameType:-1
                                  multiPlayer:-1];
	s2b1d->gameType = 0;
	s2b1d->handler = s2b1dh;
	stateButtons[2][1] = s2b1d;

	Button *s2b2d =  [[Button alloc] initButton:-fontSize*8-fontSize/2
                                            y:hFloatHeight-fontSize*5
                                        width:fontSize*5
                                       height:3*fontSize
                                         text:@"Off"
                                     textSize:fontSize*3/2
                                     gameType:-1
                                  multiPlayer:-1];
	s2b2d->gameType = 0;
	s2b2d->handler = s2b2dh;
	stateButtons[2][2] = s2b2d;

	Button *s2b3d =  [[Button alloc] initButton:0
                                            y:hFloatHeight-fontSize*5
                                        width:fontSize*10
                                       height:3*fontSize
                                         text:@"Medium"
                                     textSize:fontSize*3/2
                                     gameType:-1
                                  multiPlayer:-1];
	s2b3d->gameType = 0;
	s2b3d->handler = s2b3dh;
	stateButtons[2][3] = s2b3d;

	Button *s2b4d =  [[Button alloc] initButton:fontSize*13
                                            y:hFloatHeight-fontSize*5
                                        width:fontSize*5
                                       height:3*fontSize
                                         text:@"Off"
                                     textSize:fontSize*3/2
                                     gameType:-1
                                  multiPlayer:-1];
	s2b4d->gameType = 0;
	s2b4d->handler = s2b4dh;
	stateButtons[2][4] = s2b4d;

	Button *s2b5d =  [[Button alloc] initButton:-fontSize*15-fontSize/2
                                            y:hFloatHeight-fontSize*11
                                        width:fontSize*7
                                       height:3*fontSize
                                         text:@"Touch"
                                     textSize:fontSize*3/2
                                     gameType:-1
                                  multiPlayer:-1];
	s2b5d->gameType = 0;
	s2b5d->handler = s2b5dh;
	s2b5d->enabled = false;
	stateButtons[2][5] = s2b5d;

  int difficulty = [Preferences global].difficulty;
  int inputMethod = [Preferences global].inputMethod;
	if ([Preferences global].shouldPlaySound)	{
		[stateButtons[2][1] changeText:@"On"];
	}	else {
		[stateButtons[2][1] changeText:@"Off"];
	}

	if ([Preferences global].shouldVibrate)	{
		[stateButtons[2][2] changeText:@"On"];
	}	else {
		[stateButtons[2][2] changeText:@"Off"];
	}

	if (difficulty == 0) {
		[stateButtons[2][3] changeText:@"Easy"];
	}	else if (difficulty == 1) {
		[stateButtons[2][3] changeText:@"Medium"];
	}	else if (difficulty == 2) {
		[stateButtons[2][3] changeText:@"Hard"];
	}

	if ([Preferences global].shouldShowFog)	{
		[stateButtons[2][4] changeText:@"On"];
	}	else {
		[stateButtons[2][4] changeText:@"Off"];
	}

	if (inputMethod == 0)	{
		[stateButtons[2][5] changeText:@"Touch"];
	}	else if(inputMethod == 1)	{
		[stateButtons[2][5] changeText:@"Tilt"];
	}

	Button *s3b0d =  [[Button alloc] initButton:hFloatWidth-fontSize*6
                                            y:-hFloatHeight+fontSize*5/2
                                        width:fontSize*6
                                       height:5*fontSize/2
                                         text:@"Quit"
                                     textSize:fontSize*5/4
                                     gameType:-1
                                  multiPlayer:0];
	s3b0d->handler = homeButton;
	stateButtons[3][0] = s3b0d;

	Button *s7b0d =  [[Button alloc] initButton:hFloatWidth-fontSize*6
                                            y:-hFloatHeight+fontSize*5/2
                                        width:fontSize*6
                                       height:5*fontSize/2
                                         text:@"Quit"
                                     textSize:fontSize*5/4
                                     gameType:-1
                                  multiPlayer:0];
	s7b0d->handler = homeButton;
	stateButtons[7][0] = s7b0d;

	Button *s8b0d =  [[Button alloc] initButton:hFloatWidth-fontSize*17
                                            y:hFloatHeight-fontSize*5-fontSize*21/2
                                        width:fontSize*15
                                       height:3*fontSize
                                         text:@"Submit Score"
                                     textSize:fontSize*3/2
                                     gameType:0
                                  multiPlayer:0];
	s8b0d->handler = s8b0dh;
	s8b0d->enabled = false;
	stateButtons[8][0] = s8b0d;

	Button *s8b1d =  [[Button alloc] initButton:-hFloatWidth+fontSize*2
                                            y:hFloatHeight-fontSize*5-fontSize*21/2
                                        width:fontSize*17/2
                                       height:3*fontSize
                                         text:@"Home"
                                     textSize:fontSize*3/2
                                     gameType:0
                                  multiPlayer:0];
	s8b1d->handler = homeButton;
	stateButtons[8][1] = s8b1d;


	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("bullseye"), CFSTR("caf"), NULL), &mpBullseye);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("lostshort"), CFSTR("caf"), NULL), &mpLostshort);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("ping"), CFSTR("caf"), NULL), &mpPing);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("target"), CFSTR("caf"), NULL), &mpTarget);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("wall1"), CFSTR("caf"), NULL), &mpWall1);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("wall3"), CFSTR("caf"), NULL), &mpWall3);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("lost"), CFSTR("caf"), NULL), &mpLost);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("menu"), CFSTR("caf"), NULL), &mpMenu);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("pong"), CFSTR("caf"), NULL), &mpPong);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("targetbounce"), CFSTR("caf"), NULL), &mpTargetbounce);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("wall2"), CFSTR("caf"), NULL), &mpWall2);
	AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("won"), CFSTR("caf"), NULL), &mpWon);
//AudioServicesPlaySystemSound(mpBullseye);

	running = TRUE;
	//state = PLAYING;

	NSThread *newThread = [[NSThread alloc] initWithTarget:self
                                                selector:@selector(gameLoop:)
                                                  object:nil];
  [newThread start];
}

- (void)gameLoop:(id)input
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSDate *date = [NSDate date];

	long long delta;
	long long time = [date timeIntervalSince1970] * 1000.0;
	//NSLog(@"asdf %lld",time);
	int spinCounter = 0;

	srand(time);

	while (running)
	{
		//NSLog(@"%i",count++);
		switch(state)
		{
			case NONE:
				fps = 2;
				break;
			case HOME:
				fps = 5;
				break;
			case PLAYING:
				fps = 20;
				break;
			case OPTIONS:
				fps = 5;
				break;
			case OPTIONS2:
				fps = 5;
				break;
			case PAUSED:
				fps = 5;
				break;
			case MULTIPLAYER:
				fps = 5;
				break;
			case JOINIP:
				fps = 5;
				break;
			case ERROR:
				fps = 5;
				break;
			case START:
				if ([Preferences global].gameType == 1)
					fps = 20;
        else
          fps = 5;
        break;
			case RESULTS:
				fps = 5;
				break;
			case TARGET:
				fps = 5;
				break;
		}
		delta = 1000/fps;
		long long ttime;
		//NSDate * newDate = [NSDate date];
		if (time + delta > (ttime = ((long long)([[NSDate date] timeIntervalSince1970] * 1000.0))))
		{
			//try
			{
				//long long ftime = [date timeIntervalSince1970] * 1000.0;
				//NSLog(@"%f",((double)((time+delta)-ttime))/1000.0);
				[NSThread sleepForTimeInterval:((double)((time+delta)-ttime))/1000.0];
				//usleep(1000);
				//long long ltime = [date timeIntervalSince1970] * 1000.0;

				//NSLog(@"%lld <<<",ltime-ftime);
				//Thread.sleep((time+delta)-ttime);
			}
			//catch(InterruptedException ex)
			{

			}
		}
		time += delta;
		//NSLog(@"%i %i %lld %lld %lld",count++,fps,delta,time,ttime);

		int numPingToPlay = 0;
		int numPongToPlay = 0;
		int numWall1ToPlay = 0;
		int numWall2ToPlay = 0;
		int numWall3ToPlay = 0;
		//			int numExplodeToPlay = 0;
		int numTargetToPlay = 0;
		int numTargetbounceToPlay = 0;
		int numLostshortToPlay = 0;
		int numLostToPlay = 0;
		int numWonToPlay = 0;
		int numBullseyeToPlay = 0;

		@synchronized (sem)
		{
			//NSLog(@"loop %d %d",stateToInt(state),spinCounter);
			spinCounter++;
			if (spinCounter == 16)
				spinCounter = 0;

      if ([Preferences global].gameType == 0)
      {
        if (state == PLAYING)
        {
          memmove(mxs+1, mxs, 4*sizeof(int));
          memmove(mys+1, mys, 4*sizeof(int));
          mxs[0] = [GameState global].pX;
          mys[0] = [GameState global].pY;

          if (isCurveball)
          {
            [GameState global].bXSpeed += [GameState global].xAcceleration;
            [GameState global].bYSpeed += [GameState global].yAcceleration;
            int bXSpeed = [GameState global].bXSpeed;
            int bYSpeed = [GameState global].bYSpeed;
            int bZSpeed = [GameState global].bZSpeed;
            int vecLength =
                (int)sqrt(bXSpeed*bXSpeed+bYSpeed*bYSpeed+bZSpeed*bZSpeed);

            if (vecLength != 0)
            {
              [GameState global].bX += abs(bZSpeed)*bXSpeed/vecLength;
              [GameState global].bY += abs(bZSpeed)*bYSpeed/vecLength;
              [GameState global].bZ += abs(bZSpeed)*bZSpeed/vecLength;
            }
          }
          else
          {
            [GameState global].bX += [GameState global].bXSpeed;
            [GameState global].bY += [GameState global].bYSpeed;
            [GameState global].bZ += [GameState global].bZSpeed;
          }

          if ([GameState global].bX > hFloatWidth-ballRadius)
          {
            [GameState global].bX = (hFloatWidth-ballRadius);
            [GameState global].bXSpeed *= -1;
            numWall3ToPlay++;
          }
          if ([GameState global].bX < -hFloatWidth+ballRadius)
          {
            [GameState global].bX = (-hFloatWidth+ballRadius);
            [GameState global].bXSpeed *= -1;
            numWall3ToPlay++;
          }

          if ([GameState global].bY > hFloatHeight-ballRadius)
          {
            [GameState global].bY = (hFloatHeight-ballRadius);
            [GameState global].bYSpeed *= -1;
            numWall2ToPlay++;
          }
          if ([GameState global].bY < -hFloatHeight+ballRadius)
          {
            [GameState global].bY = (-hFloatHeight+ballRadius);
            [GameState global].bYSpeed *= -1;
            numWall2ToPlay++;
          }

          if ([GameState global].bZ > 0-ballRadius)
          {
            tellOpponent = true;
            if ([GameState global].bX >= [GameState global].pX-hPaddleWidth-ballRadius &&
                [GameState global].bX <= [GameState global].pX+hPaddleWidth+ballRadius &&
                [GameState global].bY >= [GameState global].pY-hPaddleHeight-ballRadius &&
                [GameState global].bY <= [GameState global].pY+hPaddleHeight+ballRadius)
            {
              [GameState global].bZ = 0-ballRadius;
              [GameState global].bZSpeed = (int)([GameState global].bZSpeed * -1.05);
              if ([GameState global].bZSpeed > 30000)
                [GameState global].bZSpeed = 30000;
              if ([GameState global].bZSpeed < -30000)
                [GameState global].bZSpeed = -30000;

              if (isCurveball)
              {
                [GameState global].bXSpeed /= 2;
                [GameState global].bYSpeed /= 2;
              }

              numPingToPlay++;

              if (multiPlayerStatus == 0)
                [GameState global].myScore +=
                    [GameState global].level + 1 + [Preferences global].difficulty;

              //		if(vibrator != null && Pong.vibrate)
              //			vibrator.vibrate(50);

              if (mxs[4] != 0 || mys[4] != 0)
              {
                if (isCurveball)
                {
                  [GameState global].xAcceleration = -(mxs[0]-mxs[4])*multiplier/divisor/100;
                  [GameState global].yAcceleration = -(mys[0]-mys[4])*multiplier/divisor/100;
                }
                else
                {
                  [GameState global].bXSpeed += (mxs[0]-mxs[4])*multiplier/divisor/10;
                  [GameState global].bYSpeed += (mys[0]-mys[4])*multiplier/divisor/10;
                }
              }
              else if (isCurveball)
              {
                [GameState global].xAcceleration = 0;
                [GameState global].yAcceleration = 0;
              }
            }
            else
            {
              //switchToState(START);
              [PongViewController switchToState:START];
              lastOutcome = 1;
              [GameState global].numberOfLives = [GameState global].numberOfLives -1;
              //enScore++;
              gameReset();
              numLostToPlay++;

              /*if(!fullVersion && multiPlayerStatus == 0)
               {
               Message mes = new Message();
               Bundle dat = new Bundle();
               dat.putString("action", "vis");
               mes.setData(dat);
               Pong.staticAdHandler.sendMessage(mes);
               }*/


              if (multiPlayerStatus != 0)
              {
                enScore++;
                iLost = true;
                //switchToState(PLAYING);
                [PongViewController switchToState:PLAYING];
                [GameState global].bZ = -depth+ballRadius;
                [GameState global].bZSpeed = 0;
              }
              else if ([GameState global].numberOfLives <= 0)
              {
                [[GameState global] recordMyScore];
                [PongViewController switchToState:RESULTS];
              }
            }
          }
          if ([GameState global].bZ < -depth+ballRadius)
          {
            if (multiPlayerStatus == 0)
            {
              if ([GameState global].bX >= [GameState global].eX-hPaddleWidth-ballRadius &&
                  [GameState global].bX <= [GameState global].eX+hPaddleWidth+ballRadius &&
                  [GameState global].bY >= [GameState global].eY-hPaddleHeight-ballRadius &&
                  [GameState global].bY <= [GameState global].eY+hPaddleHeight+ballRadius)
              {
                [GameState global].bZ = -depth + ballRadius;
                [GameState global].bZSpeed = (int)([GameState global].bZSpeed * -1.05);
                if ([GameState global].bZSpeed > 30000)
                  [GameState global].bZSpeed = 30000;
                if ([GameState global].bZSpeed < -30000)
                  [GameState global].bZSpeed = -30000;

                if (isCurveball)
                {
                  [GameState global].bXSpeed /= 2;
                  [GameState global].bYSpeed /= 2;

                  [GameState global].xAcceleration = rand() % randEnemy - randEnemy/2;
                  [GameState global].yAcceleration = rand() % randEnemy - randEnemy/2;
                }
                else
                {
                  [GameState global].bXSpeed += rand() % randEnemy*2 - randEnemy;
                  [GameState global].bYSpeed += rand() % randEnemy*2 - randEnemy;
                }
                numPongToPlay++;
              }
              else
              {
                /*if(!fullVersion && multiPlayerStatus == 0)
                 {
                 Message mes = new Message();
                 Bundle dat = new Bundle();
                 dat.putString("action", "vis");
                 mes.setData(dat);
                 Pong.staticAdHandler.sendMessage(mes);
                 }*/

                //switchToState(START);
                [PongViewController switchToState:START];
                lastOutcome = 0;
                [GameState global].myScore +=
                    ([GameState global].level + 1 + [Preferences global].difficulty)*20;
                [GameState global].level = [GameState global].level +1;
                gameReset();
                numWonToPlay++;
              }
            }
            else
            {
              if ([GameState global].bZSpeed < 0)
              {
                [GameState global].bXSpeed = 0;
                [GameState global].bYSpeed = 0;
                [GameState global].bZSpeed = 0;
                [GameState global].bZ = -depth+ballRadius;
                waitingForOp = true;
              }
            }
          }

          if (multiPlayerStatus == 0)
          {
            if([GameState global].eX<[GameState global].bX)
            {
              if ([GameState global].bX-[GameState global].eX<=eSpeed/(isCurveball?2:1))
                [GameState global].eX=[GameState global].bX;
              else
                [GameState global].eX+=eSpeed/(isCurveball?2:1);
            }
            else
            {
              if ([GameState global].eX-[GameState global].bX<=eSpeed/(isCurveball?2:1))
                [GameState global].eX=[GameState global].bX;
              else
                [GameState global].eX-=eSpeed/(isCurveball?2:1);
            }
            if ([GameState global].eY<[GameState global].bY)
            {
              if ([GameState global].bY-[GameState global].eY<=eSpeed/(isCurveball?2:1))
                [GameState global].eY=[GameState global].bY;
              else
                [GameState global].eY += eSpeed/(isCurveball?2:1);
            }
            else
            {
              if ([GameState global].eY-[GameState global].bY<=eSpeed/(isCurveball?2:1))
                [GameState global].eY=[GameState global].bY;
              else
                [GameState global].eY-=eSpeed/(isCurveball?2:1);
            }

            if ([GameState global].eX < -hFloatWidth+hPaddleWidth)
              [GameState global].eX = (-hFloatWidth+hPaddleWidth);
            if ([GameState global].eY < -hFloatHeight+hPaddleHeight)
              [GameState global].eY = (-hFloatHeight+hPaddleHeight);
            if ([GameState global].eX > hFloatWidth-hPaddleWidth)
              [GameState global].eX = (hFloatWidth-hPaddleWidth);
            if ([GameState global].eY > hFloatHeight-hPaddleHeight)
              [GameState global].eY = (hFloatHeight-hPaddleHeight);
          }
        }
      }
		}

		if(numPingToPlay != 0)
		{
      NSLog(@"numPingToPlay");
			[SoundMan playSound:mpPing];
		}
		if(numPongToPlay != 0)
		{
      NSLog(@"numPongToPlay");
			[SoundMan playSound:mpPong];
		}
		if(numWall1ToPlay != 0)
		{
     NSLog(@"numWall1ToPlay");
			[SoundMan playSound:mpWall1];
		}
		if(numWall2ToPlay != 0)
		{
      NSLog(@"numWall2ToPlay");
			[SoundMan playSound:mpWall2];
		}
		if(numWall3ToPlay != 0)
		{
      NSLog(@"numWall3ToPlay");
			[SoundMan playSound:mpWall3];
		}
		if(numTargetToPlay != 0)
		{
      NSLog(@"numTargetToPlay");
      [SoundMan playSound:mpTarget];
		}
		if(numTargetbounceToPlay != 0)
		{
      NSLog(@"numTargetbounceToPlay");
			[SoundMan playSound:mpTargetbounce];
		}
		if(numLostToPlay != 0)
		{
      NSLog(@"numLostToPlay");
			[SoundMan playSound:mpLost];
		}
		if(numWonToPlay != 0)
		{
      NSLog(@"numWonToPlay");
			[SoundMan playSound:mpWon];
		}
		if(numLostshortToPlay != 0)
		{
       NSLog(@"numLostshortToPlay");
			[SoundMan playSound:mpLostshort];
		}
		if(numBullseyeToPlay != 0)
		{
     NSLog(@"numBullseyeToPlay");
			[SoundMan playSound:mpBullseye];
		}
	}

	[pool release];
}

static const GLubyte darkColor[] = {
	0, 0x73,   0xc1, 255,
	0, 0x73,   0xc1, 255,
	0, 0x73,   0xc1, 255,
	0, 0x73,   0xc1, 255,
};

static const GLubyte lightColor[] = {
	0x27, 0xa8,   0xff, 255,
	0x27, 0xa8,   0xff, 255,
	0x27, 0xa8,   0xff, 255,
	0x27, 0xa8,   0xff, 255,
};

void drawWorld()
{
	glMatrixMode(GL_PROJECTION);
	glEnableClientState(GL_COLOR_ARRAY);
	glDisable(GL_TEXTURE_2D);
	for(int i=0;i<32;i++)
	{
		glVertexPointer(3, GL_FLOAT, 0, wallVertices+i*12);
		glEnableClientState(GL_VERTEX_ARRAY);
		if(i%2)
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, lightColor);
		else
			glColorPointer(4, GL_UNSIGNED_BYTE, 0, darkColor);
		glEnableClientState(GL_COLOR_ARRAY);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
}

+ (void)switchToState:(enum States)toState
{
	switch(toState)
	{
		case HOME:
			gameReset();
			break;
		//case TARGET:
			//NSString * levelScores = prefs.getString("levelScores","");
			//NSString ** scores = levelScores.split("\n");

			//for(int i=0;i<scores.length;i++)
			//{
			//	if(!scores[i].equals(""))
			//		levelPoints[i] = Integer.parseInt(scores[i]);
			//}

			//for(int i=1;i<Pong.stateButtons[9].size();i++)
			//{
			//	if(levelPoints[i-1] == 0 && i > Math.max(prefs.getInt("levelsBeat", 0),freeLevels) && !Pong.stateButtons[9].get(i).text.equals("Full Version"))
			//		Pong.stateButtons[9].get(i).enabled = false;
			//	else
			//		Pong.stateButtons[9].get(i).enabled = true;
			//}

			//myScore = 0;
			//break;
		//case PLAYING:
			//if(Pong.inputMethod == 1)
			//{
			//	Pong.instance.tgt = new TiltGameThread(this);
			//	Pong.instance.tgt.start();
			//}
			//break;
      default:
        break;
	}

	state = toState;
}

+ (void)loadSaved
{
	[SQLite3Data readData];

	enum States toState = intToState([GameState global].state);

	if (toState == TARGET)
	{
		toState = HOME;
		[Preferences global].gameType = 0;
	}
	[PongViewController switchToState:toState];
}

@end
