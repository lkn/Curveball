//
//  FontTexture.h
//  Pong
//
//  Created by Barrett Anderson on 2/1/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FontTexture : NSObject {
	int * bigBuff;
	int * medBuff;
}
- (id)initFontTexture:(int)curChar;

-(int*)bigBuff;

-(int*)medBuff;
@end
