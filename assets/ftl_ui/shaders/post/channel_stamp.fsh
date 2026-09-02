#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform ChannelConfig {
    vec2 PixelOffset;
    vec2 PixelSize;
    vec4 ChannelMask;
    float Value;
};

layout(location = 0) out vec4 fragColor;

void main() {
    vec2 pixelCoord = texCoord * InSize;
    vec4 base = texture(InSampler, texCoord);

    bool inside = pixelCoord.x >= PixelOffset.x && pixelCoord.x < PixelOffset.x + PixelSize.x
               && pixelCoord.y >= PixelOffset.y && pixelCoord.y < PixelOffset.y + PixelSize.y;

    fragColor = inside ? mix(base, vec4(Value), ChannelMask) : base;
}
