// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/SimpleMask"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_CutOff("CutOff",Range(0,1)) = 0
		_Radius("Radius",Range(0,1)) = 0.2
		_Speed("speed",Float) = 1
	}
	SubShader
	{


		
		LOD 100
		Blend One OneMinusSrcAlpha
		Tags { "Queue" = "Geometry-1" }  // Write to the stencil buffer before drawing any geometry to the screen
ColorMask 0 // Don't write to any colour channels
ZWrite Off // Don't write to the Depth buffer
		// Write the value 1 to the stencil buffer
Stencil
{
    Ref 1
    Comp Always
    Pass Replace
}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				 float4 ObjectSpace : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _CutOff;
			float _Speed;
			float _Radius;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
              
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				float dissolve = step(col,_CutOff);
				float circle = distance(i.uv,0.5);
				circle = step(circle,_Radius);
				//clip((col.a-_CutOff));
				clip(_CutOff-dissolve);
				return float4(1,1,1,1)*dissolve;
			}
			ENDCG
		}

		
	}
}
