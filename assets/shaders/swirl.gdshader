shader_type canvas_item;

// ─── Colour Controls ───────────────────────────────────────────────────────
uniform vec4 color_a : source_color = vec4(0.9, 0.05, 0.0, 1.0);   // Red (fire side)
uniform vec4 color_b : source_color = vec4(0.0, 0.15, 0.95, 1.0);  // Blue (cool side)
uniform vec4 color_mid : source_color = vec4(0.05, 0.0, 0.12, 1.0); // Deep dark centre blend

// ─── Motion Controls ───────────────────────────────────────────────────────
uniform float speed : hint_range(0.0, 3.0) = 0.4;          // Overall animation speed
uniform float swirl_strength : hint_range(0.0, 8.0) = 3.5; // How much the domain warps
uniform float wave_scale : hint_range(0.5, 6.0) = 2.2;     // Scale of the noise pattern

// ─── Shape Controls ────────────────────────────────────────────────────────
uniform float split_sharpness : hint_range(1.0, 20.0) = 6.0; // Sharpness of red/blue boundary
uniform float highlight_strength : hint_range(0.0, 1.0) = 0.35; // Bright edge/sheen intensity
uniform float dark_core : hint_range(0.0, 1.0) = 0.55;       // How dark the swirl centres get

// ────────────────────────────────────────────────────────────────────────────
// Utility: 2D hash → pseudo-random vec2
// ────────────────────────────────────────────────────────────────────────────
vec2 hash2(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)),
	         dot(p, vec2(269.5, 183.3)));
	return fract(sin(p) * 43758.5453123) * 2.0 - 1.0;
}

// ────────────────────────────────────────────────────────────────────────────
// Gradient noise (smooth, derivative-ready — good base for domain warping)
// ────────────────────────────────────────────────────────────────────────────
float gnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f); // smoothstep

	float a = dot(hash2(i),               f);
	float b = dot(hash2(i + vec2(1,0)),   f - vec2(1,0));
	float c = dot(hash2(i + vec2(0,1)),   f - vec2(0,1));
	float d = dot(hash2(i + vec2(1,1)),   f - vec2(1,1));

	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// ────────────────────────────────────────────────────────────────────────────
// Fractional Brownian Motion — layered noise for organic complexity
// ────────────────────────────────────────────────────────────────────────────
float fbm(vec2 p) {
	float v = 0.0;
	float amp = 0.5;
	float freq = 1.0;
	// 5 octaves gives a nice balance of large sweeps + fine detail
	for (int i = 0; i < 5; i++) {
		v += amp * gnoise(p * freq);
		freq *= 2.1;
		amp  *= 0.48;
	}
	return v;
}

// ────────────────────────────────────────────────────────────────────────────
// Domain-warped FBM — the secret sauce for fluid/lava-lamp swirls.
// We sample fbm twice with an offset, use those values to warp the coords,
// then sample again. This creates the characteristic "folded" look.
// ────────────────────────────────────────────────────────────────────────────
float warp(vec2 p, float t) {
	// First warp pass
	vec2 q = vec2(
		fbm(p + vec2(0.0,  0.0) + t * 0.3),
		fbm(p + vec2(5.2,  1.3) + t * 0.3)
	);

	// Second warp pass (warped coords fed back in)
	vec2 r = vec2(
		fbm(p + swirl_strength * q + vec2(1.7, 9.2) + t * 0.15),
		fbm(p + swirl_strength * q + vec2(8.3, 2.8) + t * 0.15)
	);

	return fbm(p + swirl_strength * r + t * 0.1);
}

// ────────────────────────────────────────────────────────────────────────────
void fragment() {
	float t = TIME * speed;

	// UV centred at (0,0), aspect-corrected so swirls aren't squashed
	vec2 uv = UV - 0.5;
	uv.x *= 1.78; // approximate 16:9

	// Scale to wave frequency
	vec2 p = uv * wave_scale;

	// ── Core swirl value ─────────────────────────────────────────────────
	float w = warp(p, t);  // range roughly [-0.7, 0.7]

	// ── Red / Blue split ─────────────────────────────────────────────────
	// The horizontal position biases which colour dominates, just like the
	// reference image (red on the left, blue on the right).
	float bias = uv.x * 0.6; // gentle horizontal lean
	float split = w + bias;

	// Smooth sigmoid for colour mixing — higher split_sharpness = crisper edge
	float t_ab = 0.5 + 0.5 * tanh(split * split_sharpness);

	// ── Depth / darkness in the swirl troughs ────────────────────────────
	// Areas where |w| is small are at the centre of a swirl → darker
	float depth = 1.0 - dark_core * (1.0 - smoothstep(0.0, 0.55, abs(w)));

	// ── Highlight sheen on swirl ridges ──────────────────────────────────
	// Where the warp gradient is steep = edge of a ribbon = bright specular
	float ridge = smoothstep(0.3, 0.65, abs(w));
	float highlight = ridge * highlight_strength;

	// ── Assemble colour ──────────────────────────────────────────────────
	// Blend A↔B across the split, darken at cores, brighten at ridges
	vec4 base = mix(color_a, color_b, t_ab);

	// Pull toward dark core colour in the swirl centres
	base = mix(color_mid, base, depth);

	// Add highlight (whites / near-whites along ribbon edges)
	base.rgb += highlight * mix(vec3(1.0, 0.6, 0.3), vec3(0.5, 0.7, 1.0), t_ab);

	base.a = 1.0;
	COLOR = base;
}
