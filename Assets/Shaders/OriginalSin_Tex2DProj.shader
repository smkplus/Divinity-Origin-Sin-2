Shader "Custom/ViewMode1"
{ 
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Scale("Scale",Vector) = (1,1,1,1)

}

SubShader
{
Tags {"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent"}
ZWrite Off Blend SrcAlpha OneMinusSrcAlpha Cull Off

Pass
{

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#include "UnityCG.cginc"

struct appdata_t
{
float4 vertex   : POSITION;
float2 texcoord : TEXCOORD0;
};

struct v2f
{
half2 texcoord  : TEXCOORD0;
float4 vertex   : SV_POSITION;
};

sampler2D _MainTex;
float _Speed;
float4 _Scale;


v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
return OUT;
}

float4 frag (v2f i) : COLOR
{

float2 screen = i.vertex.xy/_ScreenParams.xy;
    float4 tex = tex2D(_MainTex, screen /_Scale);

return tex;
}
ENDCG
}
}

}