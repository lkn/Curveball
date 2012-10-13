//
//  Shader.vsh
//  Pong
//
//  Created by Barrett Anderson on 1/24/11.
//  Copyright 2011 CalcG.org. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
   // gl_Position.y += sin(translate) / 2.0;
  //  gl_Position.x += cos(translate) / 2.0;
    gl_Position.z += 3.0*cos(translate) / 2.0;

    colorVarying = color;
}
