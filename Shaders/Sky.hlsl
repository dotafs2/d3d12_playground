//=============================================================================
// Sky.fx by Frank Luna (C) 2011 All Rights Reserved.
//=============================================================================

#include "Common.hlsl"


struct VertexIn
{
	float3 PosL    : POSITION;
	float3 NormalL : NORMAL;
	float2 TexC    : TEXCOORD;
};

struct VertexOut
{
	float4 PosH : SV_POSITION;
    float3 PosL : POSITION;
};
 
VertexOut VS(VertexIn vin)
{
    VertexOut vout;

    // Use local vertex position as cubemap lookup vector.
    vout.PosL = vin.PosL;

    // 直接使用摄像机位置加上顶点位置
    float3 posW = gEyePosW + vin.PosL;

    // 设置z = w，确保天空盒在远平面上
    vout.PosH = mul(float4(posW, 1.0f), gViewProj).xyww;

    return vout;
}


float4 PS(VertexOut pin) : SV_Target
{
    float4 color = gCubeMap.Sample(gsamLinearWrap, pin.PosL);
    color.rgb = pow(color.rgb, 1.0 / 2.2);
    return color;
}

