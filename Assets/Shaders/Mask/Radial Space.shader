// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.32 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.32;sub:START;pass:START;ps:flbk:,iptp:1,cusa:True,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:True,tesm:0,olmd:1,culm:2,bsrc:0,bdst:6,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1873,x:33801,y:32813,varname:node_1873,prsc:2|emission-6494-OUT;n:type:ShaderForge.SFN_TexCoord,id:17,x:31761,y:32672,varname:node_17,prsc:2,uv:0;n:type:ShaderForge.SFN_RemapRange,id:7595,x:32225,y:32637,varname:node_7595,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-17-UVOUT;n:type:ShaderForge.SFN_ComponentMask,id:7124,x:32386,y:32740,varname:uv,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-7595-OUT;n:type:ShaderForge.SFN_ArcTan2,id:5503,x:32572,y:32762,varname:node_5503,prsc:2,attp:0|A-7124-G,B-7124-R;n:type:ShaderForge.SFN_Add,id:8503,x:32955,y:32867,varname:node_8503,prsc:2|A-8636-OUT,B-9770-OUT;n:type:ShaderForge.SFN_Vector1,id:9770,x:32786,y:32985,varname:node_9770,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Length,id:4932,x:32817,y:32654,varname:node_4932,prsc:2|IN-7595-OUT;n:type:ShaderForge.SFN_Append,id:7598,x:33201,y:32843,varname:node_7598,prsc:2|A-4932-OUT,B-8503-OUT;n:type:ShaderForge.SFN_Tex2d,id:9392,x:33416,y:32868,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_9392,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bfa2cfa83382f224a9d37b7cf9a97a47,ntxv:0,isnm:False|UVIN-7598-OUT;n:type:ShaderForge.SFN_Step,id:9871,x:33526,y:33109,varname:node_9871,prsc:2|A-9392-R,B-6455-OUT;n:type:ShaderForge.SFN_Slider,id:6455,x:32983,y:33182,ptovrint:False,ptlb:Thickness,ptin:_Thickness,varname:node_6455,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Divide,id:8636,x:32737,y:32838,varname:node_8636,prsc:2|A-5503-OUT,B-9726-OUT;n:type:ShaderForge.SFN_Vector1,id:9726,x:32534,y:32960,varname:node_9726,prsc:2,v1:6.283185;n:type:ShaderForge.SFN_Multiply,id:6494,x:33655,y:32699,varname:node_6494,prsc:2|A-3612-OUT,B-9871-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3355,x:32350,y:32604,ptovrint:False,ptlb:node_3355,ptin:_node_3355,varname:node_3355,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Step,id:3612,x:33515,y:32551,varname:node_3612,prsc:2|A-4932-OUT,B-6975-OUT;n:type:ShaderForge.SFN_Slider,id:6975,x:33139,y:32626,ptovrint:False,ptlb:NoiseRadius,ptin:_NoiseRadius,varname:node_6975,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;proporder:9392-6455-3355-6975;pass:END;sub:END;*/

Shader "Shader Forge/Radial" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Thickness ("Thickness", Range(0, 1)) = 0.25
        _NoiseRadius ("Noise Radius", Range(0, 1)) = 1
        _CircleRadius("Circle Radius", Range(0, 1)) = 0.5
        _Speed("Speed",Float) = 0.5

    }
    SubShader {
Tags {"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent"}
ZWrite Off Blend SrcAlpha OneMinusSrcAlpha Cull Off


        Pass {

            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #pragma multi_compile _ PIXELSNAP_ON
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Thickness,_NoiseRadius,_CircleRadius;
float _Speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;

            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;

                o.pos = UnityObjectToClipPos(v.vertex );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {

                float2 uv = (i.uv0*2.0+-1.0);//Remapping uv from [0,1] to [-1,1]
                float circleMask = step(length(uv),_NoiseRadius);//Making circle by LENGTH of the vector from the pixel to the center
                float circleMiddle = step(length(uv),_CircleRadius);//Making circle by LENGTH of the vector from the pixel to the center
                float2 polaruv = float2(length(uv),((atan2(uv.g,uv.r)/6.283185)+0.5));//Making Polar
                polaruv += _Time.y*_Speed/10;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(polaruv, _MainTex));//BackGround Noise
                float Noise = (circleMask*step(_MainTex_var.r,_Thickness));//Masking Background Noise
                float3 finalColor = float3(Noise,Noise,Noise);
                return fixed4(finalColor+circleMiddle,(finalColor+circleMiddle).r);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
