Shader "Smkgames/Particles/OriginalSin" {
Properties {
	_MainTex ("Particle Texture", 2D) = "white" {}
	_BackGround("BackGround",2D) = "white"{}
	_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
	_Scale("Scale",Vector) = (1,1,1,1)

	_Hue ("Hue", Range(0, 1.0)) = 0
	_Saturation ("Saturation", Range(0, 1.0)) = 0.5
	_Brightness ("Brightness", Range(0, 1.0)) = 0.5
	_Contrast ("Contrast", Range(0, 1.0)) = 0.5
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
	Blend One OneMinusSrcColor
	ColorMask RGB
	Cull Off Lighting Off ZWrite Off


	SubShader {
  GrabPass
  {
    "_BackgroundTexture"
  }
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_particles
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			sampler2D _MainTex,_BackGround;
			fixed4 _TintColor;
			
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;

			};

			struct v2f {
				float4 grabPos : TEXCOORD3;
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				fixed4 hsbc : COLOR1;
				float2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				#ifdef SOFTPARTICLES_ON
				float4 projPos : TEXCOORD2;
				#endif
			};

			float4 _MainTex_ST;
			float4 _Scale;
			fixed _Hue, _Saturation, _Brightness, _Contrast;


			inline float3 applyHue(float3 aColor, float aHue)
            {
                float angle = radians(aHue);
                float3 k = float3(0.57735, 0.57735, 0.57735);
                float cosAngle = cos(angle);
                
                return aColor * cosAngle + cross(k, aColor) * sin(angle) + k * dot(k, aColor) * (1 - cosAngle);
            }
			
			inline float4 applyHSBCEffect(float4 startColor, fixed4 hsbc)
            {
                float hue = 360 * hsbc.r;
                float saturation = hsbc.g * 2;
                float brightness = hsbc.b * 2 - 1;
                float contrast = hsbc.a * 2;
 
                float4 outputColor = startColor;
                outputColor.rgb = applyHue(outputColor.rgb, hue);
                outputColor.rgb = (outputColor.rgb - 0.5f) * contrast + 0.5f;
                outputColor.rgb = outputColor.rgb + brightness;
                float3 intensity = dot(outputColor.rgb, float3(0.39, 0.59, 0.11));
    			outputColor.rgb = lerp(intensity, outputColor.rgb, saturation);
                 
                return outputColor;
            }

			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				#ifdef SOFTPARTICLES_ON
				o.projPos = ComputeScreenPos (o.vertex);
				COMPUTE_EYEDEPTH(o.projPos.z);
				#endif
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				o.grabPos = ComputeGrabScreenPos(o.vertex);
				o.hsbc = fixed4(_Hue, _Saturation, _Brightness, _Contrast);

				return o;
			}

			sampler2D_float _CameraDepthTexture;
			float _InvFade;
			
			fixed4 frag (v2f i) : SV_Target
			{
				#ifdef SOFTPARTICLES_ON
				float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
				float partZ = i.projPos.z;
				float fade = saturate (_InvFade * (sceneZ-partZ));
				i.color.a *= fade;
				#endif
				
				half4 col = i.color * tex2D(_MainTex, i.texcoord);
				col.rgb *= col.a;
				UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0)); // fog towards black due to our blend mode
				half4 bgcolor = tex2Dproj(_BackGround, i.grabPos/_Scale);
				float4 hsbcColor = applyHSBCEffect(bgcolor, i.hsbc);
				hsbcColor.rgb *= col.a;

				return hsbcColor;
			}
			ENDCG 
		}
	} 
}
}
