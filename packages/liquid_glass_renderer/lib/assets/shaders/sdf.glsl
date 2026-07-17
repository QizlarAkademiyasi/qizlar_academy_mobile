// Shape array uniforms - 6 floats per shape (type, centerX, centerY, sizeW, sizeH, cornerRadius)
// Reduced from 64 to 16 shapes to fit Impeller's uniform buffer limit (16 * 6 = 96 floats vs 384)
#ifndef MAX_SHAPES
#define MAX_SHAPES 16
#endif

float sdfRRect( in vec2 p, in vec2 b, in float r ) {
    float shortest = min(b.x, b.y);
    r = min(r, shortest);
    vec2 q = abs(p)-b+r;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r;
}

float sdfRect(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float sdfSquircle(vec2 p, vec2 b, float r) {
    float shortest = min(b.x, b.y);
    r = min(r, shortest);

    vec2 q = abs(p) - b + r;
    
    vec2 maxQ = max(q, 0.0);
    return min(max(q.x, q.y), 0.0) + sqrt(maxQ.x * maxQ.x + maxQ.y * maxQ.y) - r;
}

float sdfEllipse(vec2 p, vec2 r) {
    r = max(r, 1e-4);
    
    vec2 invR = 1.0 / r;
    vec2 invR2 = invR * invR;
    
    vec2 pInvR = p * invR;
    float k1 = length(pInvR);
    
    vec2 pInvR2 = p * invR2;
    float k2 = length(pInvR2);
    
    return (k1 * (k1 - 1.0)) / max(k2, 1e-4);
}

float smoothUnion(float d1, float d2, float k) {
    if (k <= 0.0) {
        return min(d1, d2);
    }
    float e = max(k - abs(d1 - d2), 0.0);
    return min(d1, d2) - e * e * 0.25 / k;
}

float getShapeSDF(float type, vec2 p, vec2 center, vec2 size, float r) {
    if (type == 1.0) { // squircle
        return sdfSquircle(p - center, size / 2.0, r);
    }
    if (type == 2.0) { // ellipse
        return sdfEllipse(p - center, size / 2.0);
    }
    if (type == 3.0) { // rounded rectangle
        return sdfRRect(p - center, size / 2.0, r);
    }
    return 1e9; // none
}

// SkSL requires uniform-array indices to be constant expressions and cannot
// copy an array into a function parameter. Keep every shape access literal.
#define SDF_SHAPE(BASE) getShapeSDF( \
    uShapeData[BASE], p, \
    vec2(uShapeData[BASE + 1], uShapeData[BASE + 2]), \
    vec2(uShapeData[BASE + 3], uShapeData[BASE + 4]), \
    uShapeData[BASE + 5])

float sdfShape0(vec2 p) { return SDF_SHAPE(0); }
float sdfShape1(vec2 p) { return SDF_SHAPE(6); }
float sdfShape2(vec2 p) { return SDF_SHAPE(12); }
float sdfShape3(vec2 p) { return SDF_SHAPE(18); }
float sdfShape4(vec2 p) { return SDF_SHAPE(24); }
float sdfShape5(vec2 p) { return SDF_SHAPE(30); }
float sdfShape6(vec2 p) { return SDF_SHAPE(36); }
float sdfShape7(vec2 p) { return SDF_SHAPE(42); }
float sdfShape8(vec2 p) { return SDF_SHAPE(48); }
float sdfShape9(vec2 p) { return SDF_SHAPE(54); }
float sdfShape10(vec2 p) { return SDF_SHAPE(60); }
float sdfShape11(vec2 p) { return SDF_SHAPE(66); }
float sdfShape12(vec2 p) { return SDF_SHAPE(72); }
float sdfShape13(vec2 p) { return SDF_SHAPE(78); }
float sdfShape14(vec2 p) { return SDF_SHAPE(84); }
float sdfShape15(vec2 p) { return SDF_SHAPE(90); }

float sceneSDF(vec2 p, int numShapes, float blend) {
    if (numShapes <= 0) return 1e9;

    float result = sdfShape0(p);
    if (numShapes == 1) return result;
    result = smoothUnion(result, sdfShape1(p), blend);
    if (numShapes == 2) return result;
    result = smoothUnion(result, sdfShape2(p), blend);
    if (numShapes == 3) return result;
    result = smoothUnion(result, sdfShape3(p), blend);
    if (numShapes == 4) return result;
    result = smoothUnion(result, sdfShape4(p), blend);
    if (numShapes == 5) return result;
    result = smoothUnion(result, sdfShape5(p), blend);
    if (numShapes == 6) return result;
    result = smoothUnion(result, sdfShape6(p), blend);
    if (numShapes == 7) return result;
    result = smoothUnion(result, sdfShape7(p), blend);
    if (numShapes == 8) return result;
    result = smoothUnion(result, sdfShape8(p), blend);
    if (numShapes == 9) return result;
    result = smoothUnion(result, sdfShape9(p), blend);
    if (numShapes == 10) return result;
    result = smoothUnion(result, sdfShape10(p), blend);
    if (numShapes == 11) return result;
    result = smoothUnion(result, sdfShape11(p), blend);
    if (numShapes == 12) return result;
    result = smoothUnion(result, sdfShape12(p), blend);
    if (numShapes == 13) return result;
    result = smoothUnion(result, sdfShape13(p), blend);
    if (numShapes == 14) return result;
    result = smoothUnion(result, sdfShape14(p), blend);
    if (numShapes == 15) return result;
    return smoothUnion(result, sdfShape15(p), blend);
}

// Calculate 3D normal using derivatives (shader-specific normal calculation)
vec3 getNormal(float sd, float thickness, vec2 p, int numShapes, float blend) {
    float dx = sceneSDF(p + vec2(0.5, 0.0), numShapes, blend)
        - sceneSDF(p - vec2(0.5, 0.0), numShapes, blend);
    float dy = sceneSDF(p + vec2(0.0, 0.5), numShapes, blend)
        - sceneSDF(p - vec2(0.0, 0.5), numShapes, blend);
    
    // The cosine and sine between normal and the xy plane
    float n_cos = max(thickness + sd, 0.0) / thickness;
    float n_sin = sqrt(max(0.0, 1.0 - n_cos * n_cos));
    
    return normalize(vec3(dx * n_cos, dy * n_cos, n_sin));
}
