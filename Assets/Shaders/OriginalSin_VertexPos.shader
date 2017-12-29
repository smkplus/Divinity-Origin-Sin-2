Shader "Custom/ViewMode2"
{
  Properties{
    _MainTex("MainTex",2D) = "white"{}
    _Scale("Scale",Vector) = (1,1,1,1)

  }
    SubShader
  {
    // Draw ourselves after all opaque geometry
    Tags{ "Queue" = "Transparent" }

    // Grab the screen behind the object into _BackgroundTexture
    GrabPass
  {
    "_BackgroundTexture"
  }

      Blend SrcAlpha OneMinusSrcAlpha
    // Render the object with the texture generated above, and invert the colors
    Pass
  {
    CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"



    struct v2f
  {
    float4 grabPos : TEXCOORD0;
    float4 pos : SV_POSITION;
  };

  struct appdata {
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;

  };
  sampler2D _MainTex;
  float4 _Scale;

  v2f vert(appdata v) {

    v2f o;

    // use UnityObjectToClipPos from UnityCG.cginc to calculate 
    // the clip-space of the vertex
    o.pos = UnityObjectToClipPos(v.vertex);
    // use ComputeGrabScreenPos function from UnityCG.cginc
    // to get the correct texture coordinate
    o.grabPos = ComputeGrabScreenPos(o.pos);

    return o;
  }

  sampler2D _BackgroundTexture;

  half4 frag(v2f i) : SV_Target
  {
    half4 bgcolor = tex2Dproj(_MainTex, i.grabPos/_Scale);
    return bgcolor;
  }
    ENDCG
  }

  }
}