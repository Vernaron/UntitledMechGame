shader_type canvas_item;

void vertex() {
	
}
bool isnearoutline(vec2 _UV, vec2 tex_pix_size, sampler2D _TEXTURE){
	if(texture(_TEXTURE, _UV)==vec4(0.0,0.0,0.0,0.0)){
		return true;
	}
	return false;
}
void fragment() {
	if (isnearoutline(UV, TEXTURE_PIXEL_SIZE, TEXTURE)){
		COLOR = vec4(0.0,0.0,0.0,1.0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
