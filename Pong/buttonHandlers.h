#import "SoundMan.h"


void s0b0dh()
{

	//NSLog(@"got hit!!!!");
	hoveredButton = NULL;
	bZSpeed = -bZSpeeds[difficulty];
	
	lives = (fullVersion?6:3);
	level = 0;
	myScore = 0;
	eSpeed = eSpeeds[difficulty];
	randEnemy = randEnemies[difficulty];
	gameType = 0;
	[PongViewController switchToState:START];
	/*try {
		playSound(mpWall3);
		 catch (IllegalStateException e) {
		e.printStackTrace();
	} catch (IOException e) {
	}*/
	playSound(mpWall3);
}




void s0b1dh()
{
			hoveredButton = NULL;
			[PongViewController switchToState:TARGET];
		//	int levelToGet = Pong.prefs.getInt("levelsBeat", 0);
		//	if(levelToGet >= levelStrings.size())
		//		levelToGet = levelStrings.size() - 1;
		//	level = levelToGet;
		//	curLev = new Level(parseXmlFile(levelStrings.get(levelToGet)));
			gameType = 1;
			bZSpeed = -bZSpeeds[difficulty];
			lives = (fullVersion?6:3);
			myScore = 0;
			eSpeed = eSpeeds[0];
			randEnemy = randEnemies[0];
			//try {
			//	playSound(mpWall3);
			//} catch (IllegalStateException e) {
			//	e.printStackTrace();
			//} catch (IOException e) {
			//}
	playSound(mpWall3);

}

void s0b2dh()
{
			hoveredButton = NULL;
			[PongViewController switchToState:MULTIPLAYER];
			//try {
			//	playSound(mpWall3);
			//} catch (IllegalStateException e) {
			//	e.printStackTrace();
			//} catch (IOException e) {
			//}
	playSound(mpWall3);

}

void s0b3dh()
{
			hoveredButton = NULL;
	
	
	
	
	if(sound)
	{
		[stateButtons[2][1] changeText:@"On"];
	}
	else
	{
		[stateButtons[2][1] changeText:@"Off"];
	}
	if(vibrate)
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
	if(fog)
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
			//try {
			//	playSound(mpWall3);
			//} catch (IllegalStateException e) {
			//	e.printStackTrace();
			//} catch (IOException e) {
			//}
	playSound(mpWall3);

}

void s0b4dh()
{
			hoveredButton = NULL;
		//	GoMarket ss = new GoMarket();
		//	Thread st = new Thread(ss);
		//	st.start();

}




void s1b0dh()
{
	hoveredButton = NULL;
	[PongViewController switchToState:PAUSED];
	//try {
	//	playSound(mpWall3);
	//} catch (IllegalStateException e) {
	//	e.printStackTrace();
	//} catch (IOException e) {
	//}
	playSound(mpWall3);
	
}




void homeButton()
{
	hoveredButton = NULL;
	[PongViewController switchToState:HOME];
	//try {
	//	playSound(mpWall3);
	//} catch (IllegalStateException e) {
	//	e.printStackTrace();
	//} catch (IOException e) {
	//}
	playSound(mpWall3);
}



void s2b0dh()
{
	hoveredButton = NULL;
	if(lastDownState == OPTIONS)
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
		gameType = 0;
		playSound(mpWall3);
	}
}


void s2b1dh()
{
	hoveredButton = NULL;
	if(lastDownState == OPTIONS)
	{
		sound = sound?false:true;
		[prefs setObject:sound?@"TRUE":@"FALSE" forKey:@"sound"];
		playSound(mpWall3);
	}
}

void s2b2dh()
{
	hoveredButton = NULL;
	if(lastDownState == OPTIONS)
	{
		vibrate = vibrate?false:true;
		[prefs setObject:vibrate?@"TRUE":@"FALSE" forKey:@"vibrate"];
		playSound(mpWall3);
	}
}

void s2b3dh()
{
	hoveredButton = NULL;
	if(lastDownState == OPTIONS)
	{
		difficulty++;
		if(difficulty == 3)
			difficulty = 0;
		[prefs setObject:[NSString stringWithFormat:@"%d",difficulty] forKey:@"difficulty"];
		gameReset();
		playSound(mpWall3);
	}
}


void s2b4dh()
{
	hoveredButton = NULL;
	if(lastDownState == OPTIONS)
	{
		fog = fog?false:true;
		[prefs setObject:fog?@"TRUE":@"FALSE" forKey:@"fog"];
		playSound(mpWall3);
	}
}


void s2b5dh()
{
	hoveredButton = NULL;
	if(lastDownState == OPTIONS)
	{
		inputMethod++;
		if(inputMethod > 1)
			inputMethod = 0;
		[prefs setObject:[NSString stringWithFormat:@"%d",inputMethod] forKey:@"inputMethod"];
		playSound(mpWall3);
	}
}


void s8b0dh()
{
	hoveredButton = NULL;
	if(lastDownState == RESULTS)
	{
		//submit score
		
	}
}


