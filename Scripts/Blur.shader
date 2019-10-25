shader_type canvas_item;

uniform float lod: hint_range(0, 3);

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, lod);
}