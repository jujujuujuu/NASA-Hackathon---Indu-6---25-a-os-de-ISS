shader_type spatial;

render_mode specular_schlick_ggx;

uniform sampler2D day_tex;
uniform sampler2D night_tex;
uniform sampler2D normal_tex;
uniform sampler2D roughness_tex;
uniform vec3 sun_dir;

uniform float emission_strength : hint_range(0.0, 20.0) = 5.0;
uniform float night_falloff : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    // Convert the normal from view space to world space
    vec3 N = normalize((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
    vec3 L = normalize(sun_dir);

    float light_factor = dot(N, L);

    // Use a smooth transition for twilight
    float night_factor = smoothstep(-night_falloff, night_falloff, -light_factor);

    ALBEDO = texture(day_tex, UV).rgb;
	NORMAL_MAP = texture(normal_tex, UV).rgb;
	NORMAL_MAP_DEPTH = 1.5;
	ROUGHNESS = texture(roughness_tex, UV).r;
    EMISSION = texture(night_tex, UV).rgb * night_factor * emission_strength;
}