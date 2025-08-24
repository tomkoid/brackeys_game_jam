shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform int levels = 3;
uniform float spread = 0.01;
uniform float fov_strength = 0.3; // 0.0 = no warp, 0.5+ = strong wide FOV

vec2 wide_fov(vec2 uv) {
    vec2 d = uv - 0.5;
    float r2 = dot(d, d);
    float factor = 1.0 + fov_strength * r2;
    return 0.5 + d * factor;
}

void fragment() {
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy / iResolution.xy;

    // First apply FOV warp
    vec2 warped_uv = wide_fov(uv);

    vec3 sum = vec3(0.0);
    vec3 final_col = vec3(0.0);

    vec2 offset = (warped_uv - vec2(0.5)) * vec2(1.0, -1.0);

    for (int i = 0; i < levels; i++) {
        float t = 2.0 * float(i) / float(levels - 1);
        vec3 slice = vec3(1.0 - t, 1.0 - abs(t - 1.0), t - 1.0);
        slice = max(slice, 0.0);
        sum += slice;

        // Chromatic offset in warped space
        vec2 slice_uv = warped_uv + (t - 1.0) * spread * offset;

        // Clamp UVs to avoid artifacts at screen edges
        slice_uv = clamp(slice_uv, vec2(0.0), vec2(1.0));

        final_col += slice * texture(screen_texture, slice_uv).rgb;
    }

    final_col /= sum;
    COLOR = vec4(final_col, 1.0);
}
