shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float intensity: hint_range(0.0, 1, 0.01) = 1.0; // 整体强度
uniform float blur: hint_range(0.0, 5.0) = 3.0; // 模糊强度
uniform float diffusion = 0.4; // 暗角强度
uniform float zoom: hint_range(0.0, 1.0, 0.01) = 1.0; // 缩放强度

// 计算暗角
float vignette(vec2 uv){
	uv *= 1.0 - uv.xy; // 取反再相乘，获得中间大边缘小的过度
	float vignette = uv.x * uv.y * 16.0; // 转为浮点，然后归一化
	return pow(vignette, diffusion); // 强度控制
}

void fragment(){
	// 模糊/缩放
	vec4 pixel = texture(SCREEN_TEXTURE, (SCREEN_UV - 0.5) * mix(zoom, 1.0, intensity) + 0.5, mix(blur, 0.0, intensity)); // 获取屏幕颜色
	// 黑白
	vec3 grayscale_value = mix(vec3(dot(pixel.rgb, vec3(0.299, 0.587, 0.114))), pixel.rgb, intensity); // 计算灰度值（加权平均法）
	// 暗角
	float get_vignette = mix(vignette(UV), 1.0, intensity);
	//if (graph_switch) {
	COLOR.rgb = grayscale_value * get_vignette; // 综合应用
}