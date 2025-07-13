shader_type spatial;
render_mode blend_add,depth_draw_opaque,cull_disabled,
diffuse_toon,specular_disabled,unshaded,shadows_disabled,
ambient_light_disabled,fog_disabled;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;

uniform int particles_anim_h_frames;
uniform int particles_anim_v_frames;
//uniform bool particles_anim_loop;

void vertex() {
	float h_frames = float(particles_anim_h_frames);
	float v_frames = float(particles_anim_v_frames);
	float particle_total_frames = float(particles_anim_h_frames * particles_anim_v_frames);
	float particle_frame = floor(INSTANCE_CUSTOM.z * float(particle_total_frames));

	// We don't want to cycle so  the if is removed.
	particle_frame = clamp(particle_frame, 0.0, particle_total_frames - 1.0);
	//if (!particles_anim_loop) {
		//particle_frame = clamp(particle_frame, 0.0, particle_total_frames - 1.0);
	//} else {
		//particle_frame = mod(particle_frame, particle_total_frames);
	//}

	UV /= vec2(h_frames, v_frames);
	UV += vec2(mod(particle_frame, h_frames) / h_frames, floor((particle_frame + 0.5) / h_frames) / v_frames);
}


float fresnel(float amount, vec3 normal, vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}
// The inverse fresnel is used to fade away the sprite-like geometry when viewed from the front,
// this improves the look of it and whenever is looked from the sides it get's displayed at full
// opacity, control the amount for a stronger or weaker effect.
float inverse_fresnel(float amount, vec3 normal, vec3 view){
	return pow(clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0), amount);
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo,UV);
	ALBEDO = albedo_tex.rgb * COLOR.rgb * albedo_tex.a * 4.0;
	ALPHA = (albedo_tex.a * inverse_fresnel(1.5, NORMAL, VIEW) * COLOR.a); // Fade away when looking at front view the muzzleflare using a fresnel.
	ALPHA_SCISSOR_THRESHOLD = 0.001;
}
