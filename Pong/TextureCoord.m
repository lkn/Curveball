//
//  TextureCoord.m
//  Pong
//
//  Created by Barrett Anderson on 1/29/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import "TextureCoord.h"


@implementation TextureCoord



- (id)initTextureCoord:(int)inx y:(int)iny width:(int)inwidth height:(int)inheight totalX:(int)totalX totalY:(int)totalY
{
	self->x = inx;
	self->y = iny;
	self->width = inwidth;
	self->height = inheight;
	
	
	coordBuff[0] = 65536*x/totalX;
	coordBuff[1] = 65536*y/totalY;
	
	coordBuff[2] = 65536*(x+width)/totalX;
	coordBuff[3] = 65536*y/totalY;
	
	coordBuff[4] = 65536*x/totalX;
	coordBuff[5] = 65536*(y+height)/totalY;
	
	coordBuff[6] = 65536*(x+width)/totalX;
	coordBuff[7] = 65536*(y+height)/totalY;
	
	return self;
}









@end
