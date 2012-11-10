//#import "SoundMan.h"

void s0b0dh()
{
	//NSLog(@"got hit!!!!");
	hoveredButton = NULL;
  int difficulty = [Preferences global].difficulty;
	[GameState global].bZSpeed = -bZSpeeds[difficulty];

	[GameState global].numberOfLives = (fullVersion?6:3);
	[GameState global].level = 0;
	[GameState global].myScore = 0;
	eSpeed = eSpeeds[difficulty];
	randEnemy = randEnemies[difficulty];
	[Preferences global].gameType = 0;
	[PongViewController switchToState:START];
	[SoundMan playSound:mpWall3];
}

void s0b1dh()
{
  hoveredButton = NULL;
  [PongViewController switchToState:TARGET];

  [Preferences global].gameType = 1;
  [GameState global].bZSpeed = -bZSpeeds[[Preferences global].difficulty];
  [GameState global].numberOfLives = (fullVersion?6:3);
  [GameState global].myScore = 0;
  eSpeed = eSpeeds[0];
  randEnemy = randEnemies[0];

	[SoundMan playSound:mpWall3];
}

void s0b2dh()
{
  hoveredButton = NULL;
  [PongViewController switchToState:MULTIPLAYER];
	[SoundMan playSound:mpWall3];
}

void s0b3dh()
{
  hoveredButton = NULL;

	int difficulty = [Preferences global].difficulty;
  int inputMethod = [Preferences global].inputMethod;

	if([Preferences global].shouldPlaySound)
	{
		[stateButtons[2][1] changeText:@"On"];
	}
	else
	{
		[stateButtons[2][1] changeText:@"Off"];
	}
	if([Preferences global].shouldVibrate)
	{
		[stateButtons[2][2] changeText:@"On"];
	}
	else
	{
		[stateButtons[2][2] changeText:@"Off"];
	}
	if(difficulty == 0)
	{
		[stateButtons[2][3] changeText:@"Easy"];
	}
	else if(difficulty == 1)
	{
		[stateButtons[2][3] changeText:@"Medium"];
	}
	else if(difficulty == 2)
	{
		[stateButtons[2][3] changeText:@"Hard"];
	}
	if([Preferences global].shouldShowFog)
	{
		[stateButtons[2][4] changeText:@"On"];
	}
	else
	{
		[stateButtons[2][4] changeText:@"Off"];
	}
	if(inputMethod == 0)
	{
		[stateButtons[2][5] changeText:@"Touch"];
	}
	else if(inputMethod == 1)
	{
		[stateButtons[2][5] changeText:@"Tilt"];
	}

  [PongViewController switchToState:OPTIONS];

	[SoundMan playSound:mpWall3];
}

void s0b4dh()
{
  hoveredButton = NULL;
}

void s1b0dh()
{
	hoveredButton = NULL;
	[PongViewController switchToState:PAUSED];
	[SoundMan playSound:mpWall3];
}

void homeButton()
{
	hoveredButton = NULL;
	[PongViewController switchToState:HOME];
	[SoundMan playSound:mpWall3];
}

void s2b0dh()
{
	hoveredButton = NULL;
	if (lastDownState == OPTIONS)
	{
	//	SharedPreferences.Editor editor = getPrefs().edit();
	//	editor.putInt("holdPaddleX", holdPaddleX);
	//	editor.putInt("holdPaddleY", holdPaddleY);
	//	editor.putInt("difficulty", difficulty);
	//	editor.putBoolean("sound", Pong.sound);
	//	editor.putBoolean("vibrate",Pong.vibrate);
	//	editor.putBoolean("fog",Pong.fog);
	//	editor.putFloat("tiltAccel",Pong.tiltAccel);
	//	editor.putInt("tiltSensitivity",Pong.tiltSensitivity);
	//	editor.putInt("inputMethod",Pong.inputMethod);
		/*
		 fog = prefs.getBoolean("fog",true);
		 tiltAccel = prefs.getFloat("tiltAccel", .25f);
		 tiltSensitivity = prefs.getInt("tiltSensitivity", 20);
		 inputMethod = prefs.getInt("inputMethod", 0);*/
	//	savePrefs(editor);
		[PongViewController switchToState:HOME];
		[Preferences global].gameType = 0;
		[SoundMan playSound:mpWall3];
	}
}

void s2b1dh()
{
	hoveredButton = NULL;
	if (lastDownState == OPTIONS)
	{
    [Preferences global].shouldPlaySound = ![Preferences global].shouldPlaySound;
		[SoundMan playSound:mpWall3];
	}
}

void s2b2dh()
{
	hoveredButton = NULL;
	if (lastDownState == OPTIONS)
	{
    [Preferences global].shouldVibrate = ![Preferences global].shouldVibrate;
		[SoundMan playSound:mpWall3];
	}
}

void s2b3dh()
{
  int difficulty = [Preferences global].difficulty;
	hoveredButton = NULL;
	if(lastDownState == OPTIONS)
	{
		difficulty++;
		if(difficulty == 3)
			difficulty = 0;
    [Preferences global].difficulty = difficulty;
		gameReset();
		[SoundMan playSound:mpWall3];
	}
}

void s2b4dh()
{
	hoveredButton = NULL;
	if (lastDownState == OPTIONS)
	{
    [Preferences global].shouldShowFog = ![Preferences global].shouldShowFog;
		[SoundMan playSound:mpWall3];
	}
}

void s2b5dh()
{
	hoveredButton = NULL;
  int inputMethod = [Preferences global].inputMethod;
	if (lastDownState == OPTIONS)
	{
		inputMethod++;
		if (inputMethod > 1)
			inputMethod = 0;
    [Preferences global].inputMethod = inputMethod;

		[SoundMan playSound:mpWall3];
	}
}

void s8b0dh()
{
	hoveredButton = NULL;
	if (lastDownState == RESULTS)
	{
		//submit score
	}
}
