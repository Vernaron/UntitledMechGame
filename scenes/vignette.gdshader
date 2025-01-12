shader_type canvas_item;
uniform float modifier;
void fragment() {
	COLOR.a=distance(vec2(0.5, 0.5), UV)*modifier;;
}
