shader_type particles;

uniform sampler2D curve;
uniform float yScale = 200.0;

void process() {
	vec2 normal = vec2(normalize(VELOCITY.xy).y, -normalize(VELOCITY.xy).x);
	float curveSample1 = texture(curve, vec2(CUSTOM.y)).r;
	float curveSample2 = texture(curve, vec2(CUSTOM.y + DELTA / LIFETIME)).r;
	TRANSFORM[3].xy -= normal * (curveSample1 - curveSample2) * yScale;
}
