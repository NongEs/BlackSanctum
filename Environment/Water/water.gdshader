shader_type spatial;
render_mode unshaded, depth_draw_opaque;

uniform sampler2D normal_map : hint_normal;
uniform sampler2D foam_texture;
uniform vec3 shallow_color : source_color = vec3(0.1, 0.5, 0.8);
uniform vec3 deep_color : source_color = vec3(0.0, 0.2, 0.5);
uniform vec3 foam_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float water_scale = 5.0;
uniform float wave_speed = 1.0;
uniform float fresnel_intensity = 3.0;
uniform float foam_threshold = 0.4;

void fragment() {
    vec2 uv_time = UV * water_scale + vec2(TIME * wave_speed, TIME * wave_speed * 0.5);
    vec3 wave_normal = texture(normal_map, uv_time).rgb * 2.0 - 1.0;
    wave_normal = normalize(wave_normal);

    // ✅ Fixed Depth Calculation
    float raw_depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
    vec3 ndc_pos = vec3(SCREEN_UV * 2.0 - 1.0, raw_depth);
    vec4 view_pos = INV_PROJECTION_MATRIX * vec4(ndc_pos, 1.0);
    view_pos.xyz /= view_pos.w;
    float linear_depth = -view_pos.z;

    // Depth-based color blending
    float depth_factor = clamp(linear_depth * 0.1, 0.0, 1.0);
    vec3 water_color = mix(shallow_color, deep_color, depth_factor);

    // Foam effect
    float foam_mask = texture(foam_texture, UV * water_scale).r;
    float foam_intensity = smoothstep(foam_threshold, 1.0, depth_factor * foam_mask);

    ALBEDO = mix(foam_color, water_color, foam_intensity);
    ROUGHNESS = 0.02;
    SPECULAR = 1.0;
    NORMAL_MAP = wave_normal;
}
