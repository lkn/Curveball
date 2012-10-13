//
//  TextureCoord.h
//  Pong
//
//  Created by Barrett Anderson on 1/29/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextureCoord : NSObject {
	@public
		int x;
		int y;
		int width;
		int height;
		int coordBuff[8];
}
- (id)initTextureCoord:(int)inx y:(int)iny width:(int)inwidth height:(int)inheight totalX:(int)totalX totalY:(int)totalY;
@end
