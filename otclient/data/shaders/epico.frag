uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);

    // Cálculo do gradiente diagonal
    float gradient = v_TexCoord.x + v_TexCoord.y;

    // Modulação do alpha baseada no tempo e no gradiente para criar o movimento
    float alpha = 0.3 * sin(u_Time * 2.0 + gradient * 3.14) + 0.5;
    
    alpha = alpha * alpha * alpha * alpha * alpha * alpha;  // Ampliando a influência do alpha

    // Aplicar um brilho roxo com o alpha modulado
    vec4 purple_glow = vec4(alpha * vec3(3.0, 1.0, 9.0), 0.0); // Ajustado para roxo
    col += purple_glow;

    gl_FragColor = col;
}
