shader_type canvas_item;

void fragment() {
    vec2 uv = UV;

    // pusat layar
    vec2 center = vec2(0.5, 0.5);

    // jarak dari tengah
    float dist = distance(uv, center);

    // bentuk vignette (semakin besar angka, semakin halus)
    float vignette = smoothstep(0.8, 0.3, dist);

    // intensitas gelap
    float strength = 0.6;

    vec3 color = vec3(0.0);

    COLOR = vec4(color, (1.0 - vignette) * strength);
}