#include <flutter/runtime_effect.glsl>

// Impeller ImageFilter.shader: first uniform is vec2 size (engine-set),
// first sampler is the filter input. Remaining floats are set from Dart.
uniform vec2 u_size;
uniform float u_direction;
uniform float u_max_sigma;
uniform float u_solid_end;
uniform sampler2D u_texture;

out vec4 frag_color;

const int kTaps = 15;

float sigmaWeight(float y) {
  float start = clamp(u_solid_end, 0.05, 0.95);
  float ny = clamp(y, 0.0, 1.0);
  if (ny <= start) {
    return mix(1.0, 0.92, smoothstep(0.0, start, ny));
  }
  float t = smoothstep(start, 1.0, ny);
  return mix(0.92, 0.0, t * t * (3.0 - 2.0 * t));
}

vec4 sampleBackdrop(vec2 uv) {
  return texture(u_texture, clamp(uv, vec2(0.0), vec2(1.0)));
}

vec4 gaussian1D(vec2 uv, vec2 axis, float sigma) {
  if (sigma < 0.08) {
    return sampleBackdrop(uv);
  }

  vec2 texel = 1.0 / max(u_size, vec2(1.0));
  float radius = sigma * 3.0;
  float two_sigma_sq = 2.0 * sigma * sigma;
  vec4 acc = vec4(0.0);
  float weight_sum = 0.0;

  for (int i = 0; i < kTaps; i++) {
    float t = (float(i) / float(kTaps - 1)) * 2.0 - 1.0;
    float offset = t * radius;
    float w = exp(-(offset * offset) / two_sigma_sq);
    acc += sampleBackdrop(uv + axis * texel * offset) * w;
    weight_sum += w;
  }

  return acc / max(weight_sum, 0.0001);
}

void main() {
  vec2 uv = FlutterFragCoord().xy / max(u_size, vec2(1.0));
  float logical_y = uv.y;
#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif

  vec2 axis = u_direction > 0.5 ? vec2(0.0, 1.0) : vec2(1.0, 0.0);
  float sigma = u_max_sigma * sigmaWeight(logical_y);
  frag_color = gaussian1D(uv, axis, sigma);
}
