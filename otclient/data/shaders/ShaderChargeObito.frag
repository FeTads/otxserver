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
            color += texture2D(u_Tex0, uv + vec2(x, y) * blurSize) / 9.0;
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
    // Cálculo do gradiente diagonal para a distorção
    float gradient = v_TexCoord.x + v_TexCoord.y;
    // Modulação da distorção baseada no tempo e no gradiente
    float wave = sin(u_Time * 2.0 + gradient * 20.00);
    // Aplicação da distorção nas coordenadas de textura
    vec2 distortedCoord = v_TexCoord + 0.01 * vec2(sin(wave * 10.0), cos(wave * 10.0));

    vec4 texcolor = texture2D(u_Tex0, distortedCoord);

    if (isOuterEdge(v_TexCoord)) {
        float baseAlpha = 0.3;
        vec4 baseColor = vec4(0.5, 0.0, 0.5, baseAlpha); // Cor roxa

        gl_FragColor = baseColor; // Aplicar apenas a cor do contorno
    } else {
        gl_FragColor = texcolor;
    }

    if (gl_FragColor.a < 0.01) discard; // Descarta pixels totalmente transparentes
}