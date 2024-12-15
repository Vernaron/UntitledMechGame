shader_type canvas_item;
uniform float negOffset = 0.0;
uniform vec2 leftTopPoint = vec2(0,0);
uniform vec2 rightTopPoint = vec2(1,0);
uniform vec2 bottomPoint = vec2(.5,1);
float circpiece(vec2 _UV){
	
	if(.1+_UV.x > _UV.y/1.8&&-1.1+_UV.x < -_UV.y/1.8&&length(_UV - vec2(0.5, 1.0))<=1.0){
		return _UV.y/1.5;
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
	COLOR.a = UV.x*acos(dot(leftTopPoint, bottomPoint)) > UV.y? 1.0:0.0;
	//COLOR.a = averageOp/9.0;
}
