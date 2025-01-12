shader_type canvas_item;
//render_mode blend_add;
uniform vec2 leftTopPoint = vec2(0.0,0.0);
uniform vec2 rightTopPoint = vec2(1.0,0.0);
uniform vec2 bottomPoint = vec2(0.5,1.0);
uniform float innerRadius = 0;
uniform float intensity = 1.0;
uniform vec3 color : source_color;
float slope(vec2 v1, vec2 v2){
	return (v1.y-v2.y)/(v1.x-v2.x);
}
float circpiece(vec2 _UV){
	;
	if(_UV.x*slope(leftTopPoint, bottomPoint)+leftTopPoint.y > _UV.y&&
	2.0*bottomPoint.y+_UV.x*slope(rightTopPoint, bottomPoint)-rightTopPoint.y > _UV.y&&
	length(_UV - bottomPoint) <=length(leftTopPoint-bottomPoint)
	){

		return length(_UV - bottomPoint) >=length(bottomPoint-vec2(bottomPoint.x, bottomPoint.y-innerRadius)) ?
			 pow(_UV.y, 2)*(intensity*(.1+sin(_UV.x*PI)))/(bottomPoint.y-innerRadius):
				0.0;
	}
	else{
	 	return 0.0;
	}
}
void fragment() {
	float averageOp = 0.0;
	float offsetsize = .005;
	for(float xoff=offsetsize;xoff>=-offsetsize; xoff-=offsetsize ){
		for(float yoff=offsetsize;yoff>=-offsetsize; yoff-=offsetsize ){
			averageOp += circpiece(UV + vec2(xoff, yoff));
		}
	}
	COLOR = vec4(color.x, color.y, color.z, averageOp/9.0);
}
