// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Arkhhams/Mobile/Screens"
{
	Properties
	{
		_BaseR("Base (R)", 2D) = "white" {}
		_Base("Base", 2D) = "white" {}
		_BaseB("Base (B)", 2D) = "white" {}
		_FPS("FPS", Float) = 0
		_MaxFrames("MaxFrames", Float) = 0
		_W("W", Float) = 0
		_H("H", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows noambient novertexlights nofog 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseR);
		uniform half _W;
		uniform half _H;
		uniform half _FPS;
		uniform half _MaxFrames;
		SamplerState sampler_BaseR;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Base);
		SamplerState sampler_Base;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseB);
		uniform half4 _BaseB_ST;
		SamplerState sampler_BaseB;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half temp_output_4_0_g1 = _W;
			half temp_output_5_0_g1 = _H;
			half2 appendResult7_g1 = (half2(temp_output_4_0_g1 , temp_output_5_0_g1));
			float totalFrames39_g1 = ( temp_output_4_0_g1 * temp_output_5_0_g1 );
			half2 appendResult8_g1 = (half2(totalFrames39_g1 , temp_output_5_0_g1));
			half clampResult42_g1 = clamp( floor( ( ( _FPS * _Time.y ) % _MaxFrames ) ) , 0.0001 , ( totalFrames39_g1 - 1.0 ) );
			half temp_output_35_0_g1 = frac( ( ( _Time.y + clampResult42_g1 ) / totalFrames39_g1 ) );
			half2 appendResult29_g1 = (half2(temp_output_35_0_g1 , ( 1.0 - temp_output_35_0_g1 )));
			half2 temp_output_15_0_g1 = ( ( i.uv_texcoord / appendResult7_g1 ) + ( floor( ( appendResult8_g1 * appendResult29_g1 ) ) / appendResult7_g1 ) );
			half2 temp_output_75_0 = temp_output_15_0_g1;
			half4 lerpResult5 = lerp( SAMPLE_TEXTURE2D( _BaseR, sampler_BaseR, temp_output_75_0 ) , SAMPLE_TEXTURE2D( _Base, sampler_Base, temp_output_75_0 ) , i.vertexColor.g);
			float2 uv_BaseB = i.uv_texcoord * _BaseB_ST.xy + _BaseB_ST.zw;
			half4 lerpResult6 = lerp( lerpResult5 , SAMPLE_TEXTURE2D( _BaseB, sampler_BaseB, uv_BaseB ) , i.vertexColor.b);
			o.Emission = lerpResult6.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	
}
/*ASEBEGIN
Version=18401
2162;100;1462;706;771.9337;218.6787;1.419171;True;False
Node;AmplifyShaderEditor.TimeNode;69;-933.3252,160.5065;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-878.3256,80.50639;Inherit;False;Property;_FPS;FPS;3;0;Create;True;0;0;False;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-644.3254,134.5064;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-669.3254,227.5064;Inherit;False;Property;_MaxFrames;MaxFrames;4;0;Create;True;0;0;False;0;False;0;144;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;72;-470.325,132.5064;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;8;-23.6082,316.3351;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-303.7181,-63.89833;Inherit;False;Property;_W;W;5;0;Create;True;0;0;False;0;False;0;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-307.7031,23.09423;Inherit;False;Property;_H;H;6;0;Create;True;0;0;False;0;False;0;16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;74;-295.8818,130.5064;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;11;179.8392,276.052;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;75;-108.8772,-16.38366;Inherit;False;Flipbook;-1;;1;53c2488c220f6564ca6c90721ee16673;2,71,0,68,0;8;51;SAMPLER2D;0.0;False;13;FLOAT2;0,0;False;4;FLOAT;3;False;5;FLOAT;3;False;24;FLOAT;0;False;2;FLOAT;0;False;55;FLOAT;0;False;70;FLOAT;0;False;5;COLOR;53;FLOAT2;0;FLOAT;47;FLOAT;48;FLOAT;62
Node;AmplifyShaderEditor.WireNode;13;174.9154,500.7758;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;9;463.8718,270.9502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;208.5803,-118.3377;Inherit;True;Property;_BaseR;Base (R);0;0;Create;True;0;0;False;0;False;-1;None;8e06922f65014504bb57d5f3861364bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;208.5793,88.01437;Inherit;True;Property;_Base;Base;1;0;Create;True;0;0;False;0;False;-1;None;f089c22392007754fb4fffe4e24eb554;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;5;602.4991,22.01161;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;10;462.5252,504.0126;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;204.7508,322.2268;Inherit;True;Property;_BaseB;Base (B);2;0;Create;True;0;0;False;0;False;-1;None;3bcd2231796730343b608d0050beced9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;6;815.6395,254.5336;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1030.639,252.8405;Half;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Arkhhams/Mobile/Screens;False;False;False;False;True;True;False;False;False;True;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;71;0;70;0
WireConnection;71;1;69;2
WireConnection;72;0;71;0
WireConnection;72;1;73;0
WireConnection;74;0;72;0
WireConnection;11;0;8;2
WireConnection;75;4;76;0
WireConnection;75;5;77;0
WireConnection;75;24;74;0
WireConnection;13;0;8;3
WireConnection;9;0;11;0
WireConnection;1;1;75;0
WireConnection;2;1;75;0
WireConnection;5;0;1;0
WireConnection;5;1;2;0
WireConnection;5;2;9;0
WireConnection;10;0;13;0
WireConnection;6;0;5;0
WireConnection;6;1;3;0
WireConnection;6;2;10;0
WireConnection;0;2;6;0
ASEEND*/
//CHKSM=5BF3D8B8C6745C5E60C0FF2AC32D780E7EB215DF