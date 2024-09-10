shader_type canvas_item;

uniform float cutoff: hint_range(0.0, 2.0) = 0.5;
uniform float feather: hint_range(0.0, 1.0) = 0.1;

void fragment()
{
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);

	color.a = smoothstep(cutoff + feather, cutoff, UV.y * (1.0 + feather));
	COLOR = color;
}