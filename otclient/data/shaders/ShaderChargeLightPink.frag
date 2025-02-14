uniform mat4 u_Color;
uniform sampler2D u_Tex0;
uniform float u_Time;
varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_TexCoord3;

const float ALPHA_TOLERANCE = 0.1;
const float baseBlurSizeOuter = 3.8 / 410.0;

vec4 blurTexture(vec2 uv, float blurSize) {
    vec4 color = vec4(0.0);
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            color += texture2D(u_Tex0, uv + vec2(float(x), float(y)) * blurSize) / 9.0;
        }
    }
    return color;
}

bool isOuterEdge(vec2 uv) {
    float pulsatingSize = baseBlurSizeOuter + 0.000 * sin(u_Time * 7.0);
    vec4 originalColor = texture2D(u_Tex0, uv);
    vec4 blurredColor = blurTexture(uv, pulsatingSize);
    vec4 edgeColor = abs(originalColor - blurredColor);
    return originalColor.a < 0.9 && edgeColor.a > 0.01;
}

void main() {
    vec4 texcolor = texture2D(u_Tex0, v_TexCoord2);
    vec4 texcolor3 = texture2D(u_Tex0, v_TexCoord3);

    if (isOuterEdge(v_TexCoord)) {
        float phase = mod(u_Time, 10.0);  // 2-second cycle
        float wave = sin(phase * 23.14159 + v_TexCoord.x * 50.0); // Wave across x-coordinate
        float waveIntensity = smoothstep(0.0, 0.0, wave);  // Smooth transition of wave

        float baseAlpha = 0.3;  // Base alpha for blue aura
        vec4 baseColor = vec4(1.0, 0.0, 0.0, baseAlpha); // Darker red color
        vec4 waveColor = vec4(1.0, 1.0, 1.0, waveIntensity * 2.0);  // White wave

        gl_FragColor = baseColor + waveColor * (1.0 - baseColor.a); // Blend wave over base color
    } else {
        gl_FragColor = texture2D(u_Tex0, v_TexCoord);
        if (texcolor.r > 0.9) {
            gl_FragColor *= texcolor.g > 0.9 ? u_Color[0] : u_Color[1];
        } else if (texcolor.g > 0.9) {
            gl_FragColor *= u_Color[2];
        } else if (texcolor.b > 0.9) {
            gl_FragColor *= u_Color[3];
        }
        if (texcolor3.a > ALPHA_TOLERANCE && gl_FragColor.a < ALPHA_TOLERANCE) {
            gl_FragColor = vec4(0.0, 0.7, 1.0, 1.0);
            gl_FragColor.a = 0.7;
        }
        if(gl_FragColor.a < 0.01) discard;
    }
}
