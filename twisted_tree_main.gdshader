shader_type spatial;

uniform float wind_strength : hint_range(0.0, 0.05) = 0.015; // Less movement
uniform float wind_speed : hint_range(0.1, 2.0) = 1.0;
uniform float wind_scale : hint_range(0.5, 5.0) = 2.0;
uniform sampler2D albedo_texture; // Keeps the original leaf texture

void vertex() {
    float time_factor = TIME * wind_speed;
    
    // Subtle wave effect, less movement
    float wave = sin(VERTEX.x * wind_scale + time_factor) * 0.03;
    wave += sin(VERTEX.z * wind_scale * 1.1 + time_factor * 0.9) * 0.02;
    
    // Apply only a slight vertical movement
    VERTEX.y += wave * wind_strength;
}

void fragment() {
    // Keep the original leaf texture
    vec4 tex_color = texture(albedo_texture, UV);
    ALBEDO = tex_color.rgb; 
}
