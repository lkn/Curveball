//
//  FontTexture.m
//  Pong
//
//  Created by Barrett Anderson on 2/1/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import "FontTexture.h"
#import "PongViewController.h"


@implementation FontTexture



- (id)initFontTexture:(int)curChar
{
	bigBuff = malloc(8*sizeof(int));
	medBuff = malloc(8*sizeof(int));
	int * fontStarts = PongViewController.fontStarts;
	int * medFontStarts = PongViewController.medFontStarts;
	int * fontSizes = PongViewController.fontSizes;
	
	bigBuff[0] = fontStarts[curChar]*65536/512 - (fontStarts[curChar]/512)*65536;
	bigBuff[2] = (fontStarts[curChar] + fontSizes[curChar])*65536/512 - (fontStarts[curChar]/512)*65536;
	bigBuff[4] = fontStarts[curChar]*65536/512 - (fontStarts[curChar]/512)*65536;
	bigBuff[6] = (fontStarts[curChar] + fontSizes[curChar])*65536/512 - (fontStarts[curChar]/512)*65536;
	
	bigBuff[1] = 32768/2*(fontStarts[curChar]/512);
	bigBuff[3] = 32768/2*(fontStarts[curChar]/512);
	bigBuff[5] = 32768/2+32768/2*(fontStarts[curChar]/512);
	bigBuff[7] = 32768/2+32768/2*(fontStarts[curChar]/512);
	
	
	medBuff[0] = medFontStarts[curChar]*65536/1024 - (medFontStarts[curChar]/1024)*65536;
	medBuff[2] = (medFontStarts[curChar] + fontSizes[curChar])*65536/1024 - (medFontStarts[curChar]/1024)*65536;
	medBuff[4] = medFontStarts[curChar]*65536/1024 - (medFontStarts[curChar]/1024)*65536;
	medBuff[6] = (medFontStarts[curChar] + fontSizes[curChar])*65536/1024 - (medFontStarts[curChar]/1024)*65536;
	
	medBuff[1] = 32768*(medFontStarts[curChar]/1024);
	medBuff[3] = 32768*(medFontStarts[curChar]/1024);
	medBuff[5] = 32768+32768*(medFontStarts[curChar]/1024);
	medBuff[7] = 32768+32768*(medFontStarts[curChar]/1024);
	
	
	
	//NSLog(@"drawing: %c %i %i %i %i %i",curChar,fontSizes[curChar],bigBuff[0],bigBuff[1],bigBuff[2],bigBuff[3]);
	

	
	
	return self;
}


-(int*)bigBuff
{
	return bigBuff;
}

-(int*)medBuff
{
	return medBuff;
}

@end
