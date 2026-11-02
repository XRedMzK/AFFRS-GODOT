shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform float stretch = 0.3;
uniform float compress = 1.2;

void fragment() {
	vec2 centered = (SCREEN_UV * 2.0) - 1.0;
	float cos_step = cos((abs(centered.x) * 0.5) * 3.141592653589);
	float mod_x = -(compress / 10.0);
	vec2 sample_uv = vec2(
		((centered.x / (1.0 + (mod_x * cos_step))) + 1.0) * 0.5,
		((centered.y / pow(stretch + 1.0, 1.0 - cos_step)) + 1.0) * 0.5
	);
	COLOR = texture(screen_texture, sample_uv);
}
