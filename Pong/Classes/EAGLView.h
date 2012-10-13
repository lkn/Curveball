//
//  EAGLView.h
//  Pong
//
//  Created by Barrett Anderson on 1/24/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "TextureCoord.h"

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
@interface EAGLView : UIView
{
@public
	
@private
	
    EAGLContext *context;
    
    // The pixel dimensions of the CAEAGLLayer.
    GLint framebufferWidth;
    GLint framebufferHeight;
    
    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view.
    GLuint defaultFramebuffer, colorRenderbuffer;
}
//- (GLuint)LoadTexture:(NSString*)filename;
@property (nonatomic, retain) EAGLContext *context;

- (void)setFramebuffer;
- (BOOL)presentFramebuffer;



@property (nonatomic, retain) IBOutlet UIImageView *firstPieceView;
@property (nonatomic, retain) IBOutlet UIImageView *secondPieceView;
@property (nonatomic, retain) IBOutlet UIImageView *thirdPieceView;
@property (nonatomic, retain) IBOutlet UILabel *touchPhaseText;
@property (nonatomic, retain) IBOutlet UILabel *touchInfoText;
@property (nonatomic, retain) IBOutlet UILabel *touchTrackingText;
@property (nonatomic, retain) IBOutlet UILabel *touchInstructionsText;


@end
