#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

//float gTime = 0.0;
//constant float REPEAT = 5.0;

// Вращательная матрица
float2x2 rot(float a) {
    float c = cos(a), s = sin(a);
    return float2x2(c, s, -s, c);
}

// Signed Distance Function для коробки
float sdBox(vector_float3 p, float3 b) {
    float3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float box(vector_float3 pos, float scale) {
    pos *= scale;
    float base = sdBox(pos, float3(0.4, 0.4, 0.1)) / 1.5;
    pos.xy *= 5.0;
    pos.y -= 3.5;
    pos.xy *= rot(0.75);
    return -base;
}

float box_set(vector_float3 pos, float iTime) {
    vector_float3 pos_origin = pos;
    
    pos = pos_origin;
    pos.y += sin(iTime * 0.4) * 2.5;
    pos.xy *= rot(0.8);
    float box1 = box(pos, 2.0 - abs(sin(gTime * 0.4)) * 1.5);
    
    pos = pos_origin;
    pos.y -= sin(gTime * 0.4) * 2.5;
    pos.xy *= rot(0.8);
    float box2 = box(pos, 2.0 - abs(sin(gTime * 0.4)) * 1.5);
    
    pos = pos_origin;
    pos.x += sin(gTime * 0.4) * 2.5;
    pos.xy *= rot(0.8);
    float box3 = box(pos, 2.0 - abs(sin(gTime * 0.4)) * 1.5);
    
    pos = pos_origin;
    pos.x -= sin(gTime * 0.4) * 2.5;
    pos.xy *= rot(0.8);
    float box4 = box(pos, 2.0 - abs(sin(gTime * 0.4)) * 1.5);
    
    pos = pos_origin;
    pos.xy *= rot(0.8);
    float box5 = box(pos, 0.5) * 6.0;
    
    pos = pos_origin;
    float box6 = box(pos, 0.5) * 6.0;

    return max(max(max(max(max(box1, box2), box3), box4), box5), box6);
}

float map(float3 pos, float iTime) {
    return box_set(pos, iTime);
}

fragment float4 mainImage(float2 fragCoord [[position]], constant float4x4& iResolution, constant float& iTime) {
    float2 p = (fragCoord.xy * 2.0 - iResolution.xy) / min(iResolution.x, iResolution.y);
    float3 ro = float3(0.0, -0.2, iTime * 4.0);
    float3 ray = normalize(float3(p, 1.5));
    ray.xy *= rot(sin(iTime * 0.03) * 5.0);
    ray.yz *= rot(sin(iTime * 0.05) * 0.2);
    
    float t = 0.1;
    float3 col = float3(0.0);
    float ac = 0.0;
    
    for (int i = 0; i < 99; i++) {
        float3 pos = ro + ray * t;
        pos = fmod(pos - 2.0, 4.0) - 2.0;
        gTime = iTime - float(i) * 0.01;
        
        float d = map(pos, iTime);
        d = max(abs(d), 0.01);
        ac += exp(-d * 23.0);
        
        t += d * 0.55;
    }
    
    col = float3(ac * 0.02);
    col += float3(0.0, 0.2 * abs(sin(iTime)), 0.5 + sin(iTime) * 0.2);
    
    return float4(col, 1.0 - t * (0.02 + 0.02 * sin(iTime)));
}
