uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);

    // Calculando o gradiente do centro para fora
    float midX = 0.5;  // Posição central X
    float midY = 0.5;  // Posição central Y
    float distance = sqrt(pow(v_TexCoord.x - midX, 2.0) + pow(v_TexCoord.y - midY, 2.0));
    float maxDistance = sqrt(2.0) * 0.5;  // Máximo possível de distância do centro às bordas
    float normalizedDistance = distance / maxDistance; // Normalizando a distância

    // Usar o módulo do tempo para alternar entre efeitos
    float modTime = mod(u_Time, 6.0); // Ciclo total de 6 segundos

    float alpha;
    vec3 color;

    if (modTime < 3.0) {  // Primeiros 3 segundos: brilho rosa de dentro para fora
        alpha = 0.5 * sin(modTime * 3.0 - normalizedDistance * 10.0) + 0.5;
        alpha = pow(alpha, 6.0);
        color = vec3(5.0, 0.2, 5.0); // Rosa
    } else {  // Segundos 3 segundos: brilho branco de fora para dentro
        alpha = 0.5 * sin((modTime - 3.0) * 3.0 + normalizedDistance * 10.0) + 0.5;
        alpha = pow(alpha, 6.0);
        color = vec3(5.0, 0.4, 5.0); // Rosa
    }

    // Aplicar o brilho com o alpha modulado
    vec4 glow = vec4(alpha * color, 0.0);
    col += glow;

    gl_FragColor = col;
}