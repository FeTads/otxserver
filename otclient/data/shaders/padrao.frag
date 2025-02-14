attribute vec2 a_TexCoord;
attribute vec2 a_Vertex;
uniform mat3 u_TransformMatrix;
uniform mat3 u_ProjectionMatrix;
uniform mat3 u_TextureMatrix;
uniform vec2 u_Offset;
uniform vec2 u_Center;
varying vec2 v_TexCoord;
varying vec2 v_TexCoord2;
varying vec2 v_TexCoord3;
void main()
{
    vec2 vertex = a_Vertex;
    vec2 mainTexture = a_TexCoord;
    vec2 outlineTexture = a_TexCoord;
    vec2 delta = vec2(sign(u_Center - (vertex)));
    vertex -= delta * vec2(1.0, 1.0);
    mainTexture -= delta * vec2(1.0, 1.0);
    gl_Position = vec4((u_ProjectionMatrix * u_TransformMatrix * vec3(vertex.xy, 1.0)).xy, 1.0, 1.0);
    v_TexCoord = (u_TextureMatrix * vec3(mainTexture, 1.0)).xy;
    v_TexCoord2 = (u_TextureMatrix * vec3(mainTexture + u_Offset, 1.0)).xy;
    v_TexCoord3 = (u_TextureMatrix * vec3(outlineTexture, 1.0)).xy;
}