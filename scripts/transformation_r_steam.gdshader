shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Color of the steam
uniform float speed : hint_range(0.0, 10.0) = 1.0; // Speed of the steam movement
uniform float frequency : hint_range(0.0, 10.0) = 1.0; // Frequency of the wave
uniform float amplitude : hint_range(0.0, 1.0) = 0.2; // Amplitude of the wave
uniform float stream_count : hint_range(1, 10) = 5; // Number of steam streams

void fragment() {
    vec2 uv = FRAGCOORD.xy / vec2(800.0, 800.0); // Scale UV to the size of the node
    float mask = 0.0;
    
    for (int i = 0; i < int(stream_count); i++) {
        float offset = float(i) / stream_count;
        float wave = sin((uv.y + offset) * frequency + TIME * speed) * amplitude;
        mask += smoothstep(0.4, 0.5, uv.x + wave) * smoothstep(0.4, 0.5, 1.0 - uv.x - wave);
    }
    
    mask = clamp(mask, 0.0, 1.0); // Ensure mask is between 0 and 1
    COLOR = color * vec4(vec3(mask), mask);
}