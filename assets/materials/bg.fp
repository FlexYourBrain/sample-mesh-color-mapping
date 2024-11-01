#version 140

uniform lowp sampler2D texture_sampler;
uniform fs_uniforms
{
    vec4 tint;
};

in vec2 var_texcoord0;
out lowp vec4 color;


void main()
{
    // Pre-multiply alpha since all runtime textures already are
    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    color = texture(texture_sampler, var_texcoord0.xy) * tint_pm;
}
