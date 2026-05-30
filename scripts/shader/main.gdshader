shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 1.0) = 0.50;
uniform float green_tint     : hint_range(0.0, 1.0) = 0.55;
uniform float fog_depth      : hint_range(0.0, 1.0) = 0.40;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}
float noise(vec2 p) {
    vec2 i = floor(p); vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1,0)), u.x),
               mix(hash(i + vec2(0,1)), hash(i + vec2(1,1)), u.x), u.y);
}

void fragment() {
    vec2 uv = UV;
    float t = (uv.x + (1.0 - uv.y)) * 0.5;

    // palette — teal-cyan cerah + hijau bioluminescent
    vec3 sky_teal    = vec3(0.12, 0.55, 0.65);
    vec3 mid_cyan    = vec3(0.08, 0.42, 0.52);
    vec3 deep_teal   = vec3(0.04, 0.22, 0.32);
    vec3 green_glow  = vec3(0.18, 0.58, 0.42);
    vec3 bright_teal = vec3(0.25, 0.72, 0.72);

    // base gradient diagonal
    float base_t = clamp(t * 0.85 + 0.1, 0.0, 1.0);
    vec3 color = mix(sky_teal, mid_cyan, base_t);
    color = mix(color, deep_teal, base_t * base_t * 0.6);

    // green tint merata (seperti referensi)
    float g_mask = smoothstep(0.0, 0.7, uv.y) * (0.3 + noise(uv * 3.0) * 0.2);
    color = mix(color, green_glow, g_mask * green_tint * 0.55);

    // soft fog/haze di tengah (bokeh effect)
    float fog_dist = length(uv - vec2(0.5, 0.45));
    float fog_blob = smoothstep(0.5, 0.1, fog_dist) * fog_depth;
    color = mix(color, bright_teal * 0.7 + vec3(0.1, 0.15, 0.2), fog_blob * 0.4);

    // glow spots bioluminescent
    vec2 g_uv = uv * vec2(6.0, 5.0);
    float g_noise = noise(g_uv) * noise(g_uv * 1.7 + vec2(2.3, 1.1));
    float glow_mask = smoothstep(0.62, 0.72, g_noise);
    color += bright_teal * glow_mask * glow_intensity * 0.8;

    // light rays dari atas
    float ray1 = pow(max(0.0, 1.0 - abs(uv.x - 0.35) * 8.0), 3.0);
    float ray2 = pow(max(0.0, 1.0 - abs(uv.x - 0.55) * 12.0), 3.0);
    float rays = (ray1 + ray2) * (1.0 - uv.y) * 0.18;
    color += vec3(0.3, 0.75, 0.8) * rays * glow_intensity;

    // vignette subtle
    float vig = smoothstep(0.0, 0.45, uv.x) * smoothstep(1.0, 0.55, uv.x)
              * smoothstep(0.0, 0.3, uv.y) * smoothstep(1.0, 0.7, uv.y);
    color *= 0.75 + 0.25 * vig;

    color = clamp(color * 1.08, 0.0, 1.0);
    color = pow(color, vec3(0.90));
    COLOR = vec4(color, 1.0);
}