//
//  Button.m
//  Pong
//
//  Created by Barrett Anderson on 2/1/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import "Button.h"
#import "PongViewController.h"
//#import "PongViewController.m"
#import "TextureCoord.h"

@implementation Button



- (id)initButton:(int)inx y:(int)iny width:(int)inwidth height:(int)inheight text:(NSString*)intext textSize:(int)intextSize gameType:(int)ingameType multiPlayer:(int)inmultiPlayer
{
	handler = NULL;
	self->enabled = TRUE;
	self->x = inx;
	self->y = iny;
	self->text = intext;
	self->textSize = intextSize;
	self->width = inwidth;
	self->height = inheight;
	self->gameType = ingameType;
	self->multiPlayer = inmultiPlayer;
	self->textOffset = (width - textLength(text)*textSize/20)/2;
	self->textYOffset = (height - textSize*3/2)/2+textSize/15;
	[self makeBuffers];
	
	
	return self;	
}


- (void)makeBuffers
{
	//lb = GLGamePlay.makeIntBuffer(GLGamePlay.instance.fontBoxInt);
	//cb = GLGamePlay.makeIntBuffer(GLGamePlay.instance.fontBoxInt);
	//rb = GLGamePlay.makeIntBuffer(GLGamePlay.instance.fontBoxInt);
	
	lb[0] = x;
	lb[3] = x + PongViewController.fontSize*2/4;
	lb[6] = x;
	lb[9] = x + PongViewController.fontSize*2/4;
	
	cb[0] = x + PongViewController.fontSize*2/4;
	cb[3] = x + width - PongViewController.fontSize*2/4;
	cb[6] = x + PongViewController.fontSize*2/4;
	cb[9] = x + width - PongViewController.fontSize*2/4;
	
	rb[0] = x + width - PongViewController.fontSize*2/4;
	rb[3] = x + width;
	rb[6] = x + width - PongViewController.fontSize*2/4;
	rb[9] = x + width;
	
	lb[1] = y;
	lb[4] = y;
	lb[7] = y - height;
	lb[10] = y - height;
	
	cb[1] = y;
	cb[4] = y;
	cb[7] = y - height;
	cb[10] = y - height;
	
	rb[1] = y;
	rb[4] = y;
	rb[7] = y - height;
	rb[10] = y - height;
	
	lb[2] = 0;
	lb[5] = 0;
	lb[8] = 0;
	lb[11] = 0;
	cb[2] = 0;
	cb[5] = 0;
	cb[8] = 0;
	cb[11] = 0;
	rb[2] = 0;
	rb[5] = 0;
	rb[8] = 0;
	rb[11] = 0;
}


-(void)changeText:(NSString *)newText
{
	text = newText;
	textOffset = (width - textLength(text)*textSize/20)/2;
}


-(BOOL)collides:(int)inx iny:(int)iny
{
	//NSLog(@"%i %i %i %i",inx,iny,x,y);

	//NSLog(@"collides");
	if(!enabled)
		return FALSE;
	if((gameType == -1 || gameType == PongViewController.gameType) && (multiPlayer == -1 || multiPlayer == PongViewController.multiPlayerStatus))
	{
		if(inx >= x && iny <= y && inx <= x + width && iny >= y - height)
		{
			PongViewController.hoveredButton = self;
			PongViewController.buttonInfo = info;
			//NSLog(@"TOUCHED");
			return TRUE;
		}
	}
	if(PongViewController.hoveredButton == self)
		PongViewController.hoveredButton = NULL;
	return FALSE;
	
}



- (void)draw {
	if ((gameType == -1 ||
       gameType == PongViewController.gameType) &&
      (multiPlayer == -1 ||
       multiPlayer == PongViewController.multiPlayerStatus)) {
		TextureCoord ** button = PongViewController.button;
		if(PongViewController.hoveredButton == self)
			button = PongViewController.button2;
		if(!enabled)
			button = PongViewController.button3;
		glDisable(GL_CULL_FACE);
		glBindTexture(GL_TEXTURE_2D, PongViewController.tileset1);
		
		glTexCoordPointer(2, GL_FIXED, 0, button[0]->coordBuff);
		glVertexPointer(3, GL_FLOAT, 0, lb);
		glDrawArrays(GL_TRIANGLE_STRIP,0,4);
		

		glTexCoordPointer(2, GL_FIXED, 0, button[1]->coordBuff);
		glVertexPointer(3, GL_FLOAT, 0, cb);
		glDrawArrays(GL_TRIANGLE_STRIP,0,4);
		
		glTexCoordPointer(2, GL_FIXED, 0, button[2]->coordBuff);
		glVertexPointer(3, GL_FLOAT, 0, rb);
		glDrawArrays(GL_TRIANGLE_STRIP,0,4);
		
		//[PongViewController drawString:text x:x+textOffset y:y-textYOffset size:textSize];
		[PongViewController drawString:text x:x+textOffset y:y-textYOffset size:textSize];
		glBindTexture(GL_TEXTURE_2D, PongViewController.tileset1);
	}
}



@end
