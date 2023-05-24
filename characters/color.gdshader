shader_type canvas_item;

uniform vec4 main_color : source_color;

void fragment() {
	vec4 color = COLOR;
	color.rgb = main_color.rgb;
	COLOR = color;
}
