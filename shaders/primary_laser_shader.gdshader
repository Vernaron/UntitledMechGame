shader_type canvas_item;
group_uniforms Container_Values;
render_mode unshaded;
uniform vec2 size_px = vec2(50.0, 50.0);
group_uniforms;

group_uniforms Beam_1;
uniform vec4 rgb_1 :source_color = vec4(1.0,1.0,1.0,1.0);
group_uniforms;
group_uniforms Beam_1.Transforms;
uniform vec2 size_1 = vec2(100, 0.1);
uniform float scale_1 = 1.0;
uniform float offset_1 = 0;
uniform float speed_1 = 6.0;
group_uniforms;

group_uniforms Beam_2;
uniform vec4 rgb_2 :source_color= vec4(1.0, 1.0, 1.0, 1.0);
group_uniforms;
group_uniforms Beam_2.Transforms;
uniform vec2 size_2 = vec2(100, 0.1);
uniform float scale_2 = 1.0;
uniform float offset_2 = .2;
uniform float speed_2 =  7.0;
group_uniforms;


group_uniforms Beam_3;
uniform vec4 rgb_3 :source_color= vec4(1.0, 1.0, 1.0, 1.0);
group_uniforms;
group_uniforms Beam_3.Transforms;
uniform vec2 size_3 = vec2(100, 0.1);
uniform float scale_3 = 1.0;
uniform float offset_3 = .2;
uniform float speed_3= 8.0;
group_uniforms;



vec4 add_vecs(vec4 v1, vec4 v2){
	return vec4(v1.r+v2.r,v1.g+v2.g,v1.b+v2.b,v1.a+v2.a);
}
vec4 get_color(vec2 _UV, vec2 offset){
	vec2 UV_off = _UV+offset;
	float UV_x = UV_off.x * size_px.x;
	if(size_3.y*0.5*(1.0+scale_3*sin(PI*(offset_3+1.0+(UV_x+TIME*speed_3)/size_3.x)))<(UV_off.y)&& //left(0)
		1.0-size_3.y*0.5*(1.0+scale_3*sin(PI*(offset_3+(UV_x+TIME*speed_3)/size_3.x)))>(UV_off.y) //right(1)
	){
		 return vec4(rgb_3.r,rgb_3.g,rgb_3.b, rgb_3.a);
	}
	if(size_2.y*0.5*(1.0+scale_2*sin(PI*(offset_2+1.0+(UV_x+TIME*speed_2)/size_2.x)))<(UV_off.y)&& //left(0)
		1.0-size_2.y*0.5*(1.0+scale_2*sin(PI*(offset_2+(UV_x+TIME*speed_2)/size_2.x )))>(UV_off.y) //right(1)
	){
		 return vec4(rgb_2.r,rgb_2.g,rgb_2.b, rgb_2.a);
	}
	if(size_1.y*0.5*(1.0+scale_1*sin(PI*(offset_1+1.0+(UV_x+TIME*speed_1)/size_1.x)))<(UV_off.y)&& //left(0)
			1.0-size_1.y*0.5*(1.0+scale_1*sin(PI*(offset_1+(UV_x+TIME*speed_1)/size_1.x)))>(UV_off.y) //right(1)
		){
			return vec4(rgb_1.r,rgb_1.g,rgb_1.b,1);
		}

	return vec4(rgb_1.r,rgb_1.g,rgb_1.b,0);
	}
void fragment() {
	float pixel_size = 2.0/size_px.y;
	vec4 left=get_color(UV, vec2(0,-pixel_size));
	vec4 right=get_color(UV, vec2(0,pixel_size));
	vec4 up=get_color(UV, vec2(pixel_size,0));
	vec4 down=get_color(UV, vec2(-pixel_size,0));
	vec4 left2=get_color(UV, vec2(pixel_size,-pixel_size));
	vec4 right2=get_color(UV, vec2(pixel_size,pixel_size));
	vec4 up2=get_color(UV, vec2(pixel_size,-pixel_size));
	vec4 down2=get_color(UV, vec2(-pixel_size,pixel_size));
	vec4 thisone = get_color(UV, vec2(0,0));
	vec4 average =add_vecs(add_vecs(add_vecs(left,right),add_vecs(up,down)),add_vecs(add_vecs(left2,right2),add_vecs(up2,down2)))/8.0;
	COLOR = add_vecs(average, add_vecs(thisone, thisone))/3.0;
}