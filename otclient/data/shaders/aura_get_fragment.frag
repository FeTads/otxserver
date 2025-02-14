uniform mat4 u_Color;
varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_TexCoord3;
uniform sampler2D u_Tex0;
const float ALPHA_TOLERANCE = 0.1;
uniform float u_Time; // Variável de tempo para controlar o efeito de pulsação

void main()
{
    gl_FragColor = texture2D(u_Tex0, v_TexCoord);
    vec4 texcolor = texture2D(u_Tex0, v_TexCoord2);
    vec4 texcolor3 = texture2D(u_Tex0, v_TexCoord3);
    
    // Efeito de pulsação utilizando seno e a variável de tempo
    float pulse = abs(sin(u_Time));

    if(texcolor.r > 0.9) {
        gl_FragColor *= texcolor.g > 0.9 ? u_Color[0] : u_Color[1];
    } else if(texcolor.g > 0.9) {
        gl_FragColor *= u_Color[2];
    } else if(texcolor.b > 0.9) {
        gl_FragColor *= u_Color[3];
    }
    if (texcolor3.a > ALPHA_TOLERANCE && gl_FragColor.a < ALPHA_TOLERANCE) {
        // Aplique a cor de pulsação à cor final do fragmento.
        gl_FragColor = vec4(1.0, 0.0, 0.0, pulse); // Cor vermelha com transparência variável
    }
    if(gl_FragColor.a < 0.01) discard;
}