shader_type spatial;
render_mode vertex_lighting;


//Uncomment this to use the OUTLINE

#define USE_OUTLINE;

group_uniforms LIGHT;
uniform sampler2D light_ramp : hint_default_white,filter_nearest,repeat_disable;
uniform float normal_smoothness : hint_range(0.0, 1.0) = 0.1;

#if defined(USE_OUTLINE)
group_uniforms LIGHT.OUTLINE;
uniform vec3 outline_position = vec3(0.0,-0.25,-1.0);
uniform float normal_smoothness_outline : hint_range(0.0, 1.0) = 0.1;

//outline_edge_a and b are used to make the outline, thicker, thinner, smoother or harsher.
uniform float outline_edge_a = 0.5;
uniform float outline_edge_b = 0.5;
uniform vec4 outline_tone : source_color = vec4(0.0,0.0,0.0,1.0);
#endif

group_uniforms LIGHT.TEXTURES;
uniform vec2 light_uv_scale = vec2(1.0);

uniform sampler2D specular_texture : source_color, repeat_enable;
uniform sampler2D light_texture : source_color, repeat_enable;
uniform sampler2D shadow_texture : source_color ,repeat_enable;

group_uniforms LIGHT.TONES;
uniform vec3 highlight_tone : source_color = vec3(1.0);
uniform vec3 light_tone : source_color = vec3(0.75);
uniform vec3 shadow_tone : source_color = vec3(0.25);

float linearizeDepth(float _depth, float _near, float _far) {
	return (2.0 * _near * _far) / (_far + _near - (_depth * 2.0 - 1.0) * (_far - _near));
}

void light(){
	float depth = (linearizeDepth(FRAGCOORD.z,0.005,0.1) / 0.1);

	//So, normal smoothness is an interpolation from the current NORMAL position to the LIGHT position
	//so the light will be 100% visible no matter what.
	vec3 lightNormal = NORMAL;
	lightNormal.rgb = mix(lightNormal.rgb,LIGHT,normal_smoothness);

	//LNDotL stands for LightNormal Dot Light, is just so we know how much light that part is facing.
	float LNDotL = clamp(dot(lightNormal,LIGHT),0.0,1.0) * ATTENUATION;

	vec3 light_map = texture(light_ramp,vec2(LNDotL,1.0)).rgb;
	vec3 light = light_tone * textureLod(light_texture,UV * light_uv_scale,0.0).rgb;
	light = mix(light,shadow_tone * textureLod(shadow_texture,UV * light_uv_scale,0.0).rgb,dot(light_map,vec3(1.0,0.0,0.0)));

	#if defined(USE_OUTLINE)
		//WE store the Raw Normal, we unpack it, and we smooth it out based on a our factor
		vec3 outlineNormal = NORMAL;
		outlineNormal = outlineNormal * 2.0 - 1.0;
		outlineNormal.rgb = mix(outlineNormal.rgb,LIGHT,normal_smoothness_outline);
		//We make the same formula for the light intentsity, but using a custom position for a FakeLight to create a mask
		float outline_map = clamp(dot(outlineNormal,outline_position),0.0,1.0);
		outline_map = smoothstep(outline_edge_a,outline_edge_b,outline_map) * depth; //We use smoothstep so we can have thicker outlines, softer or harsher ones.
		vec3 outline = outline_tone.rgb;
		DIFFUSE_LIGHT += mix(light* LIGHT_COLOR,outline * LIGHT_COLOR,(outline_map * outline_tone.a) - light_map.b);
	#else
		DIFFUSE_LIGHT += light* LIGHT_COLOR;
	#endif
	SPECULAR_LIGHT += light_map.b * (textureLod(specular_texture,UV * light_uv_scale,0.0).rgb * highlight_tone);
}