//
//  Button.h
//  Pong
//
//  Created by Barrett Anderson on 2/1/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Button : NSObject {
@public
	//(int)inx y:(int)iny text:(NSString)intext textSize:(int)intextSize gameType:(int)ingameType multiPlayer:(int)inmultiPlayer
	int x,y,width,height,textSize,textOffset,textYOffset,gameType,multiPlayer;
	BOOL highlighted,active;
	BOOL enabled;
	NSString * text;
	float lb[12];
	float cb[12];
	float rb[12];
//	void * handler;
	void (*handler)();// = NULL;
	//-int(*)()bar;
	id * info;// = NULL;
}
- (id)initButton:(int)inx y:(int)iny width:(int)inwidth height:(int)inheight text:(NSString*)intext textSize:(int)intextSize gameType:(int)ingameType multiPlayer:(int)inmultiPlayer;
- (void)makeBuffers;
-(void)draw;
-(void)changeText:(NSString *)newText;
-(BOOL)collides:(int)inx iny:(int)iny;

@end
