shader_type canvas_item;

uniform float speed = 0.3;  // Speed of rain movement
uniform float intensity = 0.5;  // Transparency of drops
uniform sampler2D noise_texture; // Use a noise texture for variation

void fragment() {
    vec2 uv = UV;

    // Simulate rain falling by moving UV downward
    uv.y += TIME * speed;

    // Create a random raindrop pattern using a noise texture
    float rain_mask = texture(noise_texture, uv * 8.0).r;

    // Control rain intensity
    rain_mask = smoothstep(0.4, 0.6, rain_mask) * intensity;

    // Darken the background based on rain drops
    vec4 tex_color = texture(TEXTURE, UV);
    tex_color.rgb -= rain_mask * 0.5; // Darken the texture slightly

    COLOR = tex_color;
}
