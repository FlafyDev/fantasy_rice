#include <flutter/runtime_effect.glsl>

// Input uniforms
uniform vec2 uSize;
uniform float uTime;
uniform sampler2D uTexture;

// Shader outputs
out vec4 fragColor;

// 3D transformation matrices
mat3 rotationX(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        1.0, 0.0, 0.0,
        0.0, c, -s,
        0.0, s, c
    );
}

mat3 rotationY(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c
    );
}

mat3 rotationZ(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        c, -s, 0.0,
        s, c, 0.0,
        0.0, 0.0, 1.0
    );
}

// 3D perspective projection
vec2 project3D(vec3 pos, float fov) {
    float d = 1.0 / tan(fov * 0.5);
    return vec2(pos.x * d / (pos.z + 2.0), pos.y * d / (pos.z + 2.0));
}

// Create a subtle gradient for depth
vec3 depthShading(float depth) {
    float shade = 1.0 - depth * 0.3;
    return vec3(shade, shade * 0.95, shade * 0.9);
}

// Add some subtle noise for texture
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // Get fragment coordinates (SkSL provides this automatically)
    vec2 fragCoord = FlutterFragCoord();
    
    // Normalize coordinates
    vec2 uv = fragCoord / uSize;
    vec2 centeredUV = (uv - 0.5) * 2.0;
    
    // Create 3D position
    vec3 pos = vec3(centeredUV.x, centeredUV.y, 0.0);
    
    // Apply rotations for that Balatro card-table perspective
    float tiltX = sin(uTime * 0.5) * 0.1 + 0.15;  // Slight forward tilt
    float tiltY = sin(uTime * 0.3) * 0.05;        // Subtle side sway
    float tiltZ = sin(uTime * 0.7) * 0.02;        // Minimal rotation
    
    pos = rotationX(tiltX) * pos;
    pos = rotationY(tiltY) * pos;
    pos = rotationZ(tiltZ) * pos;
    
    // Project to 2D with perspective
    float fov = 1.2;
    vec2 projected = project3D(pos, fov);
    
    // Convert back to texture coordinates
    vec2 texCoord = (projected * 0.5 + 0.5);
    
    // Add some warping for that curved table effect
    float warpStrength = 0.1;
    vec2 warp = vec2(
        sin(texCoord.y * 3.14159) * warpStrength * texCoord.x,
        sin(texCoord.x * 3.14159) * warpStrength * 0.5
    );
    texCoord += warp;
    
    // Sample the texture
    vec4 color = vec4(0.0);
    if (texCoord.x >= 0.0 && texCoord.x <= 1.0 && 
        texCoord.y >= 0.0 && texCoord.y <= 1.0) {
        color = texture(uTexture, texCoord);
        
        // Add depth shading
        float depth = length(pos.z + 1.0) * 0.5;
        vec3 shading = depthShading(depth);
        color.rgb *= shading;
        
        // Add subtle highlight on edges (card shine effect)
        float edgeDist = min(min(texCoord.x, 1.0 - texCoord.x), 
                            min(texCoord.y, 1.0 - texCoord.y));
        float highlight = smoothstep(0.0, 0.1, edgeDist) * 0.2;
        color.rgb += highlight;
        
        // Add very subtle noise for texture
        float noiseVal = noise(fragCoord * 0.01) * 0.02;
        color.rgb += noiseVal;
        
    } else {
        // Outside bounds - create a subtle vignette/shadow
        float dist = length(centeredUV);
        color = vec4(0.1, 0.05, 0.15, smoothstep(1.2, 0.8, dist));
    }
    
    // Final color adjustments for that Balatro aesthetic
    color.rgb *= vec3(1.1, 1.0, 0.95); // Slightly warm
    color.rgb = pow(color.rgb, vec3(0.9)); // Slight gamma correction
    
    fragColor = color;
}