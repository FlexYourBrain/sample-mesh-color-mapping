#version 140

in vec4 var_position;
in vec3 var_normal;
in vec4 var_light;
in vec4 var_color; // we declare the varying color attribute we sent from the vertex program.

uniform fs_uniforms
{
    vec4 tint;
};

out vec4 color_out;

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 meshcolor = var_color * tint_pm; // Now we set the varying color with tint incase we want to use tinting.

    // Diffuse light calculations
    vec3 ambient_light = vec3(0.2);
    vec3 diff_light = vec3(normalize(var_light.xyz - var_position.xyz));
    diff_light = max(dot(var_normal,diff_light), 0.0) + ambient_light;
    diff_light = clamp(diff_light, 0.0, 1.0);

    color_out = vec4(meshcolor.rgb*diff_light,1.0); // for this sample we display the vertex colors by mixing the varying color attribute with diffuse lighting.
}

