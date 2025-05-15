shader_type canvas_item;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV*2.0);
	COLOR = pixelColor;
}
