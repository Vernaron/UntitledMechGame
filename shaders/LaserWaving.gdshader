shader_type canvas_item;
uniform float delta = 0;
void fragment() {
	COLOR = vec4(delta, delta, delta,1.0f);
}
