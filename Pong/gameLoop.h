


int compareScoreLines (const void * a, const void * b)
{
	//NSLog(@"compare");
	NSString ** aString = (NSString**)a;
	NSString ** bString = (NSString**)b;
	//NSLog(@"hi");
	//NSLog(@"%@ %@",*aString,*bString);
	NSArray *scoreAArray = [*aString componentsSeparatedByString: @" "];
	NSArray *scoreBArray = [*bString componentsSeparatedByString: @" "];
	
	int av = [[scoreAArray objectAtIndex:1] intValue];
	int bv = [[scoreBArray objectAtIndex:1] intValue];
	//NSLog(@"%d %d",av,bv);
	return bv-av;
}


- (void)gameLoop:(id)input
{
	//NSAutoReleasePool
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	//NSAutoReleasePool * pool = [[NSAutoReleasePool alloc] init];
	NSDate *date = [NSDate date];
	
	//NSLog(@"yooooosef");
	long long delta;
	long long time = [date timeIntervalSince1970] * 1000.0;
	//NSLog(@"asdf %lld",time);
	int spinCounter = 0;
	
	
	srand ( time);
	
	
	
	while(running)
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
				if(gameType == 1)
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
		
		@synchronized(sem)
		{
			
			//NSLog(@"loop %d %d",stateToInt(state),spinCounter);
			spinCounter++;
			if(spinCounter == 16)
				spinCounter = 0;
				
				//System.out.println(this);
				//int[] mxs = mxs;
				//int[] mys = mys;
	
				//		Vibrator vibrator = vibrator;
				
				//IntBuffer cubeBuffInt = cubeBuffInt;
				
				
				if(gameType == 0)
				{
					if(state == PLAYING)
					{
						
						//System.arraycopy(mxs,0,mxs,1,4);
						//System.arraycopy(mys,0,mys,1,4);
						memmove(mxs+1,mxs,4*sizeof(int));
						memmove(mys+1,mys,4*sizeof(int));
						mxs[0] = pX;
						mys[0] = pY;
						
						if(isCurveball)
						{
							bXSpeed += xAccel;
							bYSpeed += yAccel;
							
							int vecLength = (int) sqrt(bXSpeed*bXSpeed+bYSpeed*bYSpeed+bZSpeed*bZSpeed);
							
							if(vecLength != 0)
							{
								bX += abs(bZSpeed)*bXSpeed/vecLength;
								bY += abs(bZSpeed)*bYSpeed/vecLength;
								bZ += abs(bZSpeed)*bZSpeed/vecLength;
							}
						}
						else
						{
							bX += bXSpeed;
							bY += bYSpeed;
							bZ += bZSpeed;
							//System.out.println(bZSpeed);
						}
						if(bX > hFloatWidth-ballRadius)
						{
							bX=(hFloatWidth-ballRadius);
							bXSpeed *= -1;
							numWall3ToPlay++;
						}
						if(bX<-hFloatWidth+ballRadius)
						{
							bX=(-hFloatWidth+ballRadius);
							bXSpeed *= -1;
							numWall3ToPlay++;
						}
						if(bY>hFloatHeight-ballRadius)
						{
							bY=(hFloatHeight-ballRadius);
							bYSpeed *= -1;
							numWall2ToPlay++;
						}
						if(bY<-hFloatHeight+ballRadius)
						{
							bY=(-hFloatHeight+ballRadius);
							bYSpeed *= -1;
							numWall2ToPlay++;
						}
						if(bZ > 0-ballRadius)
						{
							tellOpponent=true;
							if(bX >= pX-hPaddleWidth-ballRadius && bX <= pX+hPaddleWidth+ballRadius &&
							   bY >= pY-hPaddleHeight-ballRadius && bY <= pY+hPaddleHeight+ballRadius)
							{
								bZ = 0-ballRadius;
								bZSpeed = (int)(bZSpeed * -1.05);
								if(bZSpeed > 30000)
									bZSpeed = 30000;
									if(bZSpeed < -30000)
										bZSpeed = -30000;
										
										if(isCurveball)
										{
											bXSpeed /= 2;
											bYSpeed /= 2;
										}
								
								numPingToPlay++;
								
								if(multiPlayerStatus == 0)
									myScore += level + 1 + difficulty;
									
									//		if(vibrator != null && Pong.vibrate)
									//			vibrator.vibrate(50);
									
									if(mxs[4] != 0 || mys[4] != 0)
									{
										if(isCurveball)
										{
											xAccel = -(mxs[0]-mxs[4])*multiplier/divisor/100;
											yAccel = -(mys[0]-mys[4])*multiplier/divisor/100;
										}
										else
										{
											bXSpeed += (mxs[0]-mxs[4])*multiplier/divisor/10;
											bYSpeed += (mys[0]-mys[4])*multiplier/divisor/10;
										}
									}
									else if(isCurveball)
									{
										xAccel = 0;
										yAccel = 0;
									}
							}
							else
							{
								//switchToState(START);
								[PongViewController switchToState:START];
								lastOutcome = 1;
								lives--;
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
								
								
								if(multiPlayerStatus != 0)
								{
									enScore++;
									iLost = true;
									//switchToState(PLAYING);
									[PongViewController switchToState:PLAYING];
									bZ = -depth+ballRadius;
									bZSpeed = 0;
								}
								else if(lives <= 0)
								{

									
									NSDateFormatter *date_formatter=[[NSDateFormatter alloc]init];
									[date_formatter setDateFormat:@"dd-MMM-yyyy"];
									NSString* date = [date_formatter stringFromDate:[NSDate date]];
									
									
									NSString * scoreLine = [NSString stringWithFormat:@"%s %d",[date UTF8String],myScore];
									[scoreLine retain];
									[date_formatter release];
									
				
									NSString * scoreLines[15];
									scoreLines[0] = scoreLine;
									NSString * prevScoresString = [PongViewController stringFromPrefs:[NSString stringWithFormat:@"scores%d",difficulty] def:@""];
									NSArray *prevScores = [prevScoresString componentsSeparatedByString: @"\n"];
									int total = 1;
									for(int i=0;i<[prevScores count];i++)
									{
										NSString * thisLine = [prevScores objectAtIndex:i];
										if(thisLine == NULL || [thisLine isEqualToString:@""])
											continue;
										scoreLines[i+1] = thisLine;
										total++;
										
									}
									qsort(scoreLines, total, sizeof(NSString*), compareScoreLines);

									
									NSString * scoresToSave = @"";
									for(int i=0;i<7 && i < total;i++)
									{
										scoresToSave = [scoresToSave stringByAppendingFormat:@"%@\n",scoreLines[i]];
									}
									
									[scoresToSave retain];
									
									[prefs setObject:scoresToSave forKey:[NSString stringWithFormat:@"scores%d",difficulty]];
									

									[PongViewController switchToState:RESULTS];
									
									//	Pong.highScores = "Loading";
									//	Pong.finishTime = System.currentTimeMillis();
									
									//	GetScores gs = new GetScores(gp);
									//	Thread gt = new Thread(gs);
									//	gt.start();
									
									
								}
							}
							//			whatToTellOpponent=",b "+bX+" "+bY+" "+bZ+" "+bXSpeed+" "+bYSpeed+" "+bZSpeed+" "+xAccel+" "+yAccel+(iLost?",l":"");
						}
						if(bZ<-depth+ballRadius)
						{
							
							if(multiPlayerStatus == 0)
							{
								if(bX >= eX-hPaddleWidth-ballRadius && bX <= eX+hPaddleWidth+ballRadius &&
								   bY >= eY-hPaddleHeight-ballRadius && bY <= eY+hPaddleHeight+ballRadius)
								{
									bZ = -depth + ballRadius;
									bZSpeed = (int)(bZSpeed * -1.05);
									if(bZSpeed > 30000)
										bZSpeed = 30000;
										if(bZSpeed < -30000)
											bZSpeed = -30000;
											
											if(isCurveball)
											{
												bXSpeed /= 2;
												bYSpeed /= 2;
												//xAccel = randomizer.nextInt()%(randEnemy/2);
												//yAccel = randomizer.nextInt()%(randEnemy/2);
												
												
												xAccel = rand() % randEnemy - randEnemy/2;
												yAccel = rand() % randEnemy - randEnemy/2;
												
												
											}
											else
											{
												//bXSpeed += randomizer.nextInt()%randEnemy;//-randEnemy*2;
												//bYSpeed += randomizer.nextInt()%randEnemy;//-randEnemy*2;
												
												
												bXSpeed += rand() % randEnemy*2 - randEnemy;
												bYSpeed += rand() % randEnemy*2 - randEnemy;
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
									myScore += (level + 1 + difficulty)*20;
									level++;
									gameReset();
									numWonToPlay++;
								}
							}
							else
							{
								if(bZSpeed < 0)
								{
									bXSpeed = 0;
									bYSpeed = 0;
									bZSpeed = 0;
									bZ = -depth+ballRadius;
									waitingForOp = true;
								}
							}
						}
						
						
						if(multiPlayerStatus == 0)
						{
							if(eX<bX)
							{
								if(bX-eX<=eSpeed/(isCurveball?2:1))
									eX=bX;
									else
										eX+=eSpeed/(isCurveball?2:1);
										}
							else
							{
								if(eX-bX<=eSpeed/(isCurveball?2:1))
									eX=bX;
									else
										eX-=eSpeed/(isCurveball?2:1);
										}
							if(eY<bY)
							{
								if(bY-eY<=eSpeed/(isCurveball?2:1))
									eY=bY;
									else
										eY+=eSpeed/(isCurveball?2:1);
										}
							else
							{
								if(eY-bY<=eSpeed/(isCurveball?2:1))
									eY=bY;
									else
										eY-=eSpeed/(isCurveball?2:1);
										}
							
							if(eX<-hFloatWidth+hPaddleWidth)
								eX=(-hFloatWidth+hPaddleWidth);
								if(eY<-hFloatHeight+hPaddleHeight)
									eY=(-hFloatHeight+hPaddleHeight);
									if(eX>hFloatWidth-hPaddleWidth)
										eX=(hFloatWidth-hPaddleWidth);
										if(eY>hFloatHeight-hPaddleHeight)
											eY=(hFloatHeight-hPaddleHeight);
											}
					}
					
					
					
					
					
					
				}
			
			
			
			
		}
		
		
		
		
		
		
		
		
		
		if(numPingToPlay != 0)
		{
			playSound(mpPing);
			
		}
		if(numPongToPlay != 0)
		{
			playSound(mpPong);
			
		}
		if(numWall1ToPlay != 0)
		{
			playSound(mpWall1);
			
		}
		if(numWall2ToPlay != 0)
		{
			playSound(mpWall2);
			
		}
		if(numWall3ToPlay != 0)
		{
			playSound(mpWall3);
			
		}
		if(numTargetToPlay != 0)
		{
			playSound(mpTarget);
			
		}
		if(numTargetbounceToPlay != 0)
		{
			playSound(mpTargetbounce);
			
		}
		if(numLostToPlay != 0)
		{
			playSound(mpLost);
			
		}
		if(numWonToPlay != 0)
		{
			playSound(mpWon);
			
		}
		if(numLostshortToPlay != 0)
		{
			playSound(mpLostshort);
			
		}
		if(numBullseyeToPlay != 0)
		{
			
			playSound(mpBullseye);
			
		}
		
		
		
		
		
		
		
		
	}
	
	
	
	
	
	[pool release];
	
}
