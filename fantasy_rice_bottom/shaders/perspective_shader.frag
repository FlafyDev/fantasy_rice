#version 460 core
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

out vec4 fragColor;

void main() {
    // Normalize pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy / u_resolution;

    // Center the coordinates around (0,0)
    vec2 centered = uv - 0.5;

    // Apply a simple perspective distortion
    float perspective = 1.0 / (1.0 + centered.y * 2.0);
    centered.x *= perspective;

    // Reconstruct the UV coordinates
    vec2 distortedUV = centered + 0.5;

    // Create a simple gradient based on the distorted UV
    vec3 color = vec3(distortedUV.x, distortedUV.y, 1.0);

    fragColor = vec4(color, 1.0);
}
