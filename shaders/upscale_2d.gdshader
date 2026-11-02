shader_type canvas_item;

uniform float sharpness : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec2 px = TEXTURE_PIXEL_SIZE;
	vec4 center = texture(TEXTURE, UV);
	vec4 up = texture(TEXTURE, UV + vec2(0.0, -px.y));
	vec4 down = texture(TEXTURE, UV + vec2(0.0, px.y));
	vec4 left = texture(TEXTURE, UV + vec2(-px.x, 0.0));
	vec4 right = texture(TEXTURE, UV + vec2(px.x, 0.0));
	vec4 blur = (up + down + left + right) * 0.25;
	COLOR = vec4(clamp(center.rgb + (center.rgb - blur.rgb) * sharpness, vec3(0.0), vec3(1.0)), center.a);
}
