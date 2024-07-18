shader_type canvas_item;

uniform bool enableBounce = false;
uniform float speed: hint_range(0.0, 25.0, 0.5) = 5.0;
uniform float height: hint_range(0.0, 1.0, 0.02) = 0.26;
uniform vec2 size = vec2(0.0, 0.0);
uniform bool multiColour = false;
uniform float fadeOut: hint_range(0.0, 2.0) = 1.0;

void vertex() {
	float offsetx;
	float offsety;
	
	if (size.x > 0.0) {
		offsetx = size.x;
	} else {
		offsetx = (1.0 / TEXTURE_PIXEL_SIZE.x) / 2.0;
	}
	
	if (size.y > 0.0) {
		offsety = size.y;
	} else {
		offsety = (1.0 / TEXTURE_PIXEL_SIZE.y) / 2.0;
	}
	
	if (enableBounce) {
		VERTEX += vec2(abs(sin(TIME * speed)) * (VERTEX.x - offsetx), 
					   abs(sin(TIME * speed)) * (VERTEX.y - offsety)
				) * height;
	}
}

void fragment(){
	if (multiColour) {
		if (COLOR.b > 0.0) {
			COLOR.b -= sin(TIME * 2.0);
			COLOR.g -= cos(TIME * 3.0);
			COLOR.r += cos(TIME * 2.5);
		}
	}
	
	if(COLOR.a > 0.0) {
		COLOR.a -= 1.0 - clamp(fadeOut, 0.0, 1.0);
	}
}