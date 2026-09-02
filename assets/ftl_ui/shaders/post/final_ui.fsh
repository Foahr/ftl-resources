#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;
uniform sampler2D Icon0Sampler;
uniform sampler2D Icon1Sampler;
uniform sampler2D Icon2Sampler;
uniform sampler2D Icon3Sampler;
uniform sampler2D Icon4Sampler;
uniform sampler2D PoweredCellSampler;
uniform sampler2D UnpoweredCellSampler;

layout(location = 0) in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(location = 0) out vec4 fragColor;

const vec2 DataCellSize = vec2(1.0, 1.0);
const float ValueMax = 8.0;

const vec2 ReadoutCellSize = vec2(24.0, 12.0);
const float CellGap = 1.0;
const float IconGap = 6.0;
const float IconWidth = ReadoutCellSize.x * 1.5;
const float BarGap = 8.0;
const vec2 Margin = vec2(16.0, 16.0);

void main() {
    vec4 base = texture(InSampler, texCoord);
    vec2 pixelCoord = texCoord * InSize;
    vec4 outColor = base;


    // --- weapons ---
    {
        const vec2 dataCellOffset = vec2(2.0, 2.0);
        vec2 cellUv = (dataCellOffset + DataCellSize * 0.5) / InSize;
        vec3 cell = texture(InSampler, cellUv).rgb;

        int power = int(round(cell.r * ValueMax));
        int maxPower = int(round(cell.b * ValueMax));

        vec2 iconMin = vec2(InSize.x - Margin.x - IconWidth - 0.0 * (IconWidth + BarGap), Margin.y);
        vec2 iconMax = iconMin + vec2(IconWidth);

        float cellMinX = iconMin.x + (IconWidth - ReadoutCellSize.x) * 0.5;
        float cellMaxX = cellMinX + ReadoutCellSize.x;

        if (pixelCoord.x >= iconMin.x && pixelCoord.x < iconMax.x
            && pixelCoord.y >= iconMin.y && pixelCoord.y < iconMax.y) {
            vec2 localUv = (pixelCoord - iconMin) / IconWidth;
            vec4 sprite = texture(Icon0Sampler, vec2(localUv.x, 1 - localUv.y));
            outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
        } else if (pixelCoord.x >= cellMinX && pixelCoord.x < cellMaxX && pixelCoord.y > iconMax.y) {
            float above = pixelCoord.y - iconMax.y - IconGap;

            if (above >= 0.0) {
                float pitch = ReadoutCellSize.y + CellGap;
                int slot = int(floor(above / pitch));
                float withinSlot = above - float(slot) * pitch;

                if (slot < maxPower && withinSlot < ReadoutCellSize.y) {
                    float localX = (pixelCoord.x - cellMinX) / ReadoutCellSize.x;
                    float localY = 1.0 - (withinSlot / ReadoutCellSize.y);
                    vec2 localUv = vec2(localX, localY);

                    vec4 sprite;
                    if (slot < power) {
                        sprite = texture(PoweredCellSampler, localUv);
                    } else {
                        sprite = texture(UnpoweredCellSampler, localUv);
                    }
                    outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
                }
            }
        }

        if (pixelCoord.x >= dataCellOffset.x && pixelCoord.x < dataCellOffset.x + DataCellSize.x
            && pixelCoord.y >= dataCellOffset.y && pixelCoord.y < dataCellOffset.y + DataCellSize.y) {
            outColor = base;
        }
    }

    // --- shields ---
    {
        const vec2 dataCellOffset = vec2(6.0, 2.0);
        vec2 cellUv = (dataCellOffset + DataCellSize * 0.5) / InSize;
        vec3 cell = texture(InSampler, cellUv).rgb;

        int power = int(round(cell.r * ValueMax));
        int maxPower = int(round(cell.b * ValueMax));

        vec2 iconMin = vec2(InSize.x - Margin.x - IconWidth - 1.0 * (IconWidth + BarGap), Margin.y);
        vec2 iconMax = iconMin + vec2(IconWidth);

        float cellMinX = iconMin.x + (IconWidth - ReadoutCellSize.x) * 0.5;
        float cellMaxX = cellMinX + ReadoutCellSize.x;

        if (pixelCoord.x >= iconMin.x && pixelCoord.x < iconMax.x
            && pixelCoord.y >= iconMin.y && pixelCoord.y < iconMax.y) {
            vec2 localUv = (pixelCoord - iconMin) / IconWidth;
            vec4 sprite = texture(Icon1Sampler, vec2(localUv.x, 1 - localUv.y));
            outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
        } else if (pixelCoord.x >= cellMinX && pixelCoord.x < cellMaxX && pixelCoord.y > iconMax.y) {
            float above = pixelCoord.y - iconMax.y - IconGap;

            if (above >= 0.0) {
                float pitch = ReadoutCellSize.y + CellGap;
                int slot = int(floor(above / pitch));
                float withinSlot = above - float(slot) * pitch;

                if (slot < maxPower && withinSlot < ReadoutCellSize.y) {
                    float localX = (pixelCoord.x - cellMinX) / ReadoutCellSize.x;
                    float localY = 1.0 - (withinSlot / ReadoutCellSize.y);
                    vec2 localUv = vec2(localX, localY);

                    vec4 sprite;
                    if (slot < power) {
                        sprite = texture(PoweredCellSampler, localUv);
                    } else {
                        sprite = texture(UnpoweredCellSampler, localUv);
                    }
                    outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
                }
            }
        }

        if (pixelCoord.x >= dataCellOffset.x && pixelCoord.x < dataCellOffset.x + DataCellSize.x
            && pixelCoord.y >= dataCellOffset.y && pixelCoord.y < dataCellOffset.y + DataCellSize.y) {
            outColor = base;
        }
    }

    // --- oxygen ---
    {
        const vec2 dataCellOffset = vec2(10.0, 2.0);
        vec2 cellUv = (dataCellOffset + DataCellSize * 0.5) / InSize;
        vec3 cell = texture(InSampler, cellUv).rgb;

        int power = int(round(cell.r * ValueMax));
        int maxPower = int(round(cell.b * ValueMax));

        vec2 iconMin = vec2(InSize.x - Margin.x - IconWidth - 2.0 * (IconWidth + BarGap), Margin.y);
        vec2 iconMax = iconMin + vec2(IconWidth);

        float cellMinX = iconMin.x + (IconWidth - ReadoutCellSize.x) * 0.5;
        float cellMaxX = cellMinX + ReadoutCellSize.x;

        if (pixelCoord.x >= iconMin.x && pixelCoord.x < iconMax.x
            && pixelCoord.y >= iconMin.y && pixelCoord.y < iconMax.y) {
            vec2 localUv = (pixelCoord - iconMin) / IconWidth;
            vec4 sprite = texture(Icon2Sampler, vec2(localUv.x, 1 - localUv.y));
            outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
        } else if (pixelCoord.x >= cellMinX && pixelCoord.x < cellMaxX && pixelCoord.y > iconMax.y) {
            float above = pixelCoord.y - iconMax.y - IconGap;

            if (above >= 0.0) {
                float pitch = ReadoutCellSize.y + CellGap;
                int slot = int(floor(above / pitch));
                float withinSlot = above - float(slot) * pitch;

                if (slot < maxPower && withinSlot < ReadoutCellSize.y) {
                    float localX = (pixelCoord.x - cellMinX) / ReadoutCellSize.x;
                    float localY = 1.0 - (withinSlot / ReadoutCellSize.y);
                    vec2 localUv = vec2(localX, localY);

                    vec4 sprite;
                    if (slot < power) {
                        sprite = texture(PoweredCellSampler, localUv);
                    } else {
                        sprite = texture(UnpoweredCellSampler, localUv);
                    }
                    outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
                }
            }
        }

        if (pixelCoord.x >= dataCellOffset.x && pixelCoord.x < dataCellOffset.x + DataCellSize.x
            && pixelCoord.y >= dataCellOffset.y && pixelCoord.y < dataCellOffset.y + DataCellSize.y) {
            outColor = base;
        }
    }

    // --- engines ---
    {
        const vec2 dataCellOffset = vec2(14.0, 2.0);
        vec2 cellUv = (dataCellOffset + DataCellSize * 0.5) / InSize;
        vec3 cell = texture(InSampler, cellUv).rgb;

        int power = int(round(cell.r * ValueMax));
        int maxPower = int(round(cell.b * ValueMax));

        vec2 iconMin = vec2(InSize.x - Margin.x - IconWidth - 3.0 * (IconWidth + BarGap), Margin.y);
        vec2 iconMax = iconMin + vec2(IconWidth);

        float cellMinX = iconMin.x + (IconWidth - ReadoutCellSize.x) * 0.5;
        float cellMaxX = cellMinX + ReadoutCellSize.x;

        if (pixelCoord.x >= iconMin.x && pixelCoord.x < iconMax.x
            && pixelCoord.y >= iconMin.y && pixelCoord.y < iconMax.y) {
            vec2 localUv = (pixelCoord - iconMin) / IconWidth;
            vec4 sprite = texture(Icon3Sampler, vec2(localUv.x, 1 - localUv.y));
            outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
        } else if (pixelCoord.x >= cellMinX && pixelCoord.x < cellMaxX && pixelCoord.y > iconMax.y) {
            float above = pixelCoord.y - iconMax.y - IconGap;

            if (above >= 0.0) {
                float pitch = ReadoutCellSize.y + CellGap;
                int slot = int(floor(above / pitch));
                float withinSlot = above - float(slot) * pitch;

                if (slot < maxPower && withinSlot < ReadoutCellSize.y) {
                    float localX = (pixelCoord.x - cellMinX) / ReadoutCellSize.x;
                    float localY = 1.0 - (withinSlot / ReadoutCellSize.y);
                    vec2 localUv = vec2(localX, localY);

                    vec4 sprite;
                    if (slot < power) {
                        sprite = texture(PoweredCellSampler, localUv);
                    } else {
                        sprite = texture(UnpoweredCellSampler, localUv);
                    }
                    outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
                }
            }
        }

        if (pixelCoord.x >= dataCellOffset.x && pixelCoord.x < dataCellOffset.x + DataCellSize.x
            && pixelCoord.y >= dataCellOffset.y && pixelCoord.y < dataCellOffset.y + DataCellSize.y) {
            outColor = base;
        }
    }

    // --- medbay ---
    {
        const vec2 dataCellOffset = vec2(18.0, 2.0);
        vec2 cellUv = (dataCellOffset + DataCellSize * 0.5) / InSize;
        vec3 cell = texture(InSampler, cellUv).rgb;

        int power = int(round(cell.r * ValueMax));
        int maxPower = int(round(cell.b * ValueMax));

        vec2 iconMin = vec2(InSize.x - Margin.x - IconWidth - 4.0 * (IconWidth + BarGap), Margin.y);
        vec2 iconMax = iconMin + vec2(IconWidth);

        float cellMinX = iconMin.x + (IconWidth - ReadoutCellSize.x) * 0.5;
        float cellMaxX = cellMinX + ReadoutCellSize.x;

        if (pixelCoord.x >= iconMin.x && pixelCoord.x < iconMax.x
            && pixelCoord.y >= iconMin.y && pixelCoord.y < iconMax.y) {
            vec2 localUv = (pixelCoord - iconMin) / IconWidth;
            vec4 sprite = texture(Icon4Sampler, vec2(localUv.x, 1 - localUv.y));
            outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
        } else if (pixelCoord.x >= cellMinX && pixelCoord.x < cellMaxX && pixelCoord.y > iconMax.y) {
            float above = pixelCoord.y - iconMax.y - IconGap;

            if (above >= 0.0) {
                float pitch = ReadoutCellSize.y + CellGap;
                int slot = int(floor(above / pitch));
                float withinSlot = above - float(slot) * pitch;

                if (slot < maxPower && withinSlot < ReadoutCellSize.y) {
                    float localX = (pixelCoord.x - cellMinX) / ReadoutCellSize.x;
                    float localY = 1.0 - (withinSlot / ReadoutCellSize.y);
                    vec2 localUv = vec2(localX, localY);

                    vec4 sprite;
                    if (slot < power) {
                        sprite = texture(PoweredCellSampler, localUv);
                    } else {
                        sprite = texture(UnpoweredCellSampler, localUv);
                    }
                    outColor = vec4(mix(outColor.rgb, sprite.rgb, sprite.a), 1.0);
                }
            }
        }

        if (pixelCoord.x >= dataCellOffset.x && pixelCoord.x < dataCellOffset.x + DataCellSize.x
            && pixelCoord.y >= dataCellOffset.y && pixelCoord.y < dataCellOffset.y + DataCellSize.y) {
            outColor = base;
        }
    }

    fragColor = outColor;
}
